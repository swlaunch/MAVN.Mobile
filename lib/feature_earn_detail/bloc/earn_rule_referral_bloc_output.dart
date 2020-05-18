import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:meta/meta.dart';

abstract class EarnRuleReferralsState extends BaseState {}

class EarnRuleReferralsUninitializedState extends EarnRuleReferralsState {}

class EarnRuleReferralsLoadingState extends EarnRuleReferralsState
    with BaseLoadingState {}

class EarnRuleReferralsErrorState extends EarnRuleReferralsState {
  EarnRuleReferralsErrorState({
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

class EarnRuleReferralsNetworkErrorState extends EarnRuleReferralsState
    with BaseNetworkErrorState {}

class EarnRuleReferralsLoadedState extends EarnRuleReferralsState {
  EarnRuleReferralsLoadedState({
    @required this.referralList,
    @required this.totalCount,
  });

  final List<CustomerCommonReferralResponseModel> referralList;
  final int totalCount;

  @override
  List get props => super.props..addAll([referralList, totalCount]);
}

class EarnRuleReferralsEmptyState extends EarnRuleReferralsState {}
