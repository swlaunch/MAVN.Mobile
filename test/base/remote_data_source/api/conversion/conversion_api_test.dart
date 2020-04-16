import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/conversion_api.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

ConversionApi _subject;

void main() {
  mockServerHttpClientTest('ConversionApi', (httpClient) {
    setUpAll(() {
      _subject = ConversionApi(httpClient);
    });

    group('conversion', () {
      test('currency converter 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/currency_converter/response/200.json');

        final response = await _subject
            .convertTokensToBaseCurrency(TestConstants.stubAmountDouble);

        expect(response.amount, TestConstants.stubAmountInCurrency);
      });

      test('get partner conversion rate', () async {
        //todo: add test
      });

      test('get burn rule conversion rate', () async {
        //todo: add test
      });
    });
  });
}
