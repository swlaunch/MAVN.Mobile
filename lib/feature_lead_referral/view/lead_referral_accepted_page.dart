import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_utility/result_feedback/view/result_feedback_page.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/on_dispose_hook.dart';

class LeadReferralAcceptedPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final referralLeadBloc = useAcceptLeadReferralBloc();
    final referralLeadState =
        useBlocState<AcceptLeadReferralState>(referralLeadBloc);

    useEffect(() {
      referralLeadBloc.acceptPendingReferral();
    }, [referralLeadBloc]);

    useOnDispose(router.markAsClosedLeadReferralAcceptedPage);

    return ResultFeedbackPage(
      widgetKey: const Key('leadReferralSuccessWidget'),
      title: _getTitle(referralLeadState),
      details: _getDetails(referralLeadState),
      isLoading: referralLeadState is AcceptLeadReferralLoadingState,
      buttonText: useLocalizedStrings().continueButton,
      onButtonTap: () {
        router.pop();
      },
      startIcon: SvgAssets.property,
      endIcon: _getEndIcon(referralLeadState),
    );
  }

  String _getEndIcon(AcceptLeadReferralState state) {
    if (state is AcceptLeadReferralErrorState) {
      return SvgAssets.error;
    }

    if (state is AcceptLeadReferralSuccessState) {
      return SvgAssets.success;
    }
  }

  String _getTitle(AcceptLeadReferralState state) {
    if (state is AcceptLeadReferralSuccessState) {
      return useLocalizedStrings().referralAcceptedSuccessTitle;
    }

    return useLocalizedStrings().referralAcceptedTitle;
  }

  String _getDetails(AcceptLeadReferralState state) {
    if (state is AcceptLeadReferralErrorState) {
      return state.error.localize(useContext());
    }

    if (state is AcceptLeadReferralSuccessState) {
      return useLocalizedStrings().leadReferralAcceptedSuccessBody;
    }

    return '';
  }
}
