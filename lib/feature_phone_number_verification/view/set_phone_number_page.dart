import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/analytics/phone_number_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/view/set_phone_number_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class SetPhoneNumberPage extends HookWidget {
  SetPhoneNumberPage({
    Key key,
  }) : super(key: key);

  static const _step = 3;

  final _formKey = GlobalKey<FormState>();

  final _formCountryCodeInputGlobalKey =
      GlobalKey<FormFieldState<CountryCode>>();

  final _formPhoneAndCountryCodeContextGlobalKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final countryCodeBloc = useCountryCodeListBloc();
    final setPhoneNumberBloc = useSetPhoneNumberBloc();
    final setPhoneNumberBlocState =
        useBlocState<SetPhoneNumberState>(setPhoneNumberBloc);

    final isErrorDismissed = useState(false);

    final phoneNumberTextEditingController = useCustomTextEditingController();
    final selectedCountryCodeNotifier = useValueNotifier<CountryCode>(null);

    final phoneNumberAnalyticsManager = usePhoneNumberAnalyticsManager();

    void setPhoneNumber() {
      isErrorDismissed.value = false;
      setPhoneNumberBloc.setPhoneNumber(
        phoneNumber: phoneNumberTextEditingController.text,
        countryPhoneCodeId: selectedCountryCodeNotifier.value.id,
      );
    }

    useEffect(() {
      countryCodeBloc.loadCountryCodeList();
    }, [countryCodeBloc]);

    useBlocEventListener(countryCodeBloc, (event) {
      if (event is CountryCodeListLoadedEvent) {
        countryCodeBloc.getCountryCodeFromSim(event.countryCodeList);
        return;
      }

      if (event is UserSimCountryCodeSuccessEvent) {
        selectedCountryCodeNotifier.value = event.userCountryCode;
        return;
      }
    });

    useBlocEventListener(setPhoneNumberBloc, (event) {
      if (event is SetPhoneNumberEvent) {
        phoneNumberAnalyticsManager.verificationCodeSent();
        router.pushPhoneCodeVerificationPage();
      }
    });

    return DismissKeyboardOnTap(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: ScaffoldWithLogo(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Heading(
                    LocalizedStrings.setPhoneNumberPageTitle,
                    currentStep: _step.toString(),
                    totalSteps: _step.toString(),
                  ),
                ),
                const SizedBox(height: 24),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24),
                      child: SetPhoneNumberForm(
                        formKey: _formKey,
                        countryCodeInputGlobalKey:
                            _formCountryCodeInputGlobalKey,
                        phoneAndCountryCodeContextGlobalKey:
                            _formPhoneAndCountryCodeContextGlobalKey,
                        phoneNumberTextEditingController:
                            phoneNumberTextEditingController,
                        selectedCountryCodeNotifier:
                            selectedCountryCodeNotifier,
                        onNextTap: setPhoneNumber,
                      ),
                    ),
                    if (setPhoneNumberBlocState is SetPhoneNumberErrorState &&
                        !isErrorDismissed.value)
                      _buildGenericError(
                        error: setPhoneNumberBlocState.errorMessage,
                        onRetryTap: setPhoneNumber,
                        onCloseTap: () => isErrorDismissed.value = true,
                      ),
                    if (setPhoneNumberBlocState
                        is SetPhoneNumberNetworkErrorState)
                      _buildNetworkError(onRetryTap: setPhoneNumber)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenericError({
    String error,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      GenericErrorWidget(
        text: error,
        onRetryTap: onRetryTap,
        onCloseTap: onCloseTap,
        valueKey: const Key('phoneVerificationError'),
      );

  Widget _buildNetworkError({VoidCallback onRetryTap}) => Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: NetworkErrorWidget(onRetry: onRetryTap),
      );
}
