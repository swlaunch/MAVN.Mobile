import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:meta/meta.dart';

abstract class StakingReferralsState extends BaseState {}

class StakingReferralsUninitializedState extends StakingReferralsState {}

class StakingReferralsLoadingState extends StakingReferralsState
    with BaseLoadingState {}

class StakingReferralsErrorState extends StakingReferralsState {
  StakingReferralsErrorState({
    @required this.errorTitle,
    @required this.errorSubtitle,
    @required this.iconAsset,
  });

  final LocalizedStringBuilder errorTitle;
  final LocalizedStringBuilder errorSubtitle;
  final String iconAsset;

  @override
  List get props => super.props
    ..addAll([
      errorTitle,
      errorSubtitle,
      iconAsset,
    ]);
}

class StakingReferralsNetworkErrorState extends StakingReferralsState
    with BaseNetworkErrorState {}

class StakingReferralsLoadedState extends StakingReferralsState {
  StakingReferralsLoadedState({
    @required this.referralList,
    @required this.totalCount,
    @required this.amountTokensWaiting,
  });

  final List<CustomerCommonReferralResponseModel> referralList;
  final int totalCount;
  final TokenCurrency amountTokensWaiting;

  @override
  List get props => super.props
    ..addAll([
      referralList,
      totalCount,
      amountTokensWaiting,
    ]);
}

class StakingReferralsEmptyState extends StakingReferralsState {}
