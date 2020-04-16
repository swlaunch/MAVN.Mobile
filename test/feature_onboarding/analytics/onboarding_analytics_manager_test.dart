import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/analytics/onboarding_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/analytics/onboarding_completed_analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

AnalyticsService _mockAnalyticsService = MockAnalyticsService();
Stopwatch _mockStopwatch = MockStopwatch();

OnboardingAnalyticsManager _subject;

OnboardingCompletedAnalyticsEvent _capturedAnalyticsEvent;

const String onboardingFeature = 'onboarding';

void main() {
  group('OnboardingAnalyticsManager tests', () {
    setUp(() {
      _subject =
          OnboardingAnalyticsManager(_mockAnalyticsService, _mockStopwatch);
      reset(_mockAnalyticsService);
      reset(_mockStopwatch);
      when(_mockStopwatch.elapsedMilliseconds).thenReturn(1000);
    });

    test('onboardingPageChanged called for different pages', () async {
      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 0,
        'page_2_view_time': 0,
        'page_3_view_time': 0,
        'page_4_view_time': 0,
      });

      _subject.onboardingPageChanged(previousPage: 1);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 0,
        'page_3_view_time': 0,
        'page_4_view_time': 0,
      });

      _subject.onboardingPageChanged(previousPage: 2);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 0,
        'page_4_view_time': 0,
      });

      _subject.onboardingPageChanged(previousPage: 3);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 1000,
        'page_4_view_time': 0,
      });

      _subject.onboardingPageChanged(previousPage: 4);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 1000,
        'page_4_view_time': 1000,
      });

      _subject.onboardingPageChanged(previousPage: 3);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 2000,
        'page_4_view_time': 1000,
      });

      _subject.onboardingPageChanged(previousPage: -1);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 2000,
        'page_4_view_time': 1000,
      });

      _subject.onboardingPageChanged(previousPage: -1);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 2000,
        'page_4_view_time': 1000,
      });

      _subject.onboardingPageChanged(previousPage: 5);
      verify(_mockStopwatch.reset());
      verify(_mockStopwatch.start());

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 1000,
        'page_2_view_time': 1000,
        'page_3_view_time': 2000,
        'page_4_view_time': 1000,
      });
    });

    test('onboardingCompleted', () async {
      await _subject.onboardingCompleted();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'onboarding_completed');
      expect(_capturedAnalyticsEvent.feature, onboardingFeature);
      expect(_capturedAnalyticsEvent.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 0,
        'page_2_view_time': 0,
        'page_3_view_time': 0,
        'page_4_view_time': 1000,
      });

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 0,
        'page_2_view_time': 0,
        'page_3_view_time': 0,
        'page_4_view_time': 0,
      });

      verify(_mockStopwatch.reset());
    });

    test('onboardingSkipped', () async {
      await _subject.onboardingSkipped(skippedPage: 2);

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'onboarding_completed');
      expect(_capturedAnalyticsEvent.feature, onboardingFeature);
      expect(_capturedAnalyticsEvent.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 0,
        'page_2_view_time': 1000,
        'page_3_view_time': 0,
        'page_4_view_time': 0,
      });

      expect(_subject.onboardingPagesViewTimesMillis, {
        'page_1_view_time': 0,
        'page_2_view_time': 0,
        'page_3_view_time': 0,
        'page_4_view_time': 0,
      });

      verify(_mockStopwatch.reset());
    });
  });
}

/// THEN ///

void _thenAnalyticsServiceCalled() {
  final verificationResult = verify(_mockAnalyticsService.logEvent(
      analyticsEvent: captureAnyNamed('analyticsEvent')));
  expect(verificationResult.callCount, 1);
  _capturedAnalyticsEvent = verificationResult.captured[0] as AnalyticsEvent;
}
