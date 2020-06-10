import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/analytics/bottom_bar_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/view/floating_action_button_location.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager_mixin.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/app_lifecycle_hook.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/on_dispose_hook.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/qr_content_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class BottomBarPage extends HookWidget with DynamicLinkManagerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bottomBarAnalyticsManager = useBottomBarAnalyticsManager();
    final bottomBarPageBloc = useBottomBarPageBloc();
    final balanceBloc = useBalanceBloc();
    final walletBloc = useWalletBloc();
    final hotelReferralBloc = useAcceptHotelReferralBloc();
    final voucherPurchaseSuccessBloc = useVoucherPurchaseSuccessBloc();
    final firebaseMessagingBloc = useFirebaseMessagingBloc();
    final customerBloc = useCustomerBloc();
    final dynamicLinkManager = useDynamicLinkManager();
    final router = useRouter();
    final qrContentManager = useQrContentManager();
    startListenOnceForDynamicLinks();

    useEffect(() {
      firebaseMessagingBloc.init();
      bottomBarPageBloc.init();
      balanceBloc.init();
      customerBloc.getCustomer();
    }, [bottomBarPageBloc, balanceBloc, firebaseMessagingBloc, customerBloc]);

    useOnDispose(() {
      balanceBloc.logout();
    });

    final currentTabIndexState = useState(0);

    final bottomBarModule = ModuleProvider.of<BottomBarModule>(context);
    final pageList = [
      bottomBarModule.homePage,
      bottomBarModule.offersPage,
      // Since we add a transparent bottom navigation item,
      // we add an empty container in the page list
      Container(),
      bottomBarModule.voucherWalletPage,
      bottomBarModule.socialPage,
    ];

    List<Widget> offStagePageList(List<Widget> pageList, int tabIndex) {
      var index = 0;
      final newPageList = <Widget>[];
      pageList.forEach((page) {
        newPageList.add(
          TickerMode(
            enabled: tabIndex == index,
            child: Offstage(
              child: page,
              offstage: tabIndex != index,
            ),
          ),
        );
        index++;
      });
      return newPageList;
    }

    final onNavigateToTabCallback = useMemoized(() => () {
          _onNavigatedToTabAtIndex(
            tabIndex: currentTabIndexState.value,
            bottomBarAnalyticsManager: bottomBarAnalyticsManager,
            bottomBarPageBloc: bottomBarPageBloc,
          );
        });

    currentTabIndexState
      ..removeListener(onNavigateToTabCallback)
      ..addListener(onNavigateToTabCallback);

    useAppLifecycle((appLifecycleState) {
      if (appLifecycleState == AppLifecycleState.paused) {
        balanceBloc.pause();
      }

      if (appLifecycleState == AppLifecycleState.resumed) {
        balanceBloc.resume();
        walletBloc.fetchWallet();
      }
    });

    useBlocEventListener(hotelReferralBloc, (event) {
      dynamicLinkManager.routePendingRequests(fromEvent: event);
    });

    useBlocEventListener(voucherPurchaseSuccessBloc, (event) {
      dynamicLinkManager.routePendingRequests(fromEvent: event);
    });

    useBlocEventListener(balanceBloc, (event) {
      if (event is BalanceUpdatedEvent) {
        walletBloc.fetchWallet();
      }
    });

    useEffect(() {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        dynamicLinkManager.routePendingRequests();
      });
    }, [_scaffoldKey]);

    return WillPopScope(
      onWillPop: () {
        if (currentTabIndexState.value != 0) {
          currentTabIndexState.value = 0;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: Container(
              width: 56,
              height: 56,
              child: FittedBox(
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: ColorStyles.bitterSweet,
                  onPressed: () => _openScanPage(
                      LocalizedStrings.of(context), router, qrContentManager),
                  child: const StandardSizedSvg(
                    SvgAssets.qrCode,
                    color: ColorStyles.white,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                const CenterDockedFloatingActionButtonLocation(),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 24,
              color: ColorStyles.white,
              child: _buildBottomNavigationBar(
                context,
                currentTabIndexState,
              ),
            ),
            body: IndexedStack(
                index: currentTabIndexState.value,
                children:
                    offStagePageList(pageList, currentTabIndexState.value)),
          )),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ValueNotifier<int> currentIndexState,
  ) =>
      Container(
        padding: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: ColorStyles.white,
          border: Border(
            top: BorderSide(width: 2, color: ColorStyles.grayNurse),
          ),
        ),
        child: BottomNavigationBar(
          key: ModuleProvider.of<AppModule>(context).bottomBarGlobalKey,
          items: [
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarExplore,
              assetString: SvgAssets.search,
              valueKey: 'exploreTab',
            ),
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarOffers,
              assetString: SvgAssets.announce,
              valueKey: 'offersTab',
            ),
            _buildBottomNavigationBarItem(
              title: '',
              assetString: SvgAssets.transparent,
              valueKey: 'transparentTab',
            ),
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarWallet,
              assetString: SvgAssets.wallet,
              valueKey: 'walletTab',
            ),
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarSocial,
              assetString: SvgAssets.socialIcon,
              valueKey: 'socialTab',
            ),
          ],
          selectedItemColor: ColorStyles.vividTangerine,
          unselectedItemColor: ColorStyles.dustyGray,
          backgroundColor: ColorStyles.white,
          currentIndex: currentIndexState.value,
          type: BottomNavigationBarType.fixed,
          //https://github.com/flutter/flutter/issues/21688
          elevation: 0,
          onTap: (newIndex) {
            if (newIndex == BottomBarNavigationConstants.transparentPageIndex) {
              return;
            }

            currentIndexState.value = newIndex;
          },
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      );

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    @required String title,
    @required String assetString,
    @required String valueKey,
  }) =>
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: StandardSizedSvg(
            assetString,
            color: ColorStyles.dustyGray,
          ),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: StandardSizedSvg(
            assetString,
            color: ColorStyles.vividTangerine,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Text(
            title,
            key: Key(valueKey),
            style: TextStyles.bottomBarItemText,
          ),
        ),
      );

  void _onNavigatedToTabAtIndex({
    int tabIndex,
    BottomBarAnalyticsManager bottomBarAnalyticsManager,
    BottomBarPageBloc bottomBarPageBloc,
  }) {
    bottomBarPageBloc.bottomBarIndexChanged(tabIndex);
    switch (tabIndex) {
      case BottomBarNavigationConstants.homePageIndex:
        {
          bottomBarAnalyticsManager.navigatedToHomeTab();
          break;
        }
      case BottomBarNavigationConstants.offersPageIndex:
        {
          bottomBarAnalyticsManager.navigatedToOffersTab();
          break;
        }
      case BottomBarNavigationConstants.walletPageIndex:
        {
          bottomBarAnalyticsManager.navigatedToWalletTab();
          break;
        }

      case BottomBarNavigationConstants.socialRulePageIndex:
        {
          bottomBarAnalyticsManager.navigatedToSocialTab();
          break;
        }
    }
  }

  Future<void> _openScanPage(
    LocalizedStrings localizedStrings,
    Router router,
    QrContentManager qrContentManager,
  ) async {
    final scannedInfo = await BarcodeScanManager().startScan();
    final action = await qrContentManager.getQrAction(scannedInfo);

    if (await action.validate(scannedInfo)) {
      await router.showScannedInfoDialog(localizedStrings, action);
    } else {
      await router.showScannedInfoErrorDialog(localizedStrings, action);
    }
  }
}
