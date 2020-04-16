import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/phone_verification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/set_phone_number_request_model.dart';
import 'package:lykke_mobile_mavn/base/repository/phone/phone_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('PhoneRepsitory tests', () {
    final _mockPhoneApi = MockPhoneApi();
    final _subject = PhoneRepository(_mockPhoneApi);

    setUp(() {
      reset(_mockPhoneApi);
    });

    test('generate verification', () async {
      await _subject.sendVerification();
      verify(_mockPhoneApi.generateVerification()).called(1);
    });

    test('verifyPhone', () async {
      await _subject.verifyPhone(
          verificationCode: TestConstants.stubPhoneVerificationCode);

      final capturedRequestModel = verify(_mockPhoneApi.verifyPhoneNumber(
              phoneVerificationRequestModel:
                  captureAnyNamed('phoneVerificationRequestModel')))
          .captured[0] as PhoneVerificationRequestModel;

      expect(capturedRequestModel.verificationCode,
          TestConstants.stubPhoneVerificationCode);
    });

    test('setPhoneNumber', () async {
      await _subject.setPhoneNumber(
          phoneNumber: TestConstants.stubPhoneNumber,
          countryPhoneCodeId: TestConstants.stubCountryCodeId);

      final capturedRequestModel = verify(_mockPhoneApi.setPhoneNumber(
              setPhoneNumberRequestModel:
                  captureAnyNamed('setPhoneNumberRequestModel')))
          .captured[0] as SetPhoneNumberRequestModel;

      expect(capturedRequestModel.phoneNumber, TestConstants.stubPhoneNumber);
      expect(capturedRequestModel.countryPhoneCodeId,
          TestConstants.stubCountryCodeId);
    });
  });
}
