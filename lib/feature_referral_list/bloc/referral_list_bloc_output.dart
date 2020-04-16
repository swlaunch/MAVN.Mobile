import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:meta/meta.dart';

abstract class ReferralListState extends BaseState {}

class ReferralListUninitializedState extends ReferralListState {}

class ReferralListPaginationLoadingState extends ReferralListState {}

class ReferralListLoadingState extends ReferralListState {}

class ReferralListErrorState extends ReferralListState {
  ReferralListErrorState({
    @required this.errorTitle,
    @required this.errorSubtitle,
    @required this.iconAsset,
    @required this.currentPage,
    @required this.referralList,
  });

  final String errorTitle;
  final String errorSubtitle;
  final String iconAsset;

  final List<CustomerCommonReferralResponseModel> referralList;
  final int currentPage;

  @override
  List get props => super.props
    ..addAll([errorTitle, errorSubtitle, iconAsset, referralList, currentPage]);
}

class ReferralListNetworkErrorState extends ReferralListState
    with BaseNetworkErrorState {}

class ReferralListLoadedState extends ReferralListState {
  ReferralListLoadedState({
    @required this.referralList,
    this.currentPage,
    this.totalCount,
  });

  final List<CustomerCommonReferralResponseModel> referralList;
  final int currentPage;
  final int totalCount;

  @override
  List get props => super.props
    ..addAll([
      referralList,
      currentPage,
      totalCount,
    ]);
}

class ReferralListEmptyState extends ReferralListState {}
