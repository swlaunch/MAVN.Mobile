import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/earn_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/constants/bottom_bar_navigation_constants.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/home_shortcut_carousel.dart';
import 'package:lykke_mobile_mavn/feature_home/view/earn_token_section.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/ui_components/notification_icon_widget.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/throttling_hook.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);
    final balanceBloc = useBalanceBloc();
    final earnRuleListBloc = useEarnRuleListBloc();
    final earnRuleListState = useBlocState<GenericListState>(earnRuleListBloc);
    final firebaseMessagingBloc = useFirebaseMessagingBloc();
    final notificationCountBloc = useNotificationCountBloc();
    final notificationCountState = useBlocState(notificationCountBloc);
    final notificationMarkAsReadBloc = useNotificationMarkAsReadBloc();
    final bottomBarPageBloc = useBottomBarPageBloc();
    final throttler = useThrottling(duration: const Duration(seconds: 30));

    final router = useRouter();

    void loadPageData() {
      earnRuleListBloc.getList();
      notificationCountBloc.getUnreadNotificationCount();
    }

    void onErrorRetry() {
      loadPageData();
      balanceBloc.retry();
    }

    useBlocEventListener(balanceBloc, (event) {
      if (event is BalanceUpdatedEvent &&
          earnRuleListState is GenericListErrorState) {
        loadPageData();
      }
    });

    useBlocEventListener(bottomBarPageBloc, (event) {
      if (event is BottomBarRefreshEvent &&
          event.index == BottomBarNavigationConstants.homePageIndex) {
        throttler.throttle(loadPageData);
      }
    });

    useBlocEventListener(firebaseMessagingBloc, (event) {
      if (event is FirebaseMessagingNotificationPendingEvent) {
        notificationCountBloc.getUnreadNotificationCount();
      } else if (event is FirebaseMessagingMarkAsReadEvent) {
        notificationMarkAsReadBloc.markAsRead(event.messageGroupId);
      }
    });

    useEffect(
      () {
        loadPageData();
      },
      [earnRuleListBloc],
    );

    final isNetworkError = [
      earnRuleListState,
      notificationCountState,
    ].any((state) => state is BaseNetworkErrorState);

    final isGenericError = [
      earnRuleListState,
    ].any((state) => state is BaseErrorState);

    final isLoading = [
      earnRuleListState,
    ].every((state) => state is BaseLoadingState);

    if (themeBlocState is ThemeUninitializedState) {
      return Container();
    }
    if (themeBlocState is ThemeSelectedState) {
      final theme = themeBlocState.theme;
      return Scaffold(
          backgroundColor: theme.appBackground,
          appBar: AppBar(
            title: SvgPicture.asset(SvgAssets.appDarkLogo),
            backgroundColor: theme.appBarBackground,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                key: const Key('homePageAccountButton'),
                tooltip: useLocalizedStrings().accountPageTitle,
                icon: StandardSizedSvg(
                  SvgAssets.user,
                  color: theme.appBarIcon,
                ),
                onPressed: router.pushAccountPage,
              ),
              IconButton(
                tooltip: useLocalizedStrings().notifications,
                icon: NotificationIconWidget(
                  color: theme.appBarIcon,
                  bubbleColor: theme.appBarBubble,
                ),
                onPressed: () {
                  router.pushNotificationListPage();
                  notificationCountBloc.markAsSeen();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (!isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _buildBody(
                      router,
                      isNetworkError,
                      isGenericError,
                      onErrorRetry,
                      earnRuleListState,
                      theme,
                    ),
                  )
                else
                  Container(),
                if (isLoading) _buildLoading(),
              ],
            ),
          ));
    }
  }

  Widget _buildBody(
    Router router,
    bool isNetworkError,
    bool isGenericError,
    VoidCallback onErrorRetry,
    GenericListState earnRuleListState,
    BaseAppTheme theme,
  ) {
    if (isNetworkError) {
      return _buildNetworkError(onErrorRetry);
    }

    if (isGenericError) {
      return _buildGenericError(onErrorRetry);
    }

    return _buildLoadedContent(
      router,
      earnRuleListState,
      onErrorRetry,
      theme,
    );
  }

  Widget _buildLoadedContent(
    Router router,
    GenericListState earnRuleListState,
    VoidCallback onErrorRetry,
    BaseAppTheme theme,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeShortcutCarouselWidget(earnRuleListState: earnRuleListState),
          const SizedBox(height: 24),
          EarnTokenSection(
            theme: theme,
            earnRuleListState: earnRuleListState,
            router: router,
            onRetryTap: onErrorRetry,
          )
        ],
      );

  Widget _buildLoading() => const SafeArea(child: Center(child: Spinner()));

  Widget _buildGenericError(VoidCallback onRetryTap) =>
      GenericErrorWidget(onRetryTap: onRetryTap);

  Widget _buildNetworkError(VoidCallback reload) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: NetworkErrorWidget(
            onRetry: reload,
          ),
        ),
      );
}
