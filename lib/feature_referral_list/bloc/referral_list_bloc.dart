import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

export 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc_output.dart';

abstract class ReferralListBloc extends GenericListBloc<
    ReferralsListResponseModel, CustomerCommonReferralResponseModel> {
  ReferralListBloc()
      : super(
            genericErrorSubtitle:
                LazyLocalizedStrings.referralListRequestGenericErrorSubtitle);

  @override
  int getCurrentPage(ReferralsListResponseModel response) =>
      response.currentPage;

  @override
  List<CustomerCommonReferralResponseModel> getDataFromResponse(
          ReferralsListResponseModel response) =>
      response.referrals;

  @override
  List<CustomerCommonReferralResponseModel> sort(
          List<CustomerCommonReferralResponseModel> list) =>
      ListUtils.sortBy(
        list,
        (item) => item.timeStamp,
        descendingOrder: true,
      );

  @override
  int getTotalCount(ReferralsListResponseModel response) => response.totalCount;
}
