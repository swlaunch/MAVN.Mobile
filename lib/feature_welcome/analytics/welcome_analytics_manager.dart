import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/feature_welcome/di/welcome_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class WelcomeAnalyticsManager {
  WelcomeAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> createAccountTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'welcome_page_create_account_tap',
          feature: Feature.welcome,
        ),
      );

  Future<void> signInTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'welcome_page_sign_in_tap',
          feature: Feature.welcome,
        ),
      );
}

WelcomeAnalyticsManager useWelcomeAnalyticsManager() =>
    ModuleProvider.of<WelcomeModule>(useContext()).welcomeAnalyticsManager;
