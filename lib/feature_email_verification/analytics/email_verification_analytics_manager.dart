import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EmailVerificationAnalyticsManager {
  EmailVerificationAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> emailVerificationSuccessful() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_verification_successful',
          feature: Feature.emailVerification,
        ),
      );

  Future<void> resendLinkTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_verif_resend_link_tap',
          feature: Feature.emailVerification,
        ),
      );

  Future<void> registerWithAnotherAccountTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'email_verif_reg_with_another_account_tap',
          feature: Feature.emailVerification,
        ),
      );
}

EmailVerificationAnalyticsManager useEmailVerificationAnalyticsManager() =>
    ModuleProvider.of<AppModule>(useContext())
        .emailVerificationAnalyticsManager;
