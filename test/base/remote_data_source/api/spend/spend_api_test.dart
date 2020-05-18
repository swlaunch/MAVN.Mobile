import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/spend/spend_api.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

SpendApi _subject;

void main() {
  mockServerHttpClientTest('SpendApi', (httpClient) {
    setUpAll(() {
      _subject = SpendApi(httpClient);
    });

    group('getSpendRules tests', () {
      test('getSpendRules - success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/spendRules/response/200.json');

        final response = await _subject.getSpendRules(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubPageSize,
        );
        expect(response.spendRuleList.length, 1);
        expect(
            response.spendRuleList[0].title, TestConstants.stubSpendRule.title);
        expect(response.spendRuleList[0].imageUrl,
            TestConstants.stubSpendRule.imageUrl);
        expect(response.spendRuleList[0].description,
            TestConstants.stubSpendRule.description);
        expect(response.spendRuleList[0].amountInCurrency,
            TestConstants.stubSpendRule.amountInCurrency);
        expect(response.spendRuleList[0].currencyName,
            TestConstants.stubSpendRule.currencyName);
        httpClient.assertGetRequest(path: '/spendRules');
      });
    });
  });
}
