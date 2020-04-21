import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/analytics/bottom_bar_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/view/floating_action_button_location.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
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
    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);
    final bottomBarAnalyticsManager = useBottomBarAnalyticsManager();
    final bottomBarPageBloc = useBottomBarPageBloc();
    final balanceBloc = useBalanceBloc();
    final walletBloc = useWalletBloc();
    final hotelReferralBloc = useAcceptHotelReferralBloc();
    final leadReferralBloc = useAcceptLeadReferralBloc();
    final firebaseMessagingBloc = useFirebaseMessagingBloc();
    final dynamicLinkManager = useDynamicLinkManager();
    final router = useRouter();
    final qrContentManager = useQrContentManager();
    startListenOnceForDynamicLinks();

    useEffect(() {
      firebaseMessagingBloc.init();
      bottomBarPageBloc.init();
      balanceBloc.init();
    }, [bottomBarPageBloc, balanceBloc, firebaseMessagingBloc]);

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
      bottomBarModule.walletPage,
      bottomBarModule.socialPage,
    ];

    List<Widget> offStagePageList(List<Widget> pageList, int tabIndex) {
      int index = 0;
      final List<Widget> newPageList = [];
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

    useBlocEventListener(leadReferralBloc, (event) {
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
    if (themeBlocState is ThemeUninitializedState) {
      return Container();
    }
    if (themeBlocState is ThemeSelectedState) {
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
                    backgroundColor:
                        themeBlocState.theme.bottomBarNotchBackground,
                    onPressed: () => _openScanPage(
                        LocalizedStrings.of(context), router, qrContentManager),
                    child: StandardSizedSvg(SvgAssets.qrCode,
                        color: themeBlocState.theme.bottomBarNotchIcon),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  const CenterDockedFloatingActionButtonLocation(),
              bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 24,
                color: themeBlocState.theme.bottomBarBackground,
                child: _buildBottomNavigationBar(
                  context,
                  currentTabIndexState,
                  themeBlocState.theme,
                ),
              ),
              body: IndexedStack(
                  index: currentTabIndexState.value,
                  children:
                      offStagePageList(pageList, currentTabIndexState.value)),
            )),
      );
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context,
          ValueNotifier<int> currentIndexState, BaseAppTheme theme) =>
      Container(
        padding: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: theme.bottomBarBackground,
          border: Border(
            top: BorderSide(width: 2, color: theme.bottomBarBorder),
          ),
        ),
        child: BottomNavigationBar(
          key: ModuleProvider.of<AppModule>(context).bottomBarGlobalKey,
          items: [
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarExplore,
              assetString: SvgAssets.search,
              valueKey: 'exploreTab',
              theme: theme,
            ),
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarOffers,
              assetString: SvgAssets.announce,
              valueKey: 'offersTab',
              theme: theme,
            ),
            _buildBottomNavigationBarItem(
              title: '',
              assetString: SvgAssets.transparent,
              valueKey: 'transparentTab',
              theme: theme,
            ),
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarWallet,
              assetString: SvgAssets.wallet,
              valueKey: 'walletTab',
              theme: theme,
            ),
            _buildBottomNavigationBarItem(
              title: LocalizedStrings.of(context).bottomBarSocial,
              assetString: SvgAssets.socialIcon,
              valueKey: 'socialTab',
              theme: theme,
            ),
          ],
          selectedItemColor: theme.bottomBarSelected,
          unselectedItemColor: theme.bottomBarDeselected,
          backgroundColor: theme.bottomBarBackground,
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
    @required BaseAppTheme theme,
  }) =>
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: StandardSizedSvg(
            assetString,
            color: theme.bottomBarDeselected,
          ),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: StandardSizedSvg(
            assetString,
            color: theme.bottomBarSelected,
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

    await router.showScannedInfoDialog(localizedStrings, action);
  }
}
