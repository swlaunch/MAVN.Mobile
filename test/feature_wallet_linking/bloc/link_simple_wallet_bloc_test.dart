import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_simple_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_simple_wallet_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

GetMobileSettingsUseCase _mockMobileSettingsUseCase =
    MockGetMobileSettingsUseCase();
WalletRepository _mockWalletRepository = MockWalletRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

void main() {
  group('LinkSimpleWalletBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<LinkSimpleWalletBloc> blocTester;
    LinkSimpleWalletBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(_mockWalletRepository);
      reset(_mockMobileSettingsUseCase);

      subject = LinkSimpleWalletBloc(_mockMobileSettingsUseCase,
          _mockWalletRepository, _mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initial state', () {
      blocTester.assertCurrentState(LinkSimpleWalletUninitializedState());
    });

    test('generateDAppURL loaded state', () async {
      when(_mockWalletRepository.createPublicLinkCodeRequest()).thenAnswer(
          (_) => Future.value(TestConstants.stubLinkCodeRequestResponseModel));

      when(_mockWalletRepository.getWallet()).thenAnswer(
          (_) => Future.value(TestConstants.stubWalletLinkedResponseModel));

      when(_mockMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);

      await subject.generateDAppURL();

      await blocTester.assertFullBlocOutputInOrder([
        LinkSimpleWalletUninitializedState(),
        LinkSimpleWalletLoadingState(),
        LinkSimpleWalletLoadedState(
            'https://customer-website.mavn-dev.open-source.exchange/en/dapp-linking?internal-address=321321&link-code=321')
      ]);
    });

    test('generateDAppURL error state', () async {
      when(_mockWalletRepository.createPublicLinkCodeRequest())
          .thenThrow(Exception());

      when(_mockWalletRepository.getWallet()).thenAnswer(
          (_) => Future.value(TestConstants.stubWalletLinkedResponseModel));

      when(_mockMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.generateDAppURL();

      await blocTester.assertFullBlocOutputInOrder([
        LinkSimpleWalletUninitializedState(),
        LinkSimpleWalletLoadingState(),
        LinkSimpleWalletErrorState(LazyLocalizedStrings.defaultGenericError)
      ]);
    });
  });
}
