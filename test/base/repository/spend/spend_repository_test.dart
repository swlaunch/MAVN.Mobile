import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('CustomerRepository tests', () {
    final _mockSpendApi = MockSpendApi();
    final _subject = SpendRepository(_mockSpendApi);

    setUp(() {
      reset(_mockSpendApi);
    });

    test('getSpendRules', () {
      _subject.getSpendRules(
        currentPage: TestConstants.stubCurrentPage,
        pageSize: TestConstants.stubPageSize,
      );

      verify(_mockSpendApi.getSpendRules(
        currentPage: TestConstants.stubCurrentPage,
        pageSize: TestConstants.stubPageSize,
      )).called(1);
    });

    test('getSpendRuleDetail', () {
      _subject.getSpendRuleDetail(spendRuleId: TestConstants.stubSpendRule.id);

      verify(_mockSpendApi.getSpendRuleById(
              spendRuleId: TestConstants.stubSpendRule.id))
          .called(1);
    });
  });
}
