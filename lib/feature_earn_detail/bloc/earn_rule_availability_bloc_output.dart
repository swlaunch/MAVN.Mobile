import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

abstract class EarnRuleAvailabilityState extends BlocState {}

abstract class EarnRuleAvailabilityUnavailableState
    extends EarnRuleAvailabilityState {}

class EarnRuleAvailabilityUninitializedState extends EarnRuleAvailabilityState {
}

class EarnRuleAvailabilityAvailableState extends EarnRuleAvailabilityState {}

class EarnRuleAvailabilityWalletDisabledState
    extends EarnRuleAvailabilityUnavailableState {}

class EarnRuleAvailabilityNotEnoughTokensState
    extends EarnRuleAvailabilityUnavailableState {
  EarnRuleAvailabilityNotEnoughTokensState(this.stakingAmount);

  final TokenCurrency stakingAmount;
}

class EarnRuleAvailabilityExceededParticipationLimitState
    extends EarnRuleAvailabilityUnavailableState {}
