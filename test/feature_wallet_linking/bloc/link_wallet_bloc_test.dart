import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_wallet_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('LinkWalletBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<LinkWalletBloc> blocTester;
    LinkWalletBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = LinkWalletBloc(MockBalanceBloc(BalanceUninitializedState()));
      blocTester = BlocTester(subject);
    });

    test('initial state', () {
      blocTester.assertCurrentState(LinkWalletUninitializedState());
    });

    test('could not load balance error', () async {
      await subject.linkByType(LinkWalletType.simple);

      await blocTester.assertFullBlocOutputInOrder([
        LinkWalletUninitializedState(),
        LinkWalletErrorEvent(LazyLocalizedStrings.couldNotLoadBalanceError)
      ]);
    });

    test('no sufficient balance', () async {
      subject = LinkWalletBloc(MockBalanceBloc(BalanceLoadedState(
          wallet: TestConstants.stubWalletResponseModelNoBalance)));

      blocTester = BlocTester(subject);

      await subject.linkByType(LinkWalletType.simple);

      await blocTester.assertFullBlocOutputInOrder([
        LinkWalletUninitializedState(),
        LinkWalletErrorEvent(LazyLocalizedStrings.insufficientFunds)
      ]);
    });

    test('success', () async {
      subject = LinkWalletBloc(MockBalanceBloc(
          BalanceLoadedState(wallet: TestConstants.stubWalletResponseModel)));

      blocTester = BlocTester(subject);

      await subject.linkByType(LinkWalletType.simple);

      await blocTester.assertFullBlocOutputInOrder([
        LinkWalletUninitializedState(),
        LinkWalletLoadedEvent(LinkWalletType.simple),
      ]);
    });
  });
}
