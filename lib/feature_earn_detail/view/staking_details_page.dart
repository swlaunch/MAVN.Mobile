import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/ui_components/bullet_point_line_widget.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';

class StakingDetailsPage extends StatelessWidget {
  const StakingDetailsPage({this.extendedEarnRule});

  final ExtendedEarnRule extendedEarnRule;

  @override
  Widget build(BuildContext context) {
    final earnRuleCondition = extendedEarnRule.conditions.first;
    final formattedStakingAmount =
        earnRuleCondition.stakeAmount.displayValueWithoutTrailingZeroes;
    final award = extendedEarnRule.reward;

    return ScaffoldWithAppBar(
      body: Column(
        children: [
          PageTitle(title: LocalizedStrings.earnRuleDetailsHowItWorks),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BulletPointLineWidget(
                      body: _buildInfoLineOne(formattedStakingAmount),
                    ),
                    if (extendedEarnRule.isRealEstateOffer())
                      BulletPointLineWidget(
                        body: Text(
                          LocalizedStrings.stakingDetailsRealEstatePart5,
                          style: TextStyles.darkBodyBody2RegularExtraHigh,
                        ),
                      ),
                    if (earnRuleCondition.stakingRule != null &&
                        earnRuleCondition.stakingRule > 0)
                      BulletPointLineWidget(
                        body: _buildInfoLineStakingRule(
                          earnRuleCondition.stakingRule,
                        ),
                      ),
                    if (earnRuleCondition.burningRule != null &&
                        earnRuleCondition.burningRule > 0)
                      BulletPointLineWidget(
                        body: _buildInfoLineBurningRule(
                          earnRuleCondition.burningRule,
                          earnRuleCondition.stakingPeriod,
                        ),
                      ),
                    _buildAmountTable(
                      stakedAmount: earnRuleCondition.stakeAmount,
                      award: award,
                      isApproximate: extendedEarnRule.isApproximate,
                    ),
                    if (extendedEarnRule.isApproximate)
                      _buildIndicativeAmountText(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLineOne(String stakedAmount) => RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyles.darkBodyBody2RegularExtraHigh,
          children: [
            TextSpan(text: LocalizedStrings.stakingDetailsPart1),
            WidgetSpan(child: TokenAmountWithIcon(stakedAmount)),
          ],
        ),
      );

  Widget _buildIndicativeAmountText() {
    String indicativeAmountText =
        LocalizedStrings.earnRuleIndicativeAmountInfoGeneric;

    if (extendedEarnRule.isHospitalityOffer()) {
      indicativeAmountText =
          LocalizedStrings.earnRuleIndicativeAmountInfoHospitality;
    }

    if (extendedEarnRule.isRealEstateOffer()) {
      indicativeAmountText =
          LocalizedStrings.earnRuleIndicativeAmountInfoRealEstate;
    }
    return Text(
      indicativeAmountText,
      style: TextStyles.darkBodyBody2RegularExtraHigh,
    );
  }

  Widget _buildInfoLineStakingRule(double stakingRule) => RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyles.darkBodyBody2RegularExtraHigh,
          children: [
            TextSpan(
                text:
                    LocalizedStrings.stakingDetailsRealEstateStakingRulePart1),
            TextSpan(
                text: NumberFormatter.toPercentStringFromDouble(stakingRule),
                style: TextStyles.darkBodyBody2BoldHigh),
            TextSpan(
                text: LocalizedStrings
                    .stakingDetailsRealEstateStakingRulePart2_100percent),
          ],
        ),
      );

  Widget _buildInfoLineBurningRule(double burningRule, int stakingPeriod) =>
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyles.darkBodyBody2RegularExtraHigh,
          children: [
            TextSpan(
                text: LocalizedStrings.stakingDetailsRealEstateBurningRulePart1(
                    LocalizedStrings.expirationFormatDays(stakingPeriod))),
            TextSpan(
                text: NumberFormatter.toPercentStringFromDouble(burningRule),
                style: TextStyles.darkBodyBody2BoldHigh),
            TextSpan(
                text:
                    LocalizedStrings.stakingDetailsRealEstateBurningRulePart2),
          ],
        ),
      );

  Widget _buildAmountTable({
    TokenCurrency stakedAmount,
    TokenCurrency award,
    bool isApproximate,
  }) {
    final formattedAward = isApproximate
        ? '${award.displayValueWithoutTrailingZeroes}*'
        : award.displayValueWithoutTrailingZeroes;
    return Column(
      children: <Widget>[
        const SizedBox(height: 48),
        _buildTableRow(LocalizedStrings.stakingDetailsLockedAmount,
            stakedAmount.displayValueWithoutTrailingZeroes),
        _buildTableRow(LocalizedStrings.stakingDetailsReward, formattedAward),
      ],
    );
  }

  Widget _buildTableRow(String key, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                key.toUpperCase(),
                style: TextStyles.inputLabelBoldGrey,
              ),
            ),
            TokenAmountWithIcon(value),
          ],
        ),
      );
}
