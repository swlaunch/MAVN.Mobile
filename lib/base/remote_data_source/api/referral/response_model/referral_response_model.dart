import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class CustomerCommonReferralResponseModel {
  CustomerCommonReferralResponseModel({
    this.status,
    this.referralType,
    this.firstName,
    this.lastName,
    this.email,
    this.partnerName,
    this.timeStamp,
    this.totalReward,
    this.currentRewardedAmount,
    this.rewardHasRatio,
    this.rewardRatio,
    this.hasStaking,
    this.staking,
    this.isApproximate,
  });

  CustomerCommonReferralResponseModel.fromJson(Map<String, dynamic> json)
      : status = EnumMapper.mapFromString(
          json['Status'],
          enumValues: ReferralStatus.values,
          defaultValue: null,
        ),
        referralType = EnumMapper.mapFromString(
          json['ReferralType'],
          enumValues: ReferralType.values,
          defaultValue: null,
        ),
        firstName = json['FirstName'],
        lastName = json['LastName'],
        email = json['Email'],
        partnerName = json['PartnerName'],
        timeStamp = DateTime.tryParse(json['TimeStamp']),
        totalReward = TokenCurrency(value: json['TotalReward']),
        currentRewardedAmount =
            TokenCurrency(value: json['CurrentRewardedAmount']),
        rewardHasRatio = json['RewardHasRatio'],
        rewardRatio = json['RewardHasRatio'] && json['RewardRatio'] != null
            ? RewardRatio.fromJson(json['RewardRatio'])
            : null,
        hasStaking = json['HasStaking'],
        staking = json['HasStaking'] && json['Staking'] != null
            ? ReferralStaking.fromJson(json['Staking'])
            : null,
        isApproximate = json['IsApproximate'];

  final ReferralStatus status;
  final ReferralType referralType;
  final String firstName;
  final String lastName;
  final String email;
  final String partnerName;
  final DateTime timeStamp;
  final TokenCurrency totalReward;
  final TokenCurrency currentRewardedAmount;
  final bool rewardHasRatio;
  final RewardRatio rewardRatio;
  final bool hasStaking;
  final ReferralStaking staking;
  final bool isApproximate;

  static List<CustomerCommonReferralResponseModel> toListFromJson(
          List list) =>
      list
          .map((referralsJson) =>
              CustomerCommonReferralResponseModel.fromJson(referralsJson))
          .toList();
}

enum ReferralType { hospitality, realEstate, retail, friend }
enum ReferralStatus { ongoing, accepted, expired }

class ReferralStaking {
  ReferralStaking({
    this.stakeAmount,
    this.stakingExpirationDate,
  });

  ReferralStaking.fromJson(Map<String, dynamic> json)
      : stakeAmount = TokenCurrency(value: json['StakeAmount']),
        stakingExpirationDate =
            DateTime.tryParse(json['StakingExpirationDate']);

  final TokenCurrency stakeAmount;
  final DateTime stakingExpirationDate;
}

class RewardRatio {
  RewardRatio({
    this.ratios,
    this.ratioCompletions,
  });

  RewardRatio.fromJson(Map<String, dynamic> json)
      : ratios = Ratio.toListFromJson(json['Ratios'] as List),
        ratioCompletions =
            RatioCompletion.toListFromJson(json['RatioCompletion'] as List);

  final List<Ratio> ratios;
  final List<RatioCompletion> ratioCompletions;
}

class Ratio {
  Ratio({
    this.order,
    this.rewardRatio,
    this.paymentRatio,
    this.threshold,
  });

  Ratio.fromJson(Map<String, dynamic> json)
      : order = json['Order'],
        rewardRatio = json['RewardRatio'],
        paymentRatio = json['PaymentRatio'],
        threshold = json['Threshold'];

  static List<Ratio> toListFromJson(List list) =>
      list == null ? [] : list.map((item) => Ratio.fromJson(item)).toList();

  final int order;
  final double rewardRatio;
  final double paymentRatio;
  final double threshold;
}

class RatioCompletion {
  RatioCompletion(
    this.id,
    this.name,
    this.givenThreshold,
    this.checkpoint,
  );

  RatioCompletion.fromJson(Map<String, dynamic> json)
      : id = json['PaymentId'],
        name = json['Name'],
        givenThreshold = json['GivenThreshold'],
        checkpoint = json['Checkpoint'];

  static List<RatioCompletion> toListFromJson(List list) => list == null
      ? []
      : list.map((item) => RatioCompletion.fromJson(item)).toList();

  final String id;
  final String name;
  final double givenThreshold;
  final int checkpoint;
}
