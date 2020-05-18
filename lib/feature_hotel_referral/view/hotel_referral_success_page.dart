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

class HotelReferralSuccessPage extends HookWidget {
  const HotelReferralSuccessPage({
    @required this.refereeFullName,
    @required this.extendedEarnRule,
  });

  final String refereeFullName;
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
      widgetKey: const Key('hotelReferralSuccessWidget'),
      title: useLocalizedStrings().referralSuccessPageTitle,
      details: useLocalizedStrings()
              .hotelReferralSuccessPageDetails(refereeFullName) +
          (partnerNameState is PartnerNameLoadedState
              ? useLocalizedStrings()
                  .hotelReferralSuccessPageDetailsPartnerName(
                      partnerNameState.partnerName)
              : ''),
      subDetails: useLocalizedStrings().referralSuccessPageSubDetails,
      buttonText: useLocalizedStrings().referralSuccessGoToRefsButton,
      onButtonTap: () {
        router
          ..popToRoot()
          ..pushAccountPage()
          ..pushReferralListPage();
      },
      endIcon: SvgAssets.success,
    );
  }
}
