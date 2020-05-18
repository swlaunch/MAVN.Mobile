import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/feature_register/analytics/register_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/select_country_field.dart';

class RegisterFormStep1 extends HookWidget with FormMixin {
  const RegisterFormStep1({
    this.lastNameGlobalKey,
    this.firstNameGlobalKey,
    this.emailGlobalKey,
    this.nationalityGlobalKey,
    this.formKey,
    this.onNextTap,
    this.emailTextEditingController,
    this.firstNameTextEditingController,
    this.lastNameTextEditingController,
    this.selectedCountryOfNationalityNotifier,
  });

  final GlobalKey lastNameGlobalKey;
  final GlobalKey firstNameGlobalKey;
  final GlobalKey emailGlobalKey;
  final GlobalKey<FormFieldState<Country>> nationalityGlobalKey;

  final GlobalKey<FormState> formKey;

  final Function onNextTap;
  final TextEditingController emailTextEditingController;
  final TextEditingController firstNameTextEditingController;
  final TextEditingController lastNameTextEditingController;
  final ValueNotifier<Country> selectedCountryOfNationalityNotifier;

  @override
  Widget build(BuildContext context) {
    final registerBloc = useRegisterBloc();
    final registerState = useBlocState<RegisterState>(registerBloc);

    final registerAnalyticsManager = useRegisterAnalyticsManager();

    final formAutoValidate = useState(false);

    final emailFocusNode = useFocusNode();
    final firstNameFocusNode = useFocusNode();
    final lastNameFocusNode = useFocusNode();
    final nationalityFocusNode = useFocusNode();

    final emailValidationManager = useFieldValidationManager([
      EmailRequiredFieldValidation(
        onValidationError:
            registerAnalyticsManager.emailEmptyClientValidationError,
      ),
      EmailInvalidFieldValidation(
        onValidationError:
            registerAnalyticsManager.emailInvalidClientValidationError,
      ),
    ]);

    final firstNameValidationManager = useFieldValidationManager([
      FirstNameRequiredFieldValidation(
        onValidationError:
            registerAnalyticsManager.firstNameInvalidClientValidationError,
      ),
      MinStringLengthFieldValidation(minLength: 2),
      NameInvalidFieldValidation(
        onValidationError:
            registerAnalyticsManager.firstNameInvalidClientValidationError,
      )
    ]);

    final lastNameValidationManager = useFieldValidationManager([
      LastNameRequiredFieldValidation(
        onValidationError:
            registerAnalyticsManager.lastNameInvalidClientValidationError,
      ),
      MinStringLengthFieldValidation(minLength: 2),
      NameInvalidFieldValidation(
        onValidationError:
            registerAnalyticsManager.lastNameInvalidClientValidationError,
      )
    ]);

    final countryValidationManager = useFieldValidationManager([
      CountryFieldValidation(
          errorMessage: LocalizedStringBuilder.empty(),
          onValidationError:
              registerAnalyticsManager.nationalityEmptyClientValidationError),
    ]);

    void onNextTapFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onNextTap,
        validationManagers: [
          emailValidationManager,
          firstNameValidationManager,
          lastNameValidationManager,
          countryValidationManager,
        ],
        formKey: formKey,
      );
    }

    return Form(
      autovalidate: formAutoValidate.value,
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: <Widget>[
              FieldPadding(
                CustomTextField(
                  label: useLocalizedStrings().emailRequiredLabel,
                  hint: useLocalizedStrings().emailAddressHint,
                  valueKey: const Key('emailTextField'),
                  contextGlobalKey: emailGlobalKey,
                  focusNode: emailFocusNode,
                  textEditingController: emailTextEditingController,
                  fieldValidationManager: emailValidationManager,
                  nextFocusNode: firstNameFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onKeyboardTextInputActionTapped:
                      registerAnalyticsManager.emailKeyboardNextButtonTapped,
                ),
              ),
              FieldPadding(
                CustomTextField(
                  label: useLocalizedStrings().firstNameRequiredLabel,
                  hint: useLocalizedStrings().firstNameHint,
                  focusNode: firstNameFocusNode,
                  contextGlobalKey: firstNameGlobalKey,
                  valueKey: const Key('firstNameTextField'),
                  textEditingController: firstNameTextEditingController,
                  fieldValidationManager: firstNameValidationManager,
                  nextFocusNode: lastNameFocusNode,
                  textInputAction: TextInputAction.next,
                  onKeyboardTextInputActionTapped: registerAnalyticsManager
                      .firstNameKeyboardNextButtonTapped,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              FieldPadding(
                CustomTextField(
                  label: useLocalizedStrings().lastNameRequiredLabel,
                  hint: useLocalizedStrings().lastNameHint,
                  focusNode: lastNameFocusNode,
                  nextFocusNode: nationalityFocusNode,
                  contextGlobalKey: lastNameGlobalKey,
                  valueKey: const Key('lastNameTextField'),
                  textEditingController: lastNameTextEditingController,
                  fieldValidationManager: lastNameValidationManager,
                  textInputAction: TextInputAction.next,
                  onKeyboardTextInputActionTapped:
                      registerAnalyticsManager.lastNameKeyboardNextButtonTapped,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              FieldPadding(
                SelectCountryField(
                  label: useLocalizedStrings().nationalityOptionalLabel,
                  hint: useLocalizedStrings().nationalityHint,
                  valueKey: const Key('nationalityField'),
                  inputGlobalKey: nationalityGlobalKey,
                  selectedCountryNotifier: selectedCountryOfNationalityNotifier,
                  fieldValidationManager: countryValidationManager,
                  focusNode: nationalityFocusNode,
                  listPageTitle: useLocalizedStrings().nationalityListPageTitle,
                ),
              ),
              PrimaryButton(
                buttonKey: const Key('registerNextButton'),
                text: useLocalizedStrings().nextPageButton,
                onTap: () {
                  registerAnalyticsManager.nextButtonTapped();
                  onNextTapFunction();
                },
                isLoading: registerState is RegisterLoadingState,
              ),
              Container(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
