import 'package:lykke_mobile_mavn/feature_welcome/analytics/welcome_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class WelcomeModule extends Module {
  WelcomeAnalyticsManager get welcomeAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => WelcomeAnalyticsManager(get()));
  }
}
