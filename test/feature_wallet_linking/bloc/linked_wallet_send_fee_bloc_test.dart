import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_fee_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_fee_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('LinkedWalletSendFeeBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<LinkedWalletSendFeeBloc> blocTester;
    LinkedWalletSendFeeBloc subject;
    final _mockConversionRepository = MockConversionRepository();
    final _mockLocalSettingsRepository = MockLocalSettingsRepository();
    final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(_mockConversionRepository);
      reset(_mockLocalSettingsRepository);

      subject = LinkedWalletSendFeeBloc(
        _mockConversionRepository,
        _mockLocalSettingsRepository,
        _mockExceptionToMessageMapper,
      );

      blocTester = BlocTester(subject);
    });

    test('initial state', () {
      blocTester.assertCurrentState(LinkedWalletSendFeeUninitializedState());
    });

    test('success', () async {
      when(_mockConversionRepository.convertTokensToBaseCurrency(
              amountInTokens: 1))
          .thenAnswer((_) =>
              Future.value(TestConstants.stubCurrencyConverterResponseModel));

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(TestConstants.stubMobileSettings);

      await subject.fetchFee();

      await blocTester.assertFullBlocOutputInOrder([
        LinkedWalletSendFeeUninitializedState(),
        LinkedWalletSendFeeLoadingState(),
        LinkedWalletSendFeeLoadedState(
          baseCurrency: TestConstants.stubBaseCurrency,
          rate: Decimal.fromInt(1),
          fee: '1 ${TestConstants.stubMobileSettings.tokenSymbol}',
        ),
      ]);
    });

    test('error', () async {
      when(_mockConversionRepository.convertTokensToBaseCurrency(
              amountInTokens: 1))
          .thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.fetchFee();

      await blocTester.assertFullBlocOutputInOrder([
        LinkedWalletSendFeeUninitializedState(),
        LinkedWalletSendFeeLoadingState(),
        LinkedWalletSendFeeErrorState(LazyLocalizedStrings.defaultGenericError)
      ]);
    });
  });
}
