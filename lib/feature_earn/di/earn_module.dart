import 'package:lykke_mobile_mavn/feature_earn/analytics/earn_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EarnModule extends Module {
  EarnAnalyticsManager get earnAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => EarnAnalyticsManager(get()));
  }
}
