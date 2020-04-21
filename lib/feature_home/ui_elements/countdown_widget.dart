import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/referral_to_ui_model_mapper.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/debounced_ink_well.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/previous_referrals_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';

class CountDownWidget extends HookWidget {
  const CountDownWidget({
    @required this.referrals,
    @required this.totalCount,
    this.totalWaitingTokens,
  });

  final List<CustomerCommonReferralResponseModel> referrals;
  final TokenCurrency totalWaitingTokens;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final mapper = useReferralMapper();
    return Container(
      padding: const EdgeInsets.only(top: 24),
      color: ColorStyles.white,
      child: Column(
        children: <Widget>[
          _buildTitle(
            totalWaitingTokens?.displayValueWithoutTrailingZeroes,
          ),
          _buildReferralWidget(referrals.first, mapper),
          _buildViewAllWidget(totalCount, router),
          const Divider(
            thickness: 16,
            color: ColorStyles.offWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String amount) => Padding(
        padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const StandardSizedSvg(SvgAssets.hourglass),
                const SizedBox(width: 4),
                Text(
                  useLocalizedStrings().homePageCountdownTitle,
                  style: TextStyles.darkHeadersH2,
                ),
              ],
            ),
            if (amount != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: DividerDecoration(
                      color: ColorStyles.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyles.darkBodyBody3RegularHigh,
                      children: [
                        WidgetSpan(
                            child: TokenAmountWithIcon(
                          amount,
                          textStyle: TextStyles.darkBodyBody3RegularHigh,
                        )),
                        const WidgetSpan(child: SizedBox(width: 2)),
                        TextSpan(
                            text: useLocalizedStrings()
                                .homePageCountdownSubtitle),
                      ],
                    ),
                  )
                ],
              ),
            const SizedBox(height: 8),
          ],
        ),
      );

  Widget _buildReferralWidget(CustomerCommonReferralResponseModel referral,
          ReferralToUiModelMapper mapper) =>
      PreviousReferralsWidget(
        referral: mapper.previousReferralsFromReferral(referral),
        showType: false,
      );

  Widget _buildViewAllWidget(int count, Router router) => DebouncedInkWell(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Text(
            useLocalizedStrings().homePageCountdownViewAll(count),
            style: TextStyles.linksTextLinkBold,
          ),
        ),
        onTap: router.pushReferralListPage,
      );
}
