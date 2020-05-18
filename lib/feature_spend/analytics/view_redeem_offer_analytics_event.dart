import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event_names.dart';

class ViewRedeemOfferAnalyticsEvent extends AnalyticsEvent {
  ViewRedeemOfferAnalyticsEvent({
    @required this.businessVertical,
    @required this.offerId,
  }) : super(
          success: true,
          eventName: AnalyticsEventName.viewRedeemOffer,
          feature: Feature.redeem,
        );

  final OfferVertical businessVertical;
  final String offerId;

  @override
  List get props => super.props..addAll([businessVertical, offerId]);

  @override
  Map<String, dynamic> get eventParametersMap => super.eventParametersMap
    ..addAll({
      if (businessVertical != null)
        'business_vertical': businessVertical.toString(),
      'offer_id': offerId,
    });
}
