import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_utility/result_feedback/view/result_feedback_page.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class LeadReferralSuccessPage extends HookWidget {
  const LeadReferralSuccessPage({
    @required this.refereeFirstName,
    @required this.refereeLastName,
    @required this.extendedEarnRule,
  });

  final String refereeFirstName;
  final String refereeLastName;
  final ExtendedEarnRule extendedEarnRule;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final partnerNameBloc = usePartnerNameBloc();
    final partnerNameState = useBlocState(partnerNameBloc);

    useEffect(() {
      partnerNameBloc.getPartnerName(extendedEarnRule: extendedEarnRule);
    }, [partnerNameBloc]);

    return ResultFeedbackPage(
      widgetKey: const Key('leadReferralSuccessWidget'),
      title: useLocalizedStrings().referralSuccessPageTitle,
      details: useLocalizedStrings().leadReferralSuccessPageDetails(
            refereeFirstName,
            refereeLastName,
          ) +
          (partnerNameState is PartnerNameLoadedState
              ? useLocalizedStrings().leadReferralSuccessPageDetailsPartnerName(
                  partnerNameState.partnerName)
              : ''),
      buttonText: useLocalizedStrings().referralSuccessGoToRefsButton,
      onButtonTap: () {
        router
          ..popToRoot()
          ..pushReferralListPage();
      },
      subDetails: useLocalizedStrings().referralSuccessPageSubDetails,
      endIcon: SvgAssets.success,
    );
  }
}
