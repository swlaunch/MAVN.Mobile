import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/referral_offer_info_widget.dart';

import 'hotel_referral_form.dart';

class HotelReferralPage extends HookWidget with FormMixin {
  HotelReferralPage({@required this.extendedEarnRule});

  final ExtendedEarnRule extendedEarnRule;

  final _formKey = GlobalKey<FormState>();
  final _emailGlobalKey = GlobalKey();
  final _formCountryCodeInputGlobalKey =
      GlobalKey<FormFieldState<CountryCode>>();
  final _formPhoneAndCountryCodeContextGlobalKey =
      GlobalKey<FormFieldState<String>>();
  final _formFullNameContextGlobalKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final bloc = useHotelReferralBloc();
    final blocState = useBlocState<HotelReferralState>(bloc);
    final router = useRouter();
    final fullNameTextEditingController = useCustomTextEditingController();
    final emailController = useCustomTextEditingController();
    final phoneNumberTextEditingController = useCustomTextEditingController();
    final selectedCountryCodeNotifier = useValueNotifier<CountryCode>(null);
    final isFormSubmissionErrorDismissed = useState(false);

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;
      bloc.submitHotelReferral(
        fullName: fullNameTextEditingController.text,
        email: emailController.text,
        countryCodeId: selectedCountryCodeNotifier.value.id,
        phoneNumber: phoneNumberTextEditingController.text,
        earnRuleId: extendedEarnRule.id,
      );
    }

    useBlocEventListener(bloc, (event) {
      if (event is HotelReferralSubmissionSuccessEvent) {
        router.replaceWithHotelReferralSuccessPage(
          refereeFullName: fullNameTextEditingController.text,
          extendedEarnRule: extendedEarnRule,
        );
      }
    });

    return GestureDetector(
      onTap: () => dismissKeyboard(context),
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PageTitle(
                    title: useLocalizedStrings().hotelReferralPageTitle,
                    assetIconLeading: SvgAssets.hotels,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ReferralOfferInfoWidget(
                          extendedEarnRule: extendedEarnRule)),
                  const SizedBox(height: 48),
                  HotelReferralForm(
                    formKey: _formKey,
                    fullNameController: fullNameTextEditingController,
                    fullNameContextGlobalKey: _formFullNameContextGlobalKey,
                    emailContextGlobalKey: _emailGlobalKey,
                    emailController: emailController,
                    selectedCountryCodeNotifier: selectedCountryCodeNotifier,
                    countryCodeInputGlobalKey: _formCountryCodeInputGlobalKey,
                    phoneAndCountryCodeContextGlobalKey:
                        _formPhoneAndCountryCodeContextGlobalKey,
                    phoneNumberController: phoneNumberTextEditingController,
                    onSubmitTap: onSubmit,
                  )
                ],
              ),
            ),
            if (blocState is HotelReferralSubmissionErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                  error: blocState.error.localize(useContext()),
                  canRetry: blocState.canRetry,
                  onRetryTap: onSubmit,
                  onCloseTap: () {
                    isFormSubmissionErrorDismissed.value = true;
                  }),
          ],
        ),
      ),
    );
  }

  Widget _buildError({
    String error,
    bool canRetry,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      Align(
          alignment: Alignment.bottomCenter,
          child: GenericErrorWidget(
            valueKey: const Key('hotelReferralPageError'),
            text: error,
            onRetryTap: canRetry ? onRetryTap : null,
            onCloseTap: onCloseTap,
          ));
}
