import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/friend_referral_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/hotel_referral_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/referral_confirm_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class ReferralApi extends BaseApi {
  ReferralApi(HttpClient httpClient) : super(httpClient);

  static const String hotelReferralPath = '/referrals/hotels';
  static const String hotelReferralConfirmPath = '/referrals/hotel/confirm';
  static const String referralsPath = '/referrals/all';
  static const String friendReferral = '/referrals/friend';

  //query params
  static const String queryParamCurrentPage = 'CurrentPage';
  static const String queryParamPageSize = 'PageSize';
  static const String queryParamStatus = 'Status';
  static const String queryParamStatusPending = 'Ongoing';
  static const String queryParamStatusApproved = 'Accepted';
  static const String queryParamStatusExpired = 'Expired';
  static const String queryParamEarnRuleId = 'EarnRuleId';

  Future<void> submitHotelReferral(
          HotelReferralRequestModel hotelReferralRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          hotelReferralPath,
          data: hotelReferralRequestModel.toJson(),
        );
      });

  Future<void> submitFriendReferral(
          FriendReferralRequestModel friendReferralRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          friendReferral,
          data: friendReferralRequestModel.toJson(),
        );
      });

  Future<void> hotelReferralConfirm(
          ReferralConfirmRequestModel hotelReferralConfirmRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          hotelReferralConfirmPath,
          data: hotelReferralConfirmRequestModel.toJson(),
        );
      });

  Future<ReferralsListResponseModel> getReferralsForEarnRuleId(
    int pageSize,
    int currentPage,
    String earnRuleId,
  ) =>
      _getReferrals(
        pageSize,
        currentPage,
        queryParamStatusPending,
        earnRuleId: earnRuleId,
      );

  Future<ReferralsListResponseModel> getPendingReferrals(
    int pageSize,
    int currentPage,
  ) =>
      _getReferrals(pageSize, currentPage, queryParamStatusPending);

  Future<ReferralsListResponseModel> getApprovedReferrals(
    int pageSize,
    int currentPage,
  ) =>
      _getReferrals(pageSize, currentPage, queryParamStatusApproved);

  Future<ReferralsListResponseModel> getExpiredReferrals(
    int pageSize,
    int currentPage,
  ) =>
      _getReferrals(pageSize, currentPage, queryParamStatusExpired);

  Future<ReferralsListResponseModel> _getReferrals(
    int pageSize,
    int currentPage,
    String status, {
    String earnRuleId,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient
            .get<Map<String, dynamic>>(referralsPath, queryParameters: {
          queryParamStatus: status,
          queryParamCurrentPage: currentPage,
          queryParamPageSize: pageSize,
          if (earnRuleId != null) queryParamEarnRuleId: earnRuleId
        });
        return ReferralsListResponseModel.fromJson(response.data);
      });
}
