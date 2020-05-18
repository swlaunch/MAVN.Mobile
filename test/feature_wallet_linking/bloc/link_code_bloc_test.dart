import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_code_block.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_code_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WalletRepository _mockWalletRepository = MockWalletRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

void main() {
  group('LinkCodeBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<LinkCodeBloc> blocTester;
    LinkCodeBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(_mockWalletRepository);

      subject =
          LinkCodeBloc(_mockWalletRepository, _mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initial state', () {
      blocTester.assertCurrentState(LinkCodeUninitializedState());
    });

    test('generateLinkCode loaded state', () async {
      when(_mockWalletRepository.createPublicLinkCodeRequest()).thenAnswer(
          (_) => Future.value(TestConstants.stubLinkCodeRequestResponseModel));

      await subject.generateLinkCode();

      await blocTester.assertFullBlocOutputInOrder([
        LinkCodeUninitializedState(),
        LinkCodeLoadingState(),
        LinkCodeLoadedState('321')
      ]);
    });

    test('generateLinkCode error state', () async {
      when(_mockWalletRepository.createPublicLinkCodeRequest())
          .thenThrow(Exception());
      when(_mockExceptionToMessageMapper.map(null)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await subject.generateLinkCode();

      await blocTester.assertFullBlocOutputInOrder([
        LinkCodeUninitializedState(),
        LinkCodeLoadingState(),
        LinkCodeErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText))
      ]);
    });
  });
}
