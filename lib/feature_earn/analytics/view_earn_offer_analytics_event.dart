import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event_names.dart';

class ViewEarnOfferAnalyticsEvent extends AnalyticsEvent {
  ViewEarnOfferAnalyticsEvent({
    @required this.conditionType,
    @required this.offerId,
  }) : super(
          success: true,
          eventName: AnalyticsEventName.viewEarnOffer,
          feature: Feature.earn,
        );

  final EarnRuleConditionType conditionType;
  final String offerId;

  @override
  List get props => super.props..addAll([conditionType, offerId]);

  @override
  Map<String, dynamic> get eventParametersMap => super.eventParametersMap
    ..addAll({
      if (conditionType != null) 'condition_type': conditionType.toString(),
      'offer_id': offerId,
    });
}
