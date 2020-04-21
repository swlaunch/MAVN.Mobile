import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_ui_models/previous_referrals_list/previous_referrals_model.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PreviousReferralsWidget extends HookWidget {
  const PreviousReferralsWidget({
    @required this.referral,
    this.showType = true,
    Key key,
  }) : super(key: key);

  final PreviousReferralModel referral;
  final bool showType;

  static final DateFormat _dateFormatCurrentYear = DateFormat('HH:mm, MMMM dd');

  @override
  Widget build(BuildContext context) {
    final dateTimeManager = useDateTimeManager();
    final externalRouter = useExternalRouter();

    void onContactTap(String email) {
      externalRouter.launchEmail(
        email,
        subject: useLocalizedStrings().emailSubject,
        body: useLocalizedStrings().emailBody,
        onLaunchError: () => ToastMessage.show(
            useLocalizedStrings().contactUsLaunchContactEmailError, context),
      );
    }

    return Container(
      key: const Key('previousReferralsWidget'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        color: ColorStyles.white,
        border: Border(
          bottom: BorderSide(
            color: ColorStyles.paleLilac,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showType)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: _buildCardType()),
            ),
          _buildNameSection(),
          const SizedBox(height: 4),
          _buildDateAndPartnerNameSection(dateTimeManager),
          if (referral.rewardValue != null) _buildRewardSection(),
          if (referral.progressInfo != null || referral.stakingInfo != null)
            _buildProgressSection(onContactTap),
        ],
      ),
    );
  }

  Widget _buildDivider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: StandardDivider(),
      );

  Widget _buildRewardSection() {
    if (referral.referralStatus == ReferralStatus.expired ||
        (referral.referralStatus == ReferralStatus.ongoing &&
            ((referral?.progressInfo?.checkpointsAchieved ?? 0) > 0))) {
      return Container();
    }
    return Column(children: <Widget>[
      _buildDivider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TokenAmountWithIcon(
            referral.rewardValue.displayValueWithoutTrailingZeroes,
            textStyle: TextStyles.darkBodyBody2Bold,
            showAsterisk: referral.isApproximate,
          ),
          const SizedBox(width: 3),
          Text(useLocalizedStrings().previousReferralsCardAward,
              style: TextStyles.darkBodyBody3Regular),
          const Spacer()
        ],
      ),
    ]);
  }

  List<Widget> _buildCardType() {
    if (referral.referralType == ReferralType.realEstate) {
      return _buildType(
        SvgAssets.property,
        useLocalizedStrings().previousReferralsCardTypeRealEstate.toUpperCase(),
      );
    }

    if (referral.referralType == ReferralType.hospitality) {
      return _buildType(
        SvgAssets.hotels,
        useLocalizedStrings()
            .previousReferralsCardTypeHospitality
            .toUpperCase(),
      );
    }
    if (referral.referralType == ReferralType.friend) {
      return _buildType(
        SvgAssets.referrals,
        useLocalizedStrings()
            .previousReferralsCardTypeAppReferral
            .toUpperCase(),
      );
    }

    return [Container()];
  }

  List<Widget> _buildType(String asset, String text) => [
        SvgPicture.asset(asset),
        const SizedBox(width: 12),
        NullSafeText(
          text,
          style: TextStyles.darkBodyBody3Regular,
        ),
      ];

  Widget _buildNameSection() => NullSafeText(
        referral.referralName.localize(useContext()),
        style: TextStyles.darkBodyBody2Bold,
      );

  Widget _buildDateAndPartnerNameSection(DateTimeManager dateTimeManager) =>
      Row(
        children: <Widget>[
          NullSafeText(
            _dateFormatCurrentYear
                .format(dateTimeManager.toLocal(referral.referralCreationDate)),
            style: TextStyles.darkBodyBody4Regular,
          ),
          const SizedBox(width: 2),
          const NullSafeText('•', style: TextStyles.darkBodyBody4Regular),
          const SizedBox(width: 2),
          NullSafeText(
            referral.partnerName,
            style: TextStyles.darkBodyBody4Regular,
          )
        ],
      );

  List<Widget> _buildRemainingToEarnSection() {
    if (_shouldShowStakingInfo()) {
      return [
        NullSafeText(
          useLocalizedStrings().previousReferralsCardTimeLeftToAccept,
          style: TextStyles.darkBodyBody4Regular,
        ),
        const Spacer(),
        NullSafeText(
          useLocalizedStrings()
              .expirationFormatDays(referral.stakingInfo.stakingTimeLeft),
          style: TextStyles.darkBodyBody4Regular,
        )
      ];
    }
    if (referral.progressInfo != null) {
      return [
        NullSafeText(
          useLocalizedStrings().previousReferralsCardRemaining,
          style: TextStyles.darkBodyBody4Regular,
        ),
        const Spacer(),
        TokenAmountWithIcon(
            referral
                .progressInfo.earnedAmount.displayValueWithoutTrailingZeroes,
            textStyle: TextStyles.darkBodyBody4Regular),
        const SizedBox(width: 4),
        const Text('/', style: TextStyles.darkBodyBody4Regular),
        const SizedBox(width: 4),
        TokenAmountWithIcon(
            referral.progressInfo.totalToEarnAmount
                .displayValueWithoutTrailingZeroes,
            showAsterisk: referral.isApproximate,
            textStyle: TextStyles.darkBodyBody4Regular),
      ];
    }

    return [Container()];
  }

  List<Widget> _buildProgressBarSubtitle(Function(String) onContactTap) {
    if (_shouldShowStakingInfo() && referral.referralEmail != null) {
      return [
        NullSafeText(
          useLocalizedStrings().previousReferralsCardDontLose,
          style: TextStyles.darkBodyBody4Regular,
        ),
        const SizedBox(width: 3),
        TokenAmountWithIcon(
          referral.stakingInfo.stakingAmount.displayValueWithoutTrailingZeroes,
          textStyle: TextStyles.darkBodyBody4Regular.copyWith(
              fontWeight: FontWeight.w700, color: ColorStyles.charcoalGrey),
        ),
        const Text(
          '.',
          style: TextStyles.darkBodyBody4Regular,
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () => onContactTap(referral.referralEmail),
          child: NullSafeText(
            useLocalizedStrings().previousReferralsCardContact(
                referral.stakingInfo.stakingContact.toString()),
            style: TextStyles.textLinkButton.copyWith(height: 1.2),
          ),
        )
      ];
    }

    return [Container()];
  }

  Widget _buildProgressSection(Function(String) onContactTap) {
    if (referral.referralStatus != ReferralStatus.ongoing) {
      return Container();
    }

    return Column(children: <Widget>[
      _buildDivider(),
      Row(children: _buildRemainingToEarnSection()),
      const SizedBox(height: 8),
      LinearPercentIndicator(
        padding: const EdgeInsets.all(0),
        backgroundColor: ColorStyles.paleLilac,
        progressColor: _setProgressBarColor(),
        percent: _calculateProgressBarPercentage(),
      ),
      const SizedBox(height: 8),
      Row(children: _buildProgressBarSubtitle(onContactTap)),
    ]);
  }

  double _calculateProgressBarPercentage() {
    if (_shouldShowStakingInfo()) {
      final percentageLeft = referral.stakingInfo.stakingTimeLeft.toDouble() /
          referral.stakingInfo.stakingTotalTime;
      return 1 - percentageLeft;
    }

    if (referral.progressInfo != null) {
      return referral.progressInfo.checkpointsAchieved.toDouble() /
          referral.progressInfo.checkpointsTotal.toDouble();
    }

    return 0;
  }

  Color _setProgressBarColor() => _shouldShowStakingInfo()
      ? ColorStyles.errorRed
      : ColorStyles.charcoalGrey;

  bool _shouldShowStakingInfo() =>
      referral.hasStaking &&
      referral.stakingInfo != null &&
      (referral?.progressInfo?.checkpointsAchieved ?? 0) == 0;
}
