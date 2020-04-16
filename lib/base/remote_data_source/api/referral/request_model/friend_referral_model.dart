import 'package:flutter/foundation.dart';

class FriendReferralRequestModel {
  FriendReferralRequestModel({
    @required this.fullName,
    @required this.email,
    @required this.earnRuleId,
  });

  final String fullName;
  final String email;
  final String earnRuleId;

  Map<String, dynamic> toJson() => {
        'FullName': fullName,
        'Email': email,
        'CampaignId': earnRuleId,
      };
}
