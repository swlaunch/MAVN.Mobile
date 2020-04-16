import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/router/router_page_names.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class BottomBarAnalyticsManager {
  BottomBarAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> navigatedToHomeTab() =>
      _analyticsService.setCurrentScreen(screenName: RouterPageName.homePage);

  Future<void> navigatedToOffersTab() =>
      _analyticsService.setCurrentScreen(screenName: RouterPageName.offersPage);

  Future<void> navigatedToWalletTab() =>
      _analyticsService.setCurrentScreen(screenName: RouterPageName.walletPage);

  Future<void> navigatedToSocialTab() =>
      _analyticsService.setCurrentScreen(screenName: RouterPageName.socialPage);
}

BottomBarAnalyticsManager useBottomBarAnalyticsManager() =>
    ModuleProvider.of<BottomBarModule>(useContext()).bottomBarAnalyticsManager;
