import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_ui_models/previous_referrals_list/previous_referrals_model.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ReferralToUiModelMapper {
  PreviousReferralModel previousReferralsFromReferral(
          CustomerCommonReferralResponseModel referral) =>
      PreviousReferralModel(
        referralStatus: referral.status,
        referralType: referral.referralType,
        referralName: LazyLocalizedStrings.previousReferralsNameHolder(
            referral.firstName, referral.lastName),
        referralEmail: referral.email,
        partnerName: referral.partnerName ?? '',
        referralCreationDate: referral.timeStamp,
        rewardValue: referral.totalReward,
        isApproximate: referral.isApproximate ?? false,
        hasStaking: referral.hasStaking,
        stakingInfo: referral.hasStaking && referral.staking != null
            ? StakingInfoModel(
                stakingAmount: referral.staking.stakeAmount,
                stakingContact: referral.firstName,
                stakingTimeLeft: _getDaysBetween(
                  DateTime.now(),
                  referral.staking.stakingExpirationDate,
                ),
                stakingTotalTime: _getDaysBetween(
                  referral.timeStamp,
                  referral.staking.stakingExpirationDate,
                ),
              )
            : null,
        progressInfo: referral.rewardHasRatio
            ? ProgressInfoModel(
                earnedAmount: referral.currentRewardedAmount,
                totalToEarnAmount: referral.totalReward,
                checkpointsAchieved:
                    referral.rewardRatio?.ratioCompletions?.length ?? 0,
                checkpointsTotal: referral.rewardRatio?.ratios?.length ?? 0,
              )
            : null,
      );

  int _getDaysBetween(DateTime startDate, DateTime endDate) {
    final duration = endDate.difference(startDate);
    final days = duration.inDays;
    return days > 0 ? days : 0;
  }
}

ReferralToUiModelMapper useReferralMapper() =>
    ModuleProvider.of<AppModule>(useContext()).referralMapper;
