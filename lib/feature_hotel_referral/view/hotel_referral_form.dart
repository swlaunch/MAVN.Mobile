import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/bloc/hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/phone_and_country_code_field.dart';
import 'package:tuple/tuple.dart';

class HotelReferralForm extends HookWidget with FormMixin {
  const HotelReferralForm({
    @required this.formKey,
    @required this.fullNameContextGlobalKey,
    @required this.fullNameController,
    @required this.emailContextGlobalKey,
    @required this.emailController,
    @required this.countryCodeInputGlobalKey,
    @required this.selectedCountryCodeNotifier,
    @required this.phoneAndCountryCodeContextGlobalKey,
    @required this.phoneNumberController,
    @required this.onSubmitTap,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey fullNameContextGlobalKey;
  final TextEditingController fullNameController;
  final GlobalKey emailContextGlobalKey;
  final TextEditingController emailController;
  final GlobalKey<FormFieldState<CountryCode>> countryCodeInputGlobalKey;
  final ValueNotifier<CountryCode> selectedCountryCodeNotifier;
  final GlobalKey phoneAndCountryCodeContextGlobalKey;
  final TextEditingController phoneNumberController;
  final VoidCallback onSubmitTap;

  @override
  Widget build(BuildContext context) {
    final bloc = useHotelReferralBloc();
    final blocState = useBlocState<HotelReferralState>(bloc);
    final formAutoValidate = useState(false);

    final fullNameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final countryCodeFocusNode = useFocusNode();
    final phoneNumberFocusNode = useFocusNode();

    final fullNameValidationManager = useFieldValidationManager([
      FullNameRequiredFieldValidation(),
      MinStringLengthFieldValidation(minLength: 2),
      NameInvalidFieldValidation(),
    ]);

    final emailValidationManager = useFieldValidationManager([
      EmailRequiredFieldValidation(),
      EmailInvalidFieldValidation(),
    ]);

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

    void submitHotelReferralFunction() {
      validateAndSubmit(
          autoValidate: formAutoValidate,
          context: context,
          onSubmit: onSubmitTap,
          validationManagers: [
            fullNameValidationManager,
            emailValidationManager,
            countryCodeValidationManager,
            phoneNumberValidationManager,
          ],
          formKey: formKey,
          refocusAndEnsureVisible: true,
          focusNodeValidationManagerKeyTuples: [
            Tuple3(fullNameValidationManager, fullNameFocusNode,
                fullNameContextGlobalKey),
            Tuple3(
                emailValidationManager, emailFocusNode, emailContextGlobalKey),
            Tuple3(countryCodeValidationManager, countryCodeFocusNode,
                countryCodeInputGlobalKey),
            Tuple3(phoneNumberValidationManager, phoneNumberFocusNode,
                phoneAndCountryCodeContextGlobalKey),
          ]);
    }

    return Form(
      key: formKey,
      autovalidate: formAutoValidate.value,
      child: FormPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FieldPadding(
              CustomTextField(
                label: useLocalizedStrings().hotelReferralFullNameFieldLabel,
                hint: useLocalizedStrings().hotelReferralFullNameFieldHint,
                contextGlobalKey: fullNameContextGlobalKey,
                focusNode: fullNameFocusNode,
                valueKey: const Key('fullNameTextField'),
                textEditingController: fullNameController,
                fieldValidationManager: fullNameValidationManager,
                nextFocusNode: emailFocusNode,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            FieldPadding(
              CustomTextField(
                label: useLocalizedStrings().emailRequiredLabel,
                hint: useLocalizedStrings().emailAddressHint,
                contextGlobalKey: emailContextGlobalKey,
                valueKey: const Key('emailTextField'),
                focusNode: emailFocusNode,
                textEditingController: emailController,
                fieldValidationManager: emailValidationManager,
                nextFocusNode: countryCodeFocusNode,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            FieldPadding(
              PhoneAndCountryCodeField(
                selectedCountryCodeNotifier: selectedCountryCodeNotifier,
                phoneNumberTextEditingController: phoneNumberController,
                label: useLocalizedStrings().phoneNumberRequiredLabel,
                hint: useLocalizedStrings().phoneNumberHint,
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
                onKeyboardTextInputActionTappedSuccess:
                    submitHotelReferralFunction,
                autoValidate: formAutoValidate,
              ),
            ),
            FieldPadding(
              _buildSubmitButton(submitHotelReferralFunction, blocState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    VoidCallback submitHotelReferralFunction,
    HotelReferralState blocState,
  ) =>
      PrimaryButton(
        buttonKey: const Key('submitButton'),
        text: useLocalizedStrings().hotelReferralPageButton,
        onTap: submitHotelReferralFunction,
        isLoading: blocState is HotelReferralSubmissionLoadingState,
      );
}
