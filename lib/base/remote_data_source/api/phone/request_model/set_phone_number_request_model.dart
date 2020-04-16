import 'package:flutter/material.dart';

class SetPhoneNumberRequestModel {
  SetPhoneNumberRequestModel({
    @required this.phoneNumber,
    @required this.countryPhoneCodeId,
  });

  final String phoneNumber;
  final int countryPhoneCodeId;

  Map<String, dynamic> toJson() =>
      {'PhoneNumber': phoneNumber, 'CountryPhoneCodeId': countryPhoneCodeId};
}
