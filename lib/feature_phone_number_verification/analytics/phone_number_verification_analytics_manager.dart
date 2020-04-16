import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/di/phone_number_verification_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PhoneNumberVerificationAnalyticsManager {
  PhoneNumberVerificationAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> phoneVerificationSuccessful() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'phone_verification_successful',
          feature: Feature.phoneNumberVerification,
        ),
      );

  Future<void> verificationCodeSent() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'phone_verification_code_sent',
          feature: Feature.phoneNumberVerification,
        ),
      );

  Future<void> sendVerificationCodeTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'send_phone_verification_code_tap',
          feature: Feature.phoneNumberVerification,
        ),
      );

  Future<void> requestNewVerificationCodeTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'request_new_phone_verification_code_tap',
          feature: Feature.phoneNumberVerification,
        ),
      );

  Future<void> verifyCodeTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'verify_phone_verification_code_tap',
          feature: Feature.phoneNumberVerification,
        ),
      );

  Future<void> registerWithAnotherAccountTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'phone_verif_reg_with_another_account_tap',
          feature: Feature.phoneNumberVerification,
        ),
      );
}

PhoneNumberVerificationAnalyticsManager usePhoneNumberAnalyticsManager() =>
    ModuleProvider.of<PhoneNumberVerificationModule>(useContext())
        .phoneNumberVerificationAnalyticsManager;
