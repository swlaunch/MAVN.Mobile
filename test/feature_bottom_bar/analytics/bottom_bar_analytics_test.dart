import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/router/router_page_names.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/analytics/bottom_bar_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

AnalyticsService _mockAnalyticsService = MockAnalyticsService();

BottomBarAnalyticsManager _subject =
    BottomBarAnalyticsManager(_mockAnalyticsService);

void main() {
  group('BottomBarAnalytics tests', () {
    test('navigatedToHomeTab', () async {
      await _subject.navigatedToHomeTab();

      verify(_mockAnalyticsService.setCurrentScreen(
              screenName: RouterPageName.homePage))
          .called(1);
    });
    test('navigatedToOffersTab', () async {
      await _subject.navigatedToOffersTab();

      verify(_mockAnalyticsService.setCurrentScreen(
              screenName: RouterPageName.offersPage))
          .called(1);
    });

    test('navigatedToWalletTab', () async {
      await _subject.navigatedToWalletTab();

      verify(_mockAnalyticsService.setCurrentScreen(
              screenName: RouterPageName.walletPage))
          .called(1);
    });

    test('navigatedToSocialTab', () async {
      await _subject.navigatedToSocialTab();

      verify(_mockAnalyticsService.setCurrentScreen(
              screenName: RouterPageName.socialPage))
          .called(1);
    });
  });
}
