import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/email_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/request_model/email_verification_request_model.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

EmailApi _subject;

void main() {
  mockServerHttpClientTest('EmailApi', (httpClient) {
    setUpAll(() {
      _subject = EmailApi(httpClient);
    });

    test('sendVerificationEmailPath - success 204', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/common/response/204.json');

      await _subject.sendVerificationEmail();

      httpClient.assertPostRequest(path: EmailApi.sendVerificationEmailPath);
    });

    test('verifyEmail - success 204', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/common/response/204.json');

      await _subject.verifyEmail(
          emailVerificationRequestModel: EmailVerificationRequestModel(
              verificationCode: TestConstants.stubEmailVerificationCode));

      httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/emails/verify-email/request/full.json',
          path: EmailApi.verifyEmailPath);
    });
  });
}
