import 'package:flutter/foundation.dart';

class HotelReferralRequestModel {
  HotelReferralRequestModel({
    @required this.fullName,
    @required this.email,
    @required this.countryPhoneCodeId,
    @required this.phoneNumber,
    @required this.earnRuleId,
  });

  final String fullName;
  final String email;
  final int countryPhoneCodeId;
  final String phoneNumber;
  final String earnRuleId;

  Map<String, dynamic> toJson() => {
        'FullName': fullName,
        'Email': email,
        'CountryPhoneCodeId': countryPhoneCodeId,
        'PhoneNumber': phoneNumber,
        'CampaignId': earnRuleId,
      };
}
