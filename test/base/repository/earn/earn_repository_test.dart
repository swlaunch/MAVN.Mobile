import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/repository/earn/earn_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('EarnRepository tests', () {
    final _mockEarnApi = MockEarnApi();
    final _subject = EarnRepository(_mockEarnApi);

    setUp(() {
      reset(_mockEarnApi);
    });
    test('getEarnRules', () {
      _subject.getEarnRules(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubPageSize);

      verify(_mockEarnApi.getEarnRules(
              currentPage: TestConstants.stubCurrentPage,
              pageSize: TestConstants.stubPageSize))
          .called(1);
    });

    test('getEarnRuleDetail', () {
      _subject.getExtendedEarnRule(earnRuleId: TestConstants.stubEarnRule.id);

      verify(_mockEarnApi.getEarnRuleById(
              earnRuleId: TestConstants.stubEarnRule.id))
          .called(1);
    });
  });
}
