import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/country_api.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

CountryApi _subject;

void main() {
  mockServerHttpClientTest('CountryApi', (httpClient) {
    setUpAll(() {
      _subject = CountryApi(httpClient);
    });

    group('countries', () {
      test('countries 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/country/response/200.json');

        final response = await _subject.getCountryList();

        expect(response.countryList.length, 2);
        expect(response.countryList[0].id, TestConstants.stubCountryCodeId);
        expect(response.countryList[0].name, TestConstants.stubName);

        httpClient.assertGetRequest(path: '/lists/countriesOfResidence');
      });
    });

    group('countryCodes', () {
      test('countryCodes 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/countryCodes/response/200.json');

        final response = await _subject.getCountryCodeList();

        expect(response.countryCodeList.length, 2);
        expect(response.countryCodeList[0].id, TestConstants.stubCountryCodeId);
        expect(response.countryCodeList[0].name, TestConstants.stubName);

        httpClient.assertGetRequest(path: '/lists/countryPhoneCodes');
      });
    });
  });
}
