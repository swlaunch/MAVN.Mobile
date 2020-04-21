import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockSpendRepository = MockSpendRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<PropertyPaymentBloc> _blocTester = BlocTester(
    PropertyPaymentBloc(_mockSpendRepository, _mockExceptionToMessageMapper));

PropertyPaymentBloc _subject;

void main() {
  group('PropertyPaymentBlocTests', () {
    setUp(() {
      reset(_mockSpendRepository);
      _expectedFullBlocOutput.clear();

      _subject = PropertyPaymentBloc(
          _mockSpendRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(PropertyPaymentUninitializedState());
    });

    test('sendPayment success full amount', () async {
      await _subject.sendPayment(
        id: TestConstants.stubId,
        instalmentName: TestConstants.stubInstalmentName,
        spendRuleId: TestConstants.stubCampaignId,
        amountInToken: TestConstants.stubValidTransactionAmount,
        amountInCurrency: TestConstants.stubAmountInFiat,
        amountSize: AmountSize.full,
      );

      expect(
        verify(_mockSpendRepository.submitPropertyPayment(
          id: TestConstants.stubId,
          instalmentName: TestConstants.stubInstalmentName,
          spendRuleId: TestConstants.stubCampaignId,
          fiatCurrencyCode: TestConstants.stubAmountInFiat.assetSymbol,
          amountInFiat: TestConstants.stubAmountInFiat.doubleValue,
          amountInTokens: null,
        )).callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        PropertyPaymentUninitializedState(),
        PropertyPaymentLoadingState(),
        PropertyPaymentSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('sendPayment success partial amount', () async {
      await _subject.sendPayment(
        id: TestConstants.stubId,
        instalmentName: TestConstants.stubInstalmentName,
        spendRuleId: TestConstants.stubCampaignId,
        amountInToken: TestConstants.stubValidTransactionAmount,
        amountInCurrency: TestConstants.stubAmountInFiat,
        amountSize: AmountSize.partial,
      );

      expect(
        verify(_mockSpendRepository.submitPropertyPayment(
          id: TestConstants.stubId,
          instalmentName: TestConstants.stubInstalmentName,
          spendRuleId: TestConstants.stubCampaignId,
          fiatCurrencyCode: TestConstants.stubAmountInFiat.assetSymbol,
          amountInFiat: null,
          amountInTokens: TestConstants.stubValidTransactionAmount,
        )).callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        PropertyPaymentUninitializedState(),
        PropertyPaymentLoadingState(),
        PropertyPaymentSuccessEvent()
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('sendPayment generic error', () async {
      when(
        _mockSpendRepository.submitPropertyPayment(
          instalmentName: TestConstants.stubInstalmentName,
          spendRuleId: TestConstants.stubCampaignId,
          id: TestConstants.stubId,
          amountInFiat: TestConstants.stubAmountInFiat.doubleValue,
          fiatCurrencyCode: TestConstants.stubAmountInFiat.assetSymbol,
        ),
      ).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.sendPayment(
        id: TestConstants.stubId,
        instalmentName: TestConstants.stubInstalmentName,
        spendRuleId: TestConstants.stubCampaignId,
        amountInToken: TestConstants.stubValidTransactionAmount,
        amountInCurrency: TestConstants.stubAmountInFiat,
        amountSize: AmountSize.full,
      );

      _expectedFullBlocOutput.addAll([
        PropertyPaymentUninitializedState(),
        PropertyPaymentLoadingState(),
        PropertyPaymentErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('postTransactionForm network error', () async {
      when(
        _mockSpendRepository.submitPropertyPayment(
          spendRuleId: TestConstants.stubCampaignId,
          instalmentName: TestConstants.stubInstalmentName,
          id: TestConstants.stubId,
          amountInFiat: TestConstants.stubAmountInFiat.doubleValue,
          fiatCurrencyCode: TestConstants.stubAmountInFiat.assetSymbol,
        ),
      ).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.sendPayment(
        id: TestConstants.stubId,
        instalmentName: TestConstants.stubInstalmentName,
        spendRuleId: TestConstants.stubCampaignId,
        amountInToken: TestConstants.stubValidTransactionAmount,
        amountInCurrency: TestConstants.stubAmountInFiat,
        amountSize: AmountSize.full,
      );

      _expectedFullBlocOutput.addAll([
        PropertyPaymentUninitializedState(),
        PropertyPaymentLoadingState(),
        PropertyPaymentErrorState(LazyLocalizedStrings.networkError),
      ]);
      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('postTransactionForm wallet blocked error', () async {
      when(
        _mockSpendRepository.submitPropertyPayment(
          spendRuleId: TestConstants.stubCampaignId,
          instalmentName: TestConstants.stubInstalmentName,
          id: TestConstants.stubId,
          amountInFiat: TestConstants.stubAmountInFiat.doubleValue,
          fiatCurrencyCode: TestConstants.stubAmountInFiat.assetSymbol,
        ),
      ).thenThrow(const ServiceException(
        ServiceExceptionType.customerWalletBlocked,
        message: TestConstants.stubErrorText,
      ));

      when(_mockExceptionToMessageMapper.map(any)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await _subject.sendPayment(
        id: TestConstants.stubId,
        instalmentName: TestConstants.stubInstalmentName,
        spendRuleId: TestConstants.stubCampaignId,
        amountInToken: TestConstants.stubValidTransactionAmount,
        amountInCurrency: TestConstants.stubAmountInFiat,
        amountSize: AmountSize.full,
      );

      _expectedFullBlocOutput.addAll([
        PropertyPaymentUninitializedState(),
        PropertyPaymentLoadingState(),
        PropertyPaymentWalletDisabledEvent(),
        PropertyPaymentInlineErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
      ]);
      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
