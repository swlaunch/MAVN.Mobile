import 'package:flutter/foundation.dart';

class SmeLinkingRequestModel {
  SmeLinkingRequestModel({
    @required this.partnerCode,
    @required this.linkingCode,
  });

  final String partnerCode;
  final String linkingCode;

  Map<String, dynamic> toJson() => {
        'PartnerCode': partnerCode,
        'PartnerLinkingCode': linkingCode,
      };
}
