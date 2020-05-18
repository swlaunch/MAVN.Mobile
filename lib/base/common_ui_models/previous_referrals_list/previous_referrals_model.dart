import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class PreviousReferralModel {
  PreviousReferralModel({
    this.referralStatus,
    this.referralType,
    this.referralName,
    this.referralEmail,
    this.partnerName,
    this.referralCreationDate,
    this.rewardValue,
    this.hasStaking,
    this.stakingInfo,
    this.progressInfo,
    this.isApproximate,
  });

  final ReferralStatus referralStatus;
  final ReferralType referralType;
  final LocalizedStringBuilder referralName;
  final String referralEmail;
  final String partnerName;
  final DateTime referralCreationDate;
  final TokenCurrency rewardValue;
  final bool hasStaking;
  final StakingInfoModel stakingInfo;
  final ProgressInfoModel progressInfo;
  final bool isApproximate;
}

class ProgressInfoModel {
  ProgressInfoModel({
    this.earnedAmount,
    this.totalToEarnAmount,
    this.checkpointsAchieved,
    this.checkpointsTotal,
  });

  final TokenCurrency earnedAmount;
  final TokenCurrency totalToEarnAmount;
  final int checkpointsAchieved;
  final int checkpointsTotal;
}

class StakingInfoModel {
  StakingInfoModel({
    this.stakingAmount,
    this.stakingContact,
    this.stakingTimeLeft,
    this.stakingTotalTime,
  });

  final TokenCurrency stakingAmount;
  final String stakingContact;
  final int stakingTimeLeft;
  final int stakingTotalTime;
}
