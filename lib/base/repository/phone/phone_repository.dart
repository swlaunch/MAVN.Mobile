import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/phone_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/phone_verification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/set_phone_number_request_model.dart';

class PhoneRepository {
  PhoneRepository(this._phoneApi);

  final PhoneApi _phoneApi;

  Future<void> setPhoneNumber({String phoneNumber, int countryPhoneCodeId}) =>
      _phoneApi.setPhoneNumber(
          setPhoneNumberRequestModel: SetPhoneNumberRequestModel(
        phoneNumber: phoneNumber,
        countryPhoneCodeId: countryPhoneCodeId,
      ));

  Future<void> sendVerification() => _phoneApi.generateVerification();

  Future<void> verifyPhone({@required verificationCode}) =>
      _phoneApi.verifyPhoneNumber(
        phoneVerificationRequestModel:
            PhoneVerificationRequestModel(verificationCode: verificationCode),
      );
}
