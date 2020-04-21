import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referal_bloc.dart';
import 'package:lykke_mobile_mavn/feature_lead_referral/bloc/lead_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/multiline_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/phone_and_country_code_field.dart';
import 'package:tuple/tuple.dart';

class LeadReferralForm extends HookWidget with FormMixin {
  const LeadReferralForm({
    @required this.formKey,
    @required this.firstNameContextGlobalKey,
    @required this.lastNameContextGlobalKey,
    @required this.countryCodeInputGlobalKey,
    @required this.phoneAndCountryCodeContextGlobalKey,
    @required this.emailContextGlobalKey,
    @required this.firstNameController,
    @required this.lastNameController,
    @required this.selectedCodeNotifier,
    @required this.phoneController,
    @required this.emailController,
    @required this.noteController,
    @required this.onSubmitTap,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey firstNameContextGlobalKey;
  final GlobalKey lastNameContextGlobalKey;
  final GlobalKey<FormFieldState<CountryCode>> countryCodeInputGlobalKey;
  final GlobalKey phoneAndCountryCodeContextGlobalKey;
  final GlobalKey emailContextGlobalKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueNotifier<CountryCode> selectedCodeNotifier;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController noteController;
  final VoidCallback onSubmitTap;

  @override
  Widget build(BuildContext context) {
    final bloc = useLeadReferralBloc();
    final blocState = useBlocState<LeadReferralState>(bloc);
    final formAutoValidate = useState(false);

    final firstNameFocusNode = useFocusNode();
    final lastNameFocusNode = useFocusNode();
    final countryCodeFocusNode = useFocusNode();
    final phoneNumberFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final noteFocusNode = useFocusNode();

    final firstNameValidationManager = useFieldValidationManager([
      FirstNameRequiredFieldValidation(),
      MinStringLengthFieldValidation(minLength: 2),
      NameInvalidFieldValidation(),
    ]);

    final lastNameValidationManager = useFieldValidationManager([
      LastNameRequiredFieldValidation(),
      MinStringLengthFieldValidation(minLength: 2),
      NameInvalidFieldValidation(),
    ]);

    final countryCodeValidationManager =
        useFieldValidationManager([CountryCodeRequiredFieldValidation()]);

    final phoneNumberValidationManager = useFieldValidationManager([
      PhoneNumberRequiredFieldValidation(),
      MinPhoneNumberStringLengthFieldValidation(
        countryCodeValueNotifier: selectedCodeNotifier,
      ),
      MaxPhoneNumberStringLengthFieldValidation(
        countryCodeValueNotifier: selectedCodeNotifier,
      ),
      PhoneNumberInvalidFieldValidation(),
    ]);

    final emailValidationManager = useFieldValidationManager([
      EmailRequiredFieldValidation(),
      EmailInvalidFieldValidation(),
    ]);

    void submitLeadReferralFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onSubmitTap,
        validationManagers: [
          firstNameValidationManager,
          lastNameValidationManager,
          countryCodeValidationManager,
          phoneNumberValidationManager,
          emailValidationManager,
        ],
        formKey: formKey,
        refocusAndEnsureVisible: true,
        focusNodeValidationManagerKeyTuples: [
          Tuple3(firstNameValidationManager, firstNameFocusNode,
              firstNameContextGlobalKey),
          Tuple3(lastNameValidationManager, lastNameFocusNode,
              lastNameContextGlobalKey),
          Tuple3(countryCodeValidationManager, countryCodeFocusNode,
              phoneAndCountryCodeContextGlobalKey),
          Tuple3(phoneNumberValidationManager, phoneNumberFocusNode,
              phoneAndCountryCodeContextGlobalKey),
          Tuple3(emailValidationManager, emailFocusNode, emailContextGlobalKey),
        ],
      );
    }

    return Form(
      key: formKey,
      autovalidate: formAutoValidate.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FieldPadding(
            CustomTextField(
              label: useLocalizedStrings().firstNameRequiredLabel,
              hint: useLocalizedStrings().firstNameHint,
              valueKey: const Key('firstNameTextField'),
              contextGlobalKey: firstNameContextGlobalKey,
              focusNode: firstNameFocusNode,
              textEditingController: firstNameController,
              fieldValidationManager: firstNameValidationManager,
              nextFocusNode: lastNameFocusNode,
              textInputAction: TextInputAction.next,
              onKeyboardTextInputActionTapped: () {},
              textCapitalization: TextCapitalization.words,
            ),
          ),
          FieldPadding(
            CustomTextField(
              label: useLocalizedStrings().lastNameRequiredLabel,
              hint: useLocalizedStrings().lastNameHint,
              valueKey: const Key('lastNameTextField'),
              contextGlobalKey: lastNameContextGlobalKey,
              focusNode: lastNameFocusNode,
              textEditingController: lastNameController,
              fieldValidationManager: lastNameValidationManager,
              nextFocusNode: countryCodeFocusNode,
              textInputAction: TextInputAction.next,
              onKeyboardTextInputActionTapped: () {},
              textCapitalization: TextCapitalization.words,
            ),
          ),
          FieldPadding(
            PhoneAndCountryCodeField(
              phoneNumberValueKey: const Key('phoneTextField'),
              countryCodeValueKey: const Key('countryCodeField'),
              selectedCountryCodeNotifier: selectedCodeNotifier,
              countryCodeInputGlobalKey: countryCodeInputGlobalKey,
              phoneAndCountryCodeContextGlobalKey:
                  phoneAndCountryCodeContextGlobalKey,
              label: useLocalizedStrings().phoneNumberRequiredLabel,
              hint: useLocalizedStrings().phoneNumberHint,
              countryCodeFocusNode: countryCodeFocusNode,
              phoneNumberFocusNode: phoneNumberFocusNode,
              phoneNumberTextEditingController: phoneController,
              phoneNumberValidationManager: phoneNumberValidationManager,
              countryCodeValidationManager: countryCodeValidationManager,
              nextFocusNode: emailFocusNode,
              textInputAction: TextInputAction.next,
              onKeyboardTextInputActionTapped: () {},
              autoValidate: formAutoValidate,
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
              nextFocusNode: noteFocusNode,
              textInputAction: TextInputAction.next,
              onKeyboardTextInputActionTapped: () {},
            ),
          ),
          FieldPadding(
            MultilineTextField(
              label: useLocalizedStrings()
                  .leadReferralFormPageCommunityOfInterestLabel,
              hint: useLocalizedStrings().noteHint,
              valueKey: const Key('noteTextField'),
              focusNode: noteFocusNode,
              textEditingController: noteController,
              textInputAction: TextInputAction.newline,
              onKeyboardTextInputActionTapped: () {},
            ),
          ),
          FieldPadding(
            buildSubmitButton(submitLeadReferralFunction, blocState),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton(
    VoidCallback submitLeadReferralFunction,
    LeadReferralState blocState,
  ) =>
      PrimaryButton(
        buttonKey: const Key('submitButton'),
        text: useLocalizedStrings().submitButton,
        onTap: () {
          submitLeadReferralFunction();
        },
        isLoading: blocState is LeadReferralSubmissionLoadingState,
      );
}
