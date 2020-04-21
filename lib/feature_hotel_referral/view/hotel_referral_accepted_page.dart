import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/constants/configuration.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_utility/result_feedback/view/result_feedback_page.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/on_dispose_hook.dart';

class HotelReferralAcceptedPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final referralHotelBloc = useAcceptHotelReferralBloc();
    final referralHotelState =
        useBlocState<AcceptHotelReferralState>(referralHotelBloc);

    useEffect(() {
      referralHotelBloc.acceptPendingReferral();
    }, [referralHotelBloc]);

    useOnDispose(router.markAsClosedHotelReferralAcceptedPage);

    return ResultFeedbackPage(
      widgetKey: const Key('hotelReferralSuccessWidget'),
      title: _getTitle(referralHotelState),
      details: _getDetails(referralHotelState, tokenSymbol.value),
      isLoading: referralHotelState is AcceptHotelReferralLoadingState,
      buttonText: useLocalizedStrings().continueButton,
      onButtonTap: () {
        router.pop();
      },
      startIcon: SvgAssets.hotels,
      endIcon: _getEndIcon(referralHotelState),
    );
  }

  String _getEndIcon(AcceptHotelReferralState state) {
    if (state is AcceptHotelReferralErrorState) {
      return SvgAssets.error;
    }

    if (state is AcceptHotelReferralSuccessState) {
      return SvgAssets.success;
    }
  }

  String _getTitle(AcceptHotelReferralState state) {
    if (state is AcceptHotelReferralSuccessState) {
      return useLocalizedStrings().referralAcceptedSuccessTitle;
    }

    return useLocalizedStrings().referralAcceptedTitle;
  }

  String _getDetails(AcceptHotelReferralState state, String tokenSymbol) {
    if (state is AcceptHotelReferralErrorState) {
      return state.error.localize(useContext());
    }

    if (state is AcceptHotelReferralSuccessState) {
      return useLocalizedStrings().hotelReferralAcceptedSuccessBody(
          tokenSymbol, Configuration.appCompany);
    }

    return '';
  }
}
