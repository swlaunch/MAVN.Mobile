import 'package:lykke_mobile_mavn/feature_spend/analytics/redeem_transfer_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class RedeemTransferModule extends Module {
  RedeemTransferAnalyticsManager get redeemTransferAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => RedeemTransferAnalyticsManager(get()));
  }
}
