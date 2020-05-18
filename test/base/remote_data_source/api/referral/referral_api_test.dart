import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/referral_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/hotel_referral_model.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

ReferralApi _subject;

void main() {
  mockServerHttpClientTest('ReferralApi', (httpClient) {
    setUpAll(() {
      _subject = ReferralApi(httpClient);
    });

    group('submitHotelReferral tests', () {
      final _stubHotelReferralRequestModel = HotelReferralRequestModel(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryPhoneCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      test('submit hotel referral - success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/referrals/hotels/response/204.json');

        await _subject.submitHotelReferral(_stubHotelReferralRequestModel);

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/referrals/hotels/request/full.json',
          path: '/referrals/hotels',
        );
      });

      test('submit hotel referral error - 401 unauthorized', () async {
        httpClient.mockResponse(null, statusCode: 401);

        await expectLater(
          () => _subject.submitHotelReferral(_stubHotelReferralRequestModel),
          throwsA(predicate((e) =>
              e is DioError &&
              e.type == DioErrorType.RESPONSE &&
              e.message == 'Http status error [401]')),
        );

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/referrals/hotels/request/full.json',
          path: '/referrals/hotels',
        );
      });
    });
  });
}
