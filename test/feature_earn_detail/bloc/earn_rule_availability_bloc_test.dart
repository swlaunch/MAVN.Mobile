import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../../helpers/bloc.dart';
import '../../test_constants.dart';

void main() {
  group('EarnRuleAvailabilityBloc tests', () {
    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<EarnRuleAvailabilityBloc> blocTester;
    EarnRuleAvailabilityBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = EarnRuleAvailabilityBloc();
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(EarnRuleAvailabilityUninitializedState());
    });

    test('do nothing if one of the states is not loaded', () async {
      await subject.checkAvailability(
          EarnRuleDetailUninitializedState(), BalanceUninitializedState());

      expectedFullBlocOutput.addAll([
        EarnRuleAvailabilityUninitializedState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('offer available', () async {
      await subject.checkAvailability(
          EarnRuleDetailLoadedState(
              earnRuleDetail:
                  TestConstants.stubExtendedEarnRuleWithStayHotelCondition),
          BalanceLoadedState(
              wallet: TestConstants.stubWalletResponseModel,
              isWalletDisabled: false));

      expectedFullBlocOutput.addAll([
        EarnRuleAvailabilityUninitializedState(),
        EarnRuleAvailabilityAvailableState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('offer unavailable, insufficient balance', () async {
      await subject.checkAvailability(
          EarnRuleDetailLoadedState(
              earnRuleDetail:
                  TestConstants.stubExtendedEarnRuleWithStayHotelCondition),
          BalanceLoadedState(
              wallet: TestConstants.stubWalletResponseModelNoBalance,
              isWalletDisabled: false));

      expectedFullBlocOutput.addAll([
        EarnRuleAvailabilityUninitializedState(),
        EarnRuleAvailabilityNotEnoughTokensState(TestConstants
            .stubExtendedEarnRuleWithStayHotelCondition
            .conditions
            .first
            .stakeAmount),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('offer unavailable, wallet disabled', () async {
      await subject.checkAvailability(
          EarnRuleDetailLoadedState(
              earnRuleDetail:
                  TestConstants.stubExtendedEarnRuleWithStayHotelCondition),
          BalanceLoadedState(
              wallet: TestConstants.stubWalletResponseModel,
              isWalletDisabled: true));

      expectedFullBlocOutput.addAll([
        EarnRuleAvailabilityUninitializedState(),
        EarnRuleAvailabilityWalletDisabledState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('offer unavailable, exceeded participation count with staking',
        () async {
      await subject.checkAvailability(
          EarnRuleDetailLoadedState(
              earnRuleDetail:
                  TestConstants.stubExtendedEarnRuleReachedMaxParticipation),
          BalanceLoadedState(
              wallet: TestConstants.stubWalletResponseModel,
              isWalletDisabled: false));

      expectedFullBlocOutput.addAll([
        EarnRuleAvailabilityUninitializedState(),
        EarnRuleAvailabilityExceededParticipationLimitState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('offer unavailable, exceeded participation count with no staking',
        () async {
      await subject.checkAvailability(
          EarnRuleDetailLoadedState(
              earnRuleDetail: TestConstants
                  .stubExtendedEarnRuleReachedMaxParticipationNoStaking),
          BalanceLoadedState(
              wallet: TestConstants.stubWalletResponseModel,
              isWalletDisabled: false));

      expectedFullBlocOutput.addAll([
        EarnRuleAvailabilityUninitializedState(),
        EarnRuleAvailabilityExceededParticipationLimitState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
