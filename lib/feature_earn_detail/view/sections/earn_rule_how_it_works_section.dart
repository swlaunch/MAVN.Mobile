import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/ui_components/bullet_point_line_widget.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/ui_components/section_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';

class EarnRuleHowItWorksSection extends HookWidget {
  const EarnRuleHowItWorksSection(this.extendedEarnRule);

  final ExtendedEarnRule extendedEarnRule;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    if (extendedEarnRule.conditions?.isEmpty ?? true) {
      return Container();
    }
    final mandatoryCondition = extendedEarnRule.conditions.first;
    return Container(
      color: ColorStyles.white,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(
            title: useLocalizedStrings().earnRuleDetailsHowItWorks,
            leadingWidget: const StandardSizedSvg(SvgAssets.tokenLight),
          ),
          BulletPointLineWidget(
            body: _buildEarnAmountInfo(
              amount: extendedEarnRule.reward.displayValueWithoutTrailingZeroes,
              isConversionRate:
                  extendedEarnRule.rewardType == RewardType.conversionRate,
              isApproximate: extendedEarnRule.isApproximate,
            ),
          ),
          if (mandatoryCondition.hasStaking)
            BulletPointLineWidget(
              body: _buildStakingAmountInfo(
                  stakingAmount: mandatoryCondition
                      .stakeAmount.displayValueWithoutTrailingZeroes),
            ),
          BulletPointLineWidget(
            body: _buildParticipationInfo(
              participationLimit: extendedEarnRule.completionCount,
              customerParticipationCount:
                  extendedEarnRule.customerCompletionCount,
              customerEarnedSoFar: extendedEarnRule
                  .currentRewardedAmount.displayValueWithoutTrailingZeroes,
            ),
          ),
          if (extendedEarnRule.isApproximate == true)
            _buildIndicativeAmountText(),
          if (extendedEarnRule.conditions.first.hasStaking)
            _buildReadMoreButton(router, extendedEarnRule)
        ],
      ),
    );
  }

  Widget _buildEarnAmountInfo({
    String amount,
    bool isConversionRate,
    bool isApproximate,
  }) =>
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyles.darkBodyBody1RegularHigh,
          children: [
            TextSpan(
                text: useLocalizedStrings().earnRuleDetailsEarnUponCompletion),
            WidgetSpan(
              child: TokenAmountWithIcon(
                amount,
                showAsterisk: isApproximate ?? false,
              ),
            ),
            if (isConversionRate)
              TextSpan(
                  text: useLocalizedStrings()
                      .earnRuleDetailsEarnUponCompletionConversionRate),
          ],
        ),
      );

  Widget _buildStakingAmountInfo({String stakingAmount}) => RichText(
        text: TextSpan(
          style: TextStyles.darkBodyBody1RegularHigh,
          children: [
            TextSpan(
                text: useLocalizedStrings().earnRuleDetailsStakingAmountPart1),
            WidgetSpan(child: TokenAmountWithIcon(stakingAmount)),
            TextSpan(
                text: useLocalizedStrings().earnRuleDetailsStakingAmountPart2),
          ],
        ),
      );

  Widget _buildParticipationInfo({
    int participationLimit,
    int customerParticipationCount,
    String customerEarnedSoFar,
  }) {
    final hasUnlimitedParticipation = participationLimit == 0;

    final participationCountText = hasUnlimitedParticipation
        ? useLocalizedStrings().earnRuleDetailsUnlimitedParticipation
        : useLocalizedStrings().earnRuleDetailsParticipationLimit +
            useLocalizedStrings()
                .earnRuleDetailsParticipationCount(participationLimit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(participationCountText,
            style: TextStyles.darkBodyBody1RegularHigh),
        RichText(
          text: TextSpan(
            style: TextStyles.darkBodyBody1RegularHigh,
            children: [
              TextSpan(
                text: useLocalizedStrings()
                        .earnRuleDetailsPreviousParticipationPart1 +
                    useLocalizedStrings().earnRuleDetailsParticipationCount(
                        customerParticipationCount),
              ),
              TextSpan(
                  text: useLocalizedStrings()
                      .earnRuleDetailsPreviousParticipationPart2),
              WidgetSpan(
                  child:
                      TokenAmountWithIcon(customerEarnedSoFar ?? 0.toString())),
              TextSpan(
                  text: useLocalizedStrings()
                      .earnRuleDetailsPreviousParticipationPart3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicativeAmountText() {
    String indicativeAmountText =
        useLocalizedStrings().earnRuleIndicativeAmountInfoGeneric;

    if (extendedEarnRule.isHospitalityOffer()) {
      indicativeAmountText =
          useLocalizedStrings().earnRuleIndicativeAmountInfoHospitality;
    }

    if (extendedEarnRule.isRealEstateOffer()) {
      indicativeAmountText =
          useLocalizedStrings().earnRuleIndicativeAmountInfoRealEstate;
    }

    return Text(
      indicativeAmountText,
      style: TextStyles.darkBodyBody1RegularHigh,
    );
  }

  Widget _buildReadMoreButton(
    Router router,
    ExtendedEarnRule extendedEarnRule,
  ) =>
      Padding(
        padding: const EdgeInsets.only(left: 32),
        child: FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            router.pushStakingDetailsPage(extendedEarnRule);
          },
          child: Text(
            useLocalizedStrings().earnRuleDetailsReadMoreButton,
            style: TextStyles.linksTextLinkBold,
          ),
        ),
      );
}
