import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/feature_Earn/analytics/view_earn_offer_analytics_event.dart';
import 'package:lykke_mobile_mavn/feature_earn/analytics/start_earn_offer_analytics_event.dart';
import 'package:lykke_mobile_mavn/feature_earn/di/earn_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EarnAnalyticsManager {
  EarnAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> earnRuleTapped({
    @required String offerId,
    @required EarnRuleConditionType conditionType,
  }) =>
      _analyticsService.logEvent(
        analyticsEvent: ViewEarnOfferAnalyticsEvent(
          conditionType: conditionType,
          offerId: offerId,
        ),
      );

  Future<void> earnRuleStarted({
    @required String offerId,
    @required EarnRuleConditionType conditionType,
  }) =>
      _analyticsService.logEvent(
        analyticsEvent: StartEarnOfferAnalyticsEvent(
          conditionType: conditionType,
          offerId: offerId,
        ),
      );
}

EarnAnalyticsManager useEarnAnalyticsManager() =>
    ModuleProvider.of<EarnModule>(useContext()).earnAnalyticsManager;
