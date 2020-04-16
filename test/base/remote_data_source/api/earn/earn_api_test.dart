import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/earn_api.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

EarnApi _subject;

void main() {
  mockServerHttpClientTest('EarnApi', (httpClient) {
    setUpAll(() {
      _subject = EarnApi(httpClient);
    });

    group('getEarnRules tests', () {
      test('getEarnRules - success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/earnRules/response/200.json');

        final response = await _subject.getEarnRules(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubCurrentPage,
        );
        expect(response.totalCount, 1);
        expect(response.earnRuleList.length, 1);

        expect(
            response.earnRuleList[0].title, TestConstants.stubEarnRule.title);
        expect(response.earnRuleList[0].imageUrl,
            TestConstants.stubEarnRule.imageUrl);
        expect(response.earnRuleList[0].description,
            TestConstants.stubEarnRule.description);

        httpClient.assertGetRequest(path: '/earnRules');
      });
    });

    group('getEarnRuleDetail tests', () {
      test('getEarnRuleDetail - success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/earn_rule_detail/response/200.json');

        final response = await _subject.getEarnRuleById(
            earnRuleId: TestConstants.stubEarnRuleId);

        expect(response.conditions.length, 1);

        httpClient
            .assertGetRequest(path: '/earnRules/search', queryParameters: {
          EarnApi.earnRuleIdQueryParameterKey: TestConstants.stubEarnRuleId,
        });
      });
    });
  });
}
