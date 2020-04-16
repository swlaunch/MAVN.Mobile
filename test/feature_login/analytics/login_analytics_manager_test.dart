import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_login/anaytics/login_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

AnalyticsService _mockAnalyticsService = MockAnalyticsService();

LoginAnalyticsManager _subject = LoginAnalyticsManager(_mockAnalyticsService);

AnalyticsEvent _capturedAnalyticsEvent;

const String loginFeature = 'login';

void main() {
  group('LoginAnalyticsManager tests', () {
    test('submitButtonTapped', () async {
      await _subject.submitButtonTapped();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'submit_tap');
      expect(_capturedAnalyticsEvent.feature, loginFeature);
    });

    test('emailKeyboardNextButtonTapped', () async {
      await _subject.emailKeyboardNextButtonTapped();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'email_keyboard_next_tap');
      expect(_capturedAnalyticsEvent.feature, loginFeature);
    });

    test('passwordKeyboardDoneButtonTapped', () async {
      await _subject.passwordKeyboardDoneButtonTapped();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'password_keyboard_done_tap');
      expect(_capturedAnalyticsEvent.feature, loginFeature);
    });

    test('emailInvalidClientValidationError', () async {
      await _subject.emailInvalidClientValidationError();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'email_invalid_client_error');
      expect(_capturedAnalyticsEvent.feature, loginFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('emailEmptyClientValidationError', () async {
      await _subject.emailEmptyClientValidationError();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'email_empty_client_error');
      expect(_capturedAnalyticsEvent.feature, loginFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('passwordEmptyClientValidationError', () async {
      await _subject.passwordEmptyClientValidationError();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'password_empty_client_error');
      expect(_capturedAnalyticsEvent.feature, loginFeature);
      expect(_capturedAnalyticsEvent.success, false);
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
