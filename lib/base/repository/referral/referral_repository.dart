import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/referral_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/friend_referral_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/hotel_referral_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/referral_confirm_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_list_response_model.dart';

class ReferralRepository {
  ReferralRepository(this._referralApi);

  final ReferralApi _referralApi;

  static const itemsPerPage = 30;

  Future<ReferralsListResponseModel> getPendingReferrals({
    int currentPage,
    int itemsCount = itemsPerPage,
  }) =>
      _referralApi.getPendingReferrals(itemsCount, currentPage);

  Future<ReferralsListResponseModel> getReferralsForEarnRuleId({
    @required String earnRuleId,
    int currentPage,
    int itemsCount = itemsPerPage,
  }) =>
      _referralApi.getReferralsForEarnRuleId(
        itemsCount,
        currentPage,
        earnRuleId,
      );

  Future<ReferralsListResponseModel> getApprovedReferrals({int currentPage}) =>
      _referralApi.getApprovedReferrals(itemsPerPage, currentPage);

  Future<ReferralsListResponseModel> getExpiredReferrals({int currentPage}) =>
      _referralApi.getExpiredReferrals(itemsPerPage, currentPage);

  Future<void> submitHotelReferral({
    @required String fullName,
    @required String email,
    @required int countryCodeId,
    @required String phoneNumber,
    @required String earnRuleId,
  }) =>
      _referralApi.submitHotelReferral(HotelReferralRequestModel(
        fullName: fullName,
        email: email,
        countryPhoneCodeId: countryCodeId,
        phoneNumber: phoneNumber,
        earnRuleId: earnRuleId,
      ));

  Future<void> hotelReferralConfirm({@required String code}) => _referralApi
      .hotelReferralConfirm(ReferralConfirmRequestModel(code: code));

  Future<void> submitFriendReferral({
    @required String fullName,
    @required String email,
    @required String earnRuleId,
  }) =>
      _referralApi.submitFriendReferral(FriendReferralRequestModel(
        fullName: fullName,
        email: email,
        earnRuleId: earnRuleId,
      ));
}
