import 'package:flutter/foundation.dart';

class RegisterRequestModel {
  RegisterRequestModel({
    @required this.email,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    this.countryOfNationalityId,
    this.referralCode = '',
  });

  final String email;
  final String password;
  final String referralCode;
  final String firstName;
  final String lastName;
  final int countryOfNationalityId;

  Map<String, dynamic> toJson() => {
        'Email': email,
        'Password': password,
        'ReferralCode': referralCode,
        'FirstName': firstName,
        'LastName': lastName,
        'CountryOfNationalityId': countryOfNationalityId
      };
}
