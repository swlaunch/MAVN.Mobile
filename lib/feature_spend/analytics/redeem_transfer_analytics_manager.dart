import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/feature_spend/analytics/redeem_transfer_analytics_event.dart';
import 'package:lykke_mobile_mavn/feature_spend/di/transfer_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class RedeemTransferAnalyticsManager {
  RedeemTransferAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> transferToken({@required OfferVertical businessVertical}) =>
      _analyticsService.logEvent(
        analyticsEvent: RedeemTransferTokenAnalyticsEvent(
            businessVertical: businessVertical),
      );
}

RedeemTransferAnalyticsManager useRedeemTransferAnalyticsManager() =>
    ModuleProvider.of<RedeemTransferModule>(useContext())
        .redeemTransferAnalyticsManager;
