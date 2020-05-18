import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WalletRepository _mockWalletRepository = MockWalletRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

void main() {
  group('LinkAdvancedWalletBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<LinkAdvancedWalletBloc> blocTester;
    LinkAdvancedWalletBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(_mockWalletRepository);

      subject = LinkAdvancedWalletBloc(
          _mockWalletRepository, _mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initial state', () {
      blocTester.assertCurrentState(LinkAdvancedWalletUninitializedState());
    });

    test('linkPrivateWallet loaded state', () async {
      when(_mockWalletRepository.getWallet()).thenAnswer(
          (_) => Future.value(TestConstants.stubWalletLinkedResponseModel));

      when(_mockWalletRepository.approvePublicWalletLinkingRequest(
        privateAddress:
            TestConstants.stubWalletLinkedResponseModel.privateWalletAddress,
        publicAddress: TestConstants.stubWalletPublicAddress,
        signature: TestConstants.stubWalletLinkingCode,
      )).thenAnswer((_) => Future.value());

      await subject.linkPrivateWallet(
          publicAddress: TestConstants.stubWalletPublicAddress,
          linkingCode: TestConstants.stubWalletLinkingCode);

      await blocTester.assertFullBlocOutputInOrder([
        LinkAdvancedWalletUninitializedState(),
        LinkAdvancedWalletLoadingState(),
        LinkAdvancedWalletSubmissionSuccessEvent()
      ]);
    });

    test('linkPrivateWallet error state', () async {
      when(_mockWalletRepository.getWallet()).thenAnswer(
          (_) => Future.value(TestConstants.stubWalletLinkedResponseModel));

      when(_mockWalletRepository.approvePublicWalletLinkingRequest(
        privateAddress:
            TestConstants.stubWalletLinkedResponseModel.privateWalletAddress,
        publicAddress: TestConstants.stubWalletPublicAddress,
        signature: TestConstants.stubWalletLinkingCode,
      )).thenThrow(Exception());
      when(_mockExceptionToMessageMapper.map(null)).thenReturn(
          LocalizedStringBuilder.custom(TestConstants.stubErrorText));

      await subject.linkPrivateWallet(
          publicAddress: TestConstants.stubWalletPublicAddress,
          linkingCode: TestConstants.stubWalletLinkingCode);

      await blocTester.assertFullBlocOutputInOrder([
        LinkAdvancedWalletUninitializedState(),
        LinkAdvancedWalletLoadingState(),
        LinkAdvancedWalletSubmissionErrorEvent(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
        LinkAdvancedWalletErrorState(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText))
      ]);
    });
  });
}
