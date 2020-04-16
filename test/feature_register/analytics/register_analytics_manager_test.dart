import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_register/analytics/register_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

AnalyticsService _mockAnalyticsService = MockAnalyticsService();

RegisterAnalyticsManager _subject =
    RegisterAnalyticsManager(_mockAnalyticsService);

AnalyticsEvent _capturedAnalyticsEvent;

const registerFeature = 'registration';

void main() {
  group('RegisterAnalyticsManager tests', () {
    test('submitButtonTapped', () async {
      await _subject.submitButtonTapped();

      thenAnalyticsServiceCalled();

      expect(
          _capturedAnalyticsEvent.eventName, 'register_form_page2_submit_tap');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
    });

    test('emailKeyboardNextButtonTapped', () async {
      await _subject.emailKeyboardNextButtonTapped();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'email_keyboard_next_tap');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
    });

    test('firstNameKeyboardNextButtonTapped', () async {
      await _subject.firstNameKeyboardNextButtonTapped();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'first_name_keyboard_next_tap');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
    });

    test('lastNameKeyboardNextButtonTapped', () async {
      await _subject.lastNameKeyboardNextButtonTapped();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'last_name_keyboard_next_tap');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
    });

    test('passwordKeyboardNextButtonTapped', () async {
      await _subject.passwordKeyboardNextButtonTapped();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'password_keyboard_next_tap');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
    });

    test('confirmPasswordKeyboardDoneButtonTapped', () async {
      await _subject.confirmPasswordKeyboardDoneButtonTapped();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName,
          'confirm_password_keyboard_done_tap');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
    });

    test('emailInvalidClientValidationError', () async {
      await _subject.emailInvalidClientValidationError();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'email_invalid_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('emailEmptyClientValidationError', () async {
      await _subject.emailEmptyClientValidationError();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'email_empty_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('firstNameInvalidClientValidationError', () async {
      await _subject.firstNameInvalidClientValidationError();

      thenAnalyticsServiceCalled();

      expect(
          _capturedAnalyticsEvent.eventName, 'first_name_invalid_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('lastNameInvalidClientValidationError', () async {
      await _subject.lastNameInvalidClientValidationError();

      thenAnalyticsServiceCalled();

      expect(
          _capturedAnalyticsEvent.eventName, 'last_name_invalid_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('passwordInvalidClientValidationError', () async {
      await _subject.passwordInvalidClientValidationError();

      thenAnalyticsServiceCalled();

      expect(
          _capturedAnalyticsEvent.eventName, 'password_invalid_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('passwordEmptyClientValidationError', () async {
      await _subject.passwordEmptyClientValidationError();

      thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'password_empty_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });

    test('nationalityEmptyClientValidationError', () async {
      await _subject.nationalityEmptyClientValidationError();

      thenAnalyticsServiceCalled();

      expect(
          _capturedAnalyticsEvent.eventName, 'nationality_empty_client_error');
      expect(_capturedAnalyticsEvent.feature, registerFeature);
      expect(_capturedAnalyticsEvent.success, false);
    });
  });
}

/// THEN ///

void thenAnalyticsServiceCalled() {
  final verificationResult = verify(_mockAnalyticsService.logEvent(
      analyticsEvent: captureAnyNamed('analyticsEvent')));
  expect(verificationResult.callCount, 1);
  _capturedAnalyticsEvent = verificationResult.captured[0] as AnalyticsEvent;
}
