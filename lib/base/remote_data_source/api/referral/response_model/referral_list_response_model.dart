import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';

class ReferralsListResponseModel {
  ReferralsListResponseModel({
    this.referrals,
    this.totalCount,
    this.currentPage,
    this.pageSize,
  });

  ReferralsListResponseModel.fromJson(Map<String, dynamic> json)
      : referrals = CustomerCommonReferralResponseModel.toListFromJson(
            json['Referrals'] as List),
        totalCount = json['TotalCount'],
        currentPage = json['CurrentPage'],
        pageSize = json['PageSize'];

  final int totalCount;
  final int currentPage;
  final int pageSize;
  final List<CustomerCommonReferralResponseModel> referrals;
}
