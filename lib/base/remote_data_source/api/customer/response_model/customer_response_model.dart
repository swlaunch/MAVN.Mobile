import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';
import 'package:meta/meta.dart';

class CustomerResponseModel {
  CustomerResponseModel({
    @required this.firstName,
    @required this.lastName,
    @required this.phoneNumber,
    @required this.phoneCountryCode,
    @required this.phoneCountryCodeId,
    @required this.email,
    @required this.isEmailVerified,
    @required this.isPhoneNumberVerified,
    @required this.isAccountBlocked,
    @required this.countryOfNationalityId,
    @required this.countryOfNationalityName,
    @required this.hasPin,
    @required this.linkedPartnerId,
  });

  CustomerResponseModel.fromJson(Map<String, dynamic> json)
      : firstName = json['FirstName'],
        lastName = json['LastName'],
        phoneNumber = json['PhoneNumber'],
        phoneCountryCode = json['CountryPhoneCode'],
        phoneCountryCodeId = json['CountryPhoneCodeId'],
        email = json['Email'],
        isEmailVerified = json['IsEmailVerified'],
        //TODO: uncomment this line to enable phone verification
//        isPhoneNumberVerified = json['IsPhoneNumberVerified'],
        isPhoneNumberVerified = true,
        isAccountBlocked = json['IsAccountBlocked'],
        countryOfNationalityId = json['CountryOfNationalityId'],
        countryOfNationalityName = json['CountryOfNationalityName'],
        hasPin = json['HasPin'],
        linkedPartnerId = json['LinkedPartnerId'];

  String get phoneNumberWithCode =>
      StringUtils.concatenate([phoneCountryCode, phoneNumber]);

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String phoneCountryCode;
  final int phoneCountryCodeId;
  final String email;
  final bool isEmailVerified;
  final bool isAccountBlocked;
  final bool isPhoneNumberVerified;
  final int countryOfNationalityId;
  final String countryOfNationalityName;
  final bool hasPin;
  final String linkedPartnerId;
}
