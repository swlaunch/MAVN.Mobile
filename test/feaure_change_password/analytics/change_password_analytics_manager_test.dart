import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_change_password/analytics/change_password_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

AnalyticsService _mockAnalyticsService = MockAnalyticsService();

ChangePasswordAnalyticsManager _subject =
    ChangePasswordAnalyticsManager(_mockAnalyticsService);

AnalyticsEvent _capturedAnalyticsEvent;

const String changePasswordFeature = 'change_password';

void main() {
  group('ChangePasswordAnalyticsManager tests', () {
    test('Password changed successfully', () async {
      await _subject.changePasswordDone();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'change_password_success');
      expect(_capturedAnalyticsEvent.feature, changePasswordFeature);
    });

    test('Change password failed', () async {
      await _subject.changePasswordFailed();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'change_password_failed');
      expect(_capturedAnalyticsEvent.feature, changePasswordFeature);
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
