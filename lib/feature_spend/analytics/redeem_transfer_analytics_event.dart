import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event_names.dart';

class RedeemTransferTokenAnalyticsEvent extends AnalyticsEvent {
  RedeemTransferTokenAnalyticsEvent({@required this.businessVertical})
      : super(
          success: true,
          eventName: AnalyticsEventName.redeemTransferTokens,
          feature: Feature.redeem,
        );
  static const _offerType = 'redeem';

  final OfferVertical businessVertical;

  @override
  List get props => super.props..addAll([_offerType, businessVertical]);

  @override
  Map<String, dynamic> get eventParametersMap => super.eventParametersMap
    ..addAll({
      'offer_type': _offerType,
      if (businessVertical != null)
        'business_vertical': businessVertical.toString(),
    });
}
