import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

BlocTester<WalletBloc> _blocTester;
WalletRepository _mockWalletRepository = MockWalletRepository();
ConversionRepository _mockConversionRepository = MockConversionRepository();
GetMobileSettingsUseCase _mockGetMobileSettingsUseCase =
    MockGetMobileSettingsUseCase();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

WalletBloc subject;

void main() {
  group('WalletBloc tests', () {
    setUp(() {
      reset(_mockWalletRepository);
      _expectedFullBlocOutput.clear();

      subject = WalletBloc(_mockWalletRepository, _mockConversionRepository,
          _mockGetMobileSettingsUseCase, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(WalletUninitializedState());
    });

    test('fetchWallet - success', () async {
      when(_mockWalletRepository.getWallet()).thenAnswer(
          (_) => Future.value(TestConstants.stubWalletResponseModelNoBalance));

      when(_mockConversionRepository.convertTokensToBaseCurrency(
              amountInTokens: TestConstants.stubWalletResponseModelNoBalance
                  .externalBalance.doubleValue))
          .thenAnswer((_) =>
              Future.value(TestConstants.stubCurrencyConverterResponseModel));

      await subject.fetchWallet();

      await _blocTester.assertFullBlocOutputInOrder([
        WalletUninitializedState(),
        WalletLoadingState(),
        WalletLoadedState(
          wallet: TestConstants.stubWalletResponseModelNoBalance,
          externalBalanceInBaseCurrency: '1',
          baseCurrencyCode: TestConstants.stubBaseCurrency,
        )
      ]);
    });

    test('fetchWallet - error', () async {
      when(_mockWalletRepository.getWallet()).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.fetchWallet();

      await _blocTester.assertFullBlocOutputInOrder([
        WalletUninitializedState(),
        WalletLoadingState(),
        WalletErrorState(
            errorMessage: LazyLocalizedStrings.defaultGenericError),
      ]);
    });
    test('fetchWallet - network error', () async {
      when(_mockWalletRepository.getWallet()).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.fetchWallet();

      await _blocTester.assertFullBlocOutputInOrder([
        WalletUninitializedState(),
        WalletLoadingState(),
        WalletErrorState(
            errorMessage: LazyLocalizedStrings.defaultGenericError),
      ]);
    });
  });
}
