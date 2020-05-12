import 'package:flutter/cupertino.dart';

class VoucherPurchaseRequestModel {
  VoucherPurchaseRequestModel({@required this.campaignId});

  final String campaignId;

  Map<String, dynamic> toJson() => {
        'SmartVoucherCampaignId': campaignId,
      };
}
