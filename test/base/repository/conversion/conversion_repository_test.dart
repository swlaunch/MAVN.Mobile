import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('ConversionRepository tests', () {
    final _mockConversionApi = MockConversionApi();
    final _subject = ConversionRepository(_mockConversionApi);

    setUp(() {
      reset(_mockConversionApi);
    });

    test('convert token currency', () {
      _subject.convertTokensToBaseCurrency(
        amountInTokens: TestConstants.stubAmountDouble,
      );

      verify(_mockConversionApi
              .convertTokensToBaseCurrency(TestConstants.stubAmountDouble))
          .called(1);
    });

    test('get partner conversion rate', () {
      _subject.getPartnerConversionRate(
        partnerId: TestConstants.stubPaymentRequestPartnerId,
        amountInTokens: TestConstants.stubAmount,
      );

      verify(_mockConversionApi.getPartnerConversionRate(
              TestConstants.stubPaymentRequestPartnerId,
              TestConstants.stubAmount))
          .called(1);
    });

    test('get spend rule conversion rate', () {
      _subject.getSpendRuleConversionRate(
        spendRuleId: TestConstants.stubCurrencyName,
        amountInTokens: TestConstants.stubAmount,
      );

      verify(_mockConversionApi.getSpendRuleConversionRate(
              TestConstants.stubCurrencyName, TestConstants.stubAmount))
          .called(1);
    });
  });
}
