import 'package:lykke_mobile_mavn/feature_spend/analytics/spend_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SpendModule extends Module {
  SpendAnalyticsManager get spendAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => SpendAnalyticsManager(get()));
  }
}
