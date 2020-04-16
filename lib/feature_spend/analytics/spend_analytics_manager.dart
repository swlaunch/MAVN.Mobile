import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/feature_spend/analytics/view_redeem_offer_analytics_event.dart';
import 'package:lykke_mobile_mavn/feature_spend/di/spend_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SpendAnalyticsManager {
  SpendAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> redeemRuleTapped({
    @required OfferVertical businessVertical,
    @required String offerId,
  }) =>
      _analyticsService.logEvent(
        analyticsEvent: ViewRedeemOfferAnalyticsEvent(
          businessVertical: businessVertical,
          offerId: offerId,
        ),
      );
}

SpendAnalyticsManager useSpendAnalyticsManager() =>
    ModuleProvider.of<SpendModule>(useContext()).spendAnalyticsManager;
