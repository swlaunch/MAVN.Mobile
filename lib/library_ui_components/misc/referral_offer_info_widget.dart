import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';

class ReferralOfferInfoWidget extends HookWidget {
  const ReferralOfferInfoWidget({@required this.extendedEarnRule});

  final ExtendedEarnRule extendedEarnRule;

  @override
  Widget build(BuildContext context) {
    final partnerNameBloc = usePartnerNameBloc();
    final partnerNameState = useBlocState(partnerNameBloc);
    useEffect(() {
      partnerNameBloc.getPartnerName(extendedEarnRule: extendedEarnRule);
    }, [partnerNameBloc]);

    if (partnerNameState is PartnerNameLoadedState ||
        extendedEarnRule.conditions.first.hasStaking) {
      return Column(
        children: <Widget>[
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyles.darkBodyBody1RegularHigh,
              children: [
                if (partnerNameState is PartnerNameLoadedState)
                  TextSpan(
                      text: useLocalizedStrings().hotelReferralPartnerInfo(
                          partnerNameState.partnerName)),
                if (extendedEarnRule.conditions.first.hasStaking)
                  ..._getStakingText(),
              ],
            ),
          ),
        ],
      );
    }
    return Container();
  }

  List<InlineSpan> _getStakingText() => [
        TextSpan(text: useLocalizedStrings().hotelReferralStakingInfo),
        WidgetSpan(
            child: TokenAmountWithIcon(extendedEarnRule.conditions.first
                .stakeAmount.displayValueWithoutTrailingZeroes),
            alignment: PlaceholderAlignment.middle),
      ];
}
