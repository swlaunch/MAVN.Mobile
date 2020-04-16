import 'package:lykke_mobile_mavn/feature_onboarding/analytics/onboarding_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class OnboardingModule extends Module {
  OnboardingAnalyticsManager get onboardingAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => Stopwatch());
    provideSingleton(() => OnboardingAnalyticsManager(get(), get()));
  }
}
