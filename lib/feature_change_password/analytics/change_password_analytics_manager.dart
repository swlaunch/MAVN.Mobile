import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/feature_change_password/di/change_password_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ChangePasswordAnalyticsManager {
  ChangePasswordAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> changePasswordDone() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'change_password_success',
          feature: Feature.changePassword,
          success: true,
        ),
      );

  Future<void> changePasswordFailed() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'change_password_failed',
          feature: Feature.changePassword,
          success: false,
        ),
      );
}

ChangePasswordAnalyticsManager useChangePasswordAnalyticsManager() =>
    ModuleProvider.of<ChangePasswordModule>(useContext())
        .changePasswordAnalyticsManager;
