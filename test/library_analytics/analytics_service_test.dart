import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_analytics/network_analytics_event.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mock_classes.dart';

void main() {
  group('Analytics Service', () {
    final mockFirebaseAnalytics = MockFirebaseAnalytics();
    final subject = AnalyticsService(mockFirebaseAnalytics);
    const stubPath = 'stubPath';
    const stubMethod = 'POST';
    const stubOutcome = Outcome.timeoutError;
    const stubResponseCode = 123;
    const success = false;

    final stubAnalyticsEvent = NetworkAnalyticsEvent(
      path: stubPath,
      method: stubMethod,
      outcome: stubOutcome,
      responseCode: stubResponseCode,
      success: success,
    );

    test('send event to firebase analytics', () {
      subject.logEvent(analyticsEvent: stubAnalyticsEvent);

      expect(
        verify(
          mockFirebaseAnalytics.logEvent(
            name: stubAnalyticsEvent.eventName,
            parameters: stubAnalyticsEvent.eventParametersMap,
          ),
        ).callCount,
        1,
      );
    });
  });
}
