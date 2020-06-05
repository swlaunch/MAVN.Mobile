import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/analytics/onboarding_completed_analytics_event.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/di/onboarding_module.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/view/onboarding_page.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class OnboardingAnalyticsManager {
  OnboardingAnalyticsManager(this._analyticsService, this._stopwatch) {
    _reset();
  }

  final AnalyticsService _analyticsService;
  final Stopwatch _stopwatch;

  @visibleForTesting
  Map<String, int> onboardingPagesViewTimesMillis = {};

  void onboardingPageChanged({@required int previousPage}) {
    if (previousPage > 0 && previousPage <= OnboardingPage.pageDataLength) {
      _addMillisToPage(previousPage);
    }
    _stopwatch
      ..reset()
      ..start();
  }

  Future<void> onboardingSkipped({@required int skippedPage}) =>
      _finishOnboardingAtPage(page: skippedPage);

  Future<void> onboardingCompleted() =>
      _finishOnboardingAtPage(page: OnboardingPage.pageDataLength);

  Future<void> _finishOnboardingAtPage({@required int page}) async {
    _addMillisToPage(page);
    await _logEvent();
    _reset();
  }

  Future _logEvent() async {
    await _analyticsService.logEvent(
      analyticsEvent:
          OnboardingCompletedAnalyticsEvent(onboardingPagesViewTimesMillis),
    );
  }

  void _reset() {
    _stopwatch.reset();
    onboardingPagesViewTimesMillis = {};
    for (var i = 0; i < OnboardingPage.pageDataLength; i++) {
      onboardingPagesViewTimesMillis.addAll({_entryKey(i + 1): 0});
    }
  }

  void _addMillisToPage(int page) {
    if (onboardingPagesViewTimesMillis.containsKey(_entryKey(page))) {
      onboardingPagesViewTimesMillis[_entryKey(page)] =
          onboardingPagesViewTimesMillis[_entryKey(page)] +
              _stopwatch.elapsedMilliseconds;
    } else {
      onboardingPagesViewTimesMillis
          .addAll({_entryKey(page): _stopwatch.elapsedMilliseconds});
    }
  }

  String _entryKey(int page) => 'page_${page}_view_time';
}

OnboardingAnalyticsManager useOnboardingAnalyticsManager() =>
    ModuleProvider.of<OnboardingModule>(useContext())
        .onboardingAnalyticsManager;
