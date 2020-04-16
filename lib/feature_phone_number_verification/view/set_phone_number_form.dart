import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/analytics/phone_number_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/phone_and_country_code_field.dart';

class SetPhoneNumberForm extends HookWidget with FormMixin {
  const SetPhoneNumberForm({
    this.countryCodeInputGlobalKey,
    this.phoneAndCountryCodeContextGlobalKey,
    this.formKey,
    this.onNextTap,
    this.selectedCountryCodeNotifier,
    this.phoneNumberTextEditingController,
  });

  final GlobalKey phoneAndCountryCodeContextGlobalKey;
  final GlobalKey<FormFieldState<CountryCode>> countryCodeInputGlobalKey;

  final GlobalKey<FormState> formKey;

  final Function onNextTap;

  final TextEditingController phoneNumberTextEditingController;
  final ValueNotifier<CountryCode> selectedCountryCodeNotifier;

  @override
  Widget build(BuildContext context) {
    final setPhoneNumberBloc = useSetPhoneNumberBloc();
    final setPhoneNumberState =
        useBlocState<SetPhoneNumberState>(setPhoneNumberBloc);

    final logoutUseCase = useLogOutUseCase();
    final router = useRouter();

    final formAutoValidate = useState(false);

    final countryCodeFocusNode = useFocusNode();
    final phoneNumberFocusNode = useFocusNode();

    final countryCodeValidationManager =
        useFieldValidationManager([CountryCodeRequiredFieldValidation()]);

    final phoneNumberValidationManager = useFieldValidationManager([
      PhoneNumberRequiredFieldValidation(),
      MinPhoneNumberStringLengthFieldValidation(
        countryCodeValueNotifier: selectedCountryCodeNotifier,
      ),
      MaxPhoneNumberStringLengthFieldValidation(
        countryCodeValueNotifier: selectedCountryCodeNotifier,
      ),
      PhoneNumberInvalidFieldValidation(),
    ]);

    final phoneNumberAnalyticsManager = usePhoneNumberAnalyticsManager();

    void onNextTapFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onNextTap,
        validationManagers: [
          countryCodeValidationManager,
          phoneNumberValidationManager
        ],
        formKey: formKey,
      );
    }

    void onRegisterWithAnotherAccountButtonTapped() {
      phoneNumberAnalyticsManager.registerWithAnotherAccountTap();
      logoutUseCase.execute();
      router.navigateToRegisterPage();
    }

    return Form(
      autovalidate: formAutoValidate.value,
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            FieldPadding(
              PhoneAndCountryCodeField(
                selectedCountryCodeNotifier: selectedCountryCodeNotifier,
                phoneNumberTextEditingController:
                    phoneNumberTextEditingController,
                label: LocalizedStrings.phoneNumberRequiredLabel,
                hint: LocalizedStrings.phoneNumberHint,
                phoneNumberValueKey: const Key('phoneNumberTextField'),
                countryCodeValueKey: const Key('countryCodeField'),
                phoneAndCountryCodeContextGlobalKey:
                    phoneAndCountryCodeContextGlobalKey,
                countryCodeInputGlobalKey: countryCodeInputGlobalKey,
                countryCodeFocusNode: countryCodeFocusNode,
                phoneNumberFocusNode: phoneNumberFocusNode,
                textInputAction: TextInputAction.done,
                countryCodeValidationManager: countryCodeValidationManager,
                phoneNumberValidationManager: phoneNumberValidationManager,
                onKeyboardTextInputActionTappedSuccess: onNextTapFunction,
                externalValidationError:
                    setPhoneNumberState is SetPhoneNumberInlineErrorState
                        ? setPhoneNumberState.errorMessage
                        : null,
                autoValidate: formAutoValidate,
              ),
            ),
            PrimaryButton(
              isLoading: setPhoneNumberState is SetPhoneNumberLoadingState,
              buttonKey: const Key('setPhoneNumberButton'),
              text: LocalizedStrings.setPhoneNumberVerifyButton,
              onTap: () {
                phoneNumberAnalyticsManager.sendVerificationCodeTap();
                onNextTapFunction();
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: onRegisterWithAnotherAccountButtonTapped,
                child: Text(
                  LocalizedStrings.registerWithAnotherAccountButton,
                  style: TextStyles.linksTextLinkBoldHigh,
                ),
              ),
            ),
            Container(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
