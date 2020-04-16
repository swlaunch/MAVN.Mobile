import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/phone_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/phone_verification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/set_phone_number_request_model.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

PhoneApi _subject;

void main() {
  mockServerHttpClientTest('PhoneApi', (httpClient) {
    setUpAll(() {
      _subject = PhoneApi(httpClient);
    });

    test('set phone - success 204', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/common/response/204.json');

      await _subject.setPhoneNumber(
          setPhoneNumberRequestModel: SetPhoneNumberRequestModel(
              phoneNumber: TestConstants.stubValidPhoneNumber,
              countryPhoneCodeId: TestConstants.stubCountryCodeId));

      httpClient.assertPostRequest(path: PhoneApi.phonePath);
    });

    test('verify - success 204', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/common/response/204.json');

      await _subject.verifyPhoneNumber(
          phoneVerificationRequestModel: PhoneVerificationRequestModel(
              verificationCode: TestConstants.stubPhoneVerificationCode));

      httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/phone/request/verify-phone.json',
          path: PhoneApi.verifyPhonePath);
    });

    test('generate verification- success 204', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/common/response/204.json');

      await _subject.generateVerification();

      httpClient.assertPostRequest(path: PhoneApi.generateVerificationPath);
    });
  });
}
