import 'package:lykke_mobile_mavn/library_analytics/network_analytics_event.dart';
import 'package:test/test.dart';

void main() {
  group('Network Analytics Event', () {
    const stubFeature = 'stubFeature';
    const stubPath = 'stubPath';
    const stubMethod = 'POST';
    const stubOutcome = Outcome.timeoutError;
    const stubResponseCode = 123;
    const success = false;

    test('return a map', () {
      final subject = NetworkAnalyticsEvent(
        feature: stubFeature,
        path: stubPath,
        method: stubMethod,
        outcome: stubOutcome,
        responseCode: stubResponseCode,
        success: success,
      );

      final expected = <String, dynamic>{
        'feature': stubFeature,
        'path': stubPath,
        'method': stubMethod,
        'outcome': 'timeout_error',
        'response_code': stubResponseCode,
        'success': 0
      };

      final actual = subject.eventParametersMap;

      expect(subject.eventName, 'networking_event');
      expect(actual, expected);
    });
  });
}
