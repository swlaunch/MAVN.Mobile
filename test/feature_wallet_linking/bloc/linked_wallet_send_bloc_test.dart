import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

void main() {
  group('LinkedWalletSendBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<LinkedWalletSendBloc> blocTester;
    LinkedWalletSendBloc subject;
    final _mockWalletRepository = MockWalletRepository();
    final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    setUp(() {
      expectedFullBlocOutput.clear();

      reset(_mockWalletRepository);
      subject = LinkedWalletSendBloc(
          _mockWalletRepository, _mockExceptionToMessageMapper);
      blocTester = BlocTester(subject);
    });

    test('initial state', () {
      blocTester.assertCurrentState(LinkedWalletSendUninitializedState());
    });

    test('success', () async {
      await subject.transferToken(Decimal.fromInt(1));

      await blocTester.assertFullBlocOutputInOrder([
        LinkedWalletSendUninitializedState(),
        LinkedWalletSendLoadingState(),
        LinkedWalletSendLoadedState(),
        LinkedWalletSendLoadedEvent()
      ]);
    });

    test('errpr', () async {
      when(_mockWalletRepository.postExternalTransfer(Decimal.fromInt(1)))
          .thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await subject.transferToken(Decimal.fromInt(1));

      await blocTester.assertFullBlocOutputInOrder([
        LinkedWalletSendUninitializedState(),
        LinkedWalletSendLoadingState(),
        LinkedWalletSendErrorEvent(LazyLocalizedStrings.defaultGenericError),
        LinkedWalletSendErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);
    });
  });
}
