import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/feature_register/di/register_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class RegisterAnalyticsManager {
  RegisterAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> nextButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'register_form_page1_next_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> registrationSuccessful() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'registration_successful',
          feature: Feature.registration,
        ),
      );

  Future<void> submitButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'register_form_page2_submit_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> emailKeyboardNextButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_keyboard_next_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> firstNameKeyboardNextButtonTapped() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'first_name_keyboard_next_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> lastNameKeyboardNextButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'last_name_keyboard_next_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> passwordKeyboardNextButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'password_keyboard_next_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> confirmPasswordKeyboardDoneButtonTapped() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'confirm_password_keyboard_done_tap',
          feature: Feature.registration,
        ),
      );

  Future<void> emailInvalidClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_invalid_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> emailEmptyClientValidationError() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_empty_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> firstNameInvalidClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'first_name_invalid_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> lastNameInvalidClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'last_name_invalid_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> passwordInvalidClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'password_invalid_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> passwordsDoNotMatchClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'passwords_do_not_match_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> passwordEmptyClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'password_empty_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> nationalityEmptyClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'nationality_empty_client_error',
          feature: Feature.registration,
          success: false,
        ),
      );

  Future<void> policiesCheckboxUncheckedClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'register_tcs_checkbox_unchecked_error',
          feature: Feature.registration,
          success: false,
        ),
      );
}

RegisterAnalyticsManager useRegisterAnalyticsManager() =>
    ModuleProvider.of<RegisterModule>(useContext()).registerAnalyticsManager;
