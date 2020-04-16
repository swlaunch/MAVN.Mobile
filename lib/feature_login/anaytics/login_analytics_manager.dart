import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/feature_login/di/login_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LoginAnalyticsManager {
  LoginAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> submitButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'submit_tap',
          feature: Feature.login,
        ),
      );

  Future<void> emailKeyboardNextButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_keyboard_next_tap',
          feature: Feature.login,
        ),
      );

  Future<void> passwordKeyboardDoneButtonTapped() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'password_keyboard_done_tap',
          feature: Feature.login,
        ),
      );

  Future<void> emailInvalidClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_invalid_client_error',
          feature: Feature.login,
          success: false,
        ),
      );

  Future<void> emailEmptyClientValidationError() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_empty_client_error',
          feature: Feature.login,
          success: false,
        ),
      );

  Future<void> passwordEmptyClientValidationError() =>
      _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'password_empty_client_error',
          feature: Feature.login,
          success: false,
        ),
      );
}

LoginAnalyticsManager useLoginAnalyticsManager() =>
    ModuleProvider.of<LoginModule>(useContext()).loginAnalyticsManager;
