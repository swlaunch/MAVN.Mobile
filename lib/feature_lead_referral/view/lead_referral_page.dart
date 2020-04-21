import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referal_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/referral_offer_info_widget.dart';

import 'lead_referral_form.dart';

class LeadReferralPage extends HookWidget {
  LeadReferralPage({@required this.extendedEarnRule});

  final ExtendedEarnRule extendedEarnRule;

  final _formKey = GlobalKey<FormState>();
  final _firstNameGlobalKey = GlobalKey();
  final _lastNameGlobalKey = GlobalKey();
  final _countryCodeInputGlobalKey = GlobalKey<FormFieldState<CountryCode>>();
  final _phoneAndCountryCodeContextGlobalKey = GlobalKey();
  final _emailGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bloc = useLeadReferralBloc();
    final blocState = useBlocState<LeadReferralState>(bloc);
    final router = useRouter();
    final firstNameController = useCustomTextEditingController();
    final lastNameController = useCustomTextEditingController();
    final phoneController = useCustomTextEditingController();
    final emailController = useCustomTextEditingController();
    final noteController = useCustomTextEditingController();
    final selectedCodeNotifier = useValueNotifier<CountryCode>();
    final isFormSubmissionErrorDismissed = useState(false);

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;

      bloc.submitLeadReferral(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          countryCode: selectedCodeNotifier.value,
          phone: phoneController.text,
          email: emailController.text,
          note: noteController.text,
          earnRuleId: extendedEarnRule.id);
    }

    useBlocEventListener(bloc, (event) {
      if (event is LeadReferralSubmissionSuccessEvent) {
        router.replaceWithLeadReferralSuccessPage(
          refereeFirstName: firstNameController.text,
          refereeLastName: lastNameController.text,
          extendedEarnRule: extendedEarnRule,
        );
      }
    });

    return DismissKeyboardOnTap(
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Heading(
                      useLocalizedStrings().leadReferralPageTitle,
                      icon: SvgAssets.referrals,
                    ),
                    ReferralOfferInfoWidget(extendedEarnRule: extendedEarnRule),
                    const SizedBox(height: 32),
                    LeadReferralForm(
                      formKey: _formKey,
                      firstNameContextGlobalKey: _firstNameGlobalKey,
                      lastNameContextGlobalKey: _lastNameGlobalKey,
                      countryCodeInputGlobalKey: _countryCodeInputGlobalKey,
                      phoneAndCountryCodeContextGlobalKey:
                          _phoneAndCountryCodeContextGlobalKey,
                      emailContextGlobalKey: _emailGlobalKey,
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      selectedCodeNotifier: selectedCodeNotifier,
                      phoneController: phoneController,
                      emailController: emailController,
                      noteController: noteController,
                      onSubmitTap: onSubmit,
                    )
                  ],
                ),
              ),
            ),
            if (blocState is LeadReferralSubmissionErrorState &&
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
            valueKey: const Key('leadReferralPageError'),
            text: error,
            onRetryTap: canRetry ? onRetryTap : null,
            onCloseTap: onCloseTap,
          ));
}
