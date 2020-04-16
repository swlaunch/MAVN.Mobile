import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/di/earn_rule_detail_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EarnRuleAvailabilityBloc extends Bloc<EarnRuleAvailabilityState> {
  @override
  EarnRuleAvailabilityState initialState() =>
      EarnRuleAvailabilityUninitializedState();

  Future<void> checkAvailability(EarnRuleDetailState earnRuleDetailBlocState,
      BalanceState balanceState) async {
    if (balanceState is! BalanceLoadedState ||
        earnRuleDetailBlocState is! EarnRuleDetailLoadedState) {
      return;
    }

    final earnRuleDetail =
        (earnRuleDetailBlocState as EarnRuleDetailLoadedState).earnRuleDetail;

    if (earnRuleDetail?.conditions?.isEmpty ?? true) {
      return;
    }

    if (_hasExceededParticipationCount(earnRuleDetailBlocState)) {
      setState(EarnRuleAvailabilityExceededParticipationLimitState());
    } else {
      if (!(earnRuleDetailBlocState as EarnRuleDetailLoadedState)
          .earnRuleDetail
          .conditions
          .first
          .hasStaking) {
        setState(EarnRuleAvailabilityAvailableState());
      } else if (_isWalletDisabled(balanceState)) {
        setState(EarnRuleAvailabilityWalletDisabledState());
      } else if (_hasInsufficientBalance(
          earnRuleDetailBlocState, balanceState)) {
        setState(EarnRuleAvailabilityNotEnoughTokensState(
            (earnRuleDetailBlocState as EarnRuleDetailLoadedState)
                .earnRuleDetail
                .conditions
                .first
                .stakeAmount));
      } else {
        setState(EarnRuleAvailabilityAvailableState());
      }
    }
  }

  bool _isWalletDisabled(BalanceLoadedState balanceLoadedState) =>
      balanceLoadedState.isWalletDisabled;

  bool _hasExceededParticipationCount(
          EarnRuleDetailLoadedState earnRuleDetailLoadedBlocState) =>
      earnRuleDetailLoadedBlocState.earnRuleDetail.completionCount != 0 &&
      earnRuleDetailLoadedBlocState.earnRuleDetail.customerCompletionCount ==
          earnRuleDetailLoadedBlocState.earnRuleDetail.completionCount;

  bool _hasInsufficientBalance(
          EarnRuleDetailLoadedState earnRuleDetailLoadedState,
          BalanceLoadedState balanceLoadedState) =>
      balanceLoadedState.wallet.balance.decimalValue <
      earnRuleDetailLoadedState
          .earnRuleDetail.conditions.first.stakeAmount.decimalValue;
}

EarnRuleAvailabilityBloc useEarnRuleAvailabilityBloc() =>
    ModuleProvider.of<EarnRuleDetailModule>(useContext())
        .earnRuleAvailabilityBloc;
