import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_manager.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/util/password_validation_utils.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/view/password_validation_rules_widget.dart';
import 'package:lykke_mobile_mavn/feature_register/analytics/register_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc.dart';
import 'package:lykke_mobile_mavn/feature_register/ui_components/terms_of_use_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/password_text_field.dart';

class RegisterFormStep2 extends HookWidget with FormMixin {
  const RegisterFormStep2({
    this.passwordGlobalKey,
    this.formKey,
    this.passwordTextEditingController,
    this.onSubmitTap,
  });

  final GlobalKey passwordGlobalKey;

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordTextEditingController;
  final Function onSubmitTap;

  @override
  Widget build(BuildContext context) {
    final registerBloc = useRegisterBloc();
    final registerState = useBlocState<RegisterState>(registerBloc);

    final passwordValidationBloc = usePasswordValidationBloc();

    final registerAnalyticsManager = useRegisterAnalyticsManager();

    final formAutoValidate = useState(false);

    final termsOfUseValueNotifier = useValueNotifier(false);
    final showTermsOfUseError = useState(false);

    final passwordFocusNode = useFocusNode();

    final router = useRouter();

    final getMobileSettingsUseCase = useGetMobileSettingsUseCase(context);

    final passwordValidationManager = _getPasswordValidationManager(
        getMobileSettingsUseCase, registerAnalyticsManager);

    final termsAndConditionFieldValidationManager = useFieldValidationManager([
      CheckboxShouldBeChecked(
          localizedString:
              LazyLocalizedStrings.registerPageAgreeTermsOfUseError,
          onValidationError: registerAnalyticsManager
              .policiesCheckboxUncheckedClientValidationError),
    ]);

    final remoteConfigManager = useRemoteConfigManager();
    final isPoliciesCheckboxAboveButton = remoteConfigManager
        .readBool(RemoteConfigKeys.isPoliciesCheckboxAboveButton);

    void onRegisterSubmitFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onSubmitTap,
        validationManagers: [
          passwordValidationManager,
          termsAndConditionFieldValidationManager,
        ],
        formKey: formKey,
      );
      if (passwordValidationManager.isValid()) {
        dismissKeyboard(context);
      }

      if (!termsOfUseValueNotifier.value) {
        showTermsOfUseError.value = true;
      }
    }

    final onPasswordChanged = useMemoized(() => () {
          passwordValidationBloc
              .validatePassword(passwordTextEditingController.text);
        });

    useListenable(passwordTextEditingController)
      ..removeListener(onPasswordChanged)
      ..addListener(onPasswordChanged);

    useEffect(() {
      passwordValidationBloc
          .validatePassword(passwordTextEditingController.text);
    }, [passwordValidationBloc]);

    return Form(
      autovalidate: formAutoValidate.value,
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: <Widget>[
              FieldPadding(
                PasswordTextField(
                  label: useLocalizedStrings().passwordRequiredLabel,
                  hint: useLocalizedStrings().passwordHint,
                  valueKey: const Key('passwordTextField'),
                  contextGlobalKey: passwordGlobalKey,
                  focusNode: passwordFocusNode,
                  textEditingController: passwordTextEditingController,
                  fieldValidationManager: passwordValidationManager,
                  textInputAction: TextInputAction.done,
                  onKeyboardTextInputActionTapped:
                      registerAnalyticsManager.passwordKeyboardNextButtonTapped,
                  onKeyboardTextInputActionTappedSuccess:
                      onRegisterSubmitFunction,
                ),
              ),
              const PasswordValidationRulesWidget(),
              const SizedBox(height: 48),
              _buildErrorMessage(
                registerState: registerState,
                showTermsOfUseError: showTermsOfUseError,
              ),
              if (isPoliciesCheckboxAboveButton)
                _buildTermsOfUseCheckbox(
                  router,
                  termsOfUseValueNotifier,
                  termsAndConditionFieldValidationManager,
                  showTermsOfUseError,
                  isPoliciesCheckboxAboveButton: isPoliciesCheckboxAboveButton,
                ),
              buildRegisterSubmitButton(
                registerAnalyticsManager: registerAnalyticsManager,
                onRegisterSubmitFunction: onRegisterSubmitFunction,
                isLoading: registerState is RegisterLoadingState,
              ),
              if (!isPoliciesCheckboxAboveButton)
                _buildTermsOfUseCheckbox(
                  router,
                  termsOfUseValueNotifier,
                  termsAndConditionFieldValidationManager,
                  showTermsOfUseError,
                  isPoliciesCheckboxAboveButton: isPoliciesCheckboxAboveButton,
                ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTermsOfUseCheckbox(
          Router router,
          ValueNotifier<bool> termsOfUseValueNotifier,
          FieldValidationManager<bool> termsAndConditionFieldValidationManager,
          ValueNotifier<bool> showTermsOfUseError,
          {bool isPoliciesCheckboxAboveButton}) =>
      Padding(
        padding: EdgeInsets.only(
          bottom: isPoliciesCheckboxAboveButton ? 12 : 0,
          top: isPoliciesCheckboxAboveButton ? 0 : 12,
        ),
        child: TermsOfUseWidget(
          router: router,
          termsOfUseValueNotifier: termsOfUseValueNotifier,
          termsAndConditionFieldValidationManager:
              termsAndConditionFieldValidationManager,
          showTermsOfUseError: showTermsOfUseError,
        ),
      );

  FieldValidationManager<String> _getPasswordValidationManager(
      GetMobileSettingsUseCase getMobileSettingsUseCase,
      RegisterAnalyticsManager registerAnalyticsManager) {
    final passwordStrength =
        getMobileSettingsUseCase.execute()?.passwordStrength;

    final List<FieldValidation<String>> passwordValidationList =
        passwordStrength != null
            ? [
                PasswordNoWhiteSpaceFieldValidation(
                  allowWhiteSpace: passwordStrength.canUseSpaces,
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                ),
                PasswordMaxLengthFieldValidation(
                  maxLength: passwordStrength.maxLength,
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                ),
                PasswordMinLengthFieldValidation(
                  minLength: passwordStrength.minLength,
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                ),
                PasswordContainsUpperCaseFieldValidation(
                  minUppercaseCharacters: passwordStrength.minUpperCase,
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                ),
                PasswordContainsLowerCaseFieldValidation(
                  minLowercaseCharacters: passwordStrength.minLowerCase,
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                ),
                PasswordContainsNumberValidation(
                  minNumericCharacters: passwordStrength.minNumbers,
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                ),
                PasswordContainsSpecialSymbolValidation(
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                  minSpecialCharacters: passwordStrength.minSpecialSymbols,
                  specialCharacters: passwordStrength.specialCharacters,
                ),
                PasswordOnlyContainsValidCharactersValidation(
                  onValidationError: registerAnalyticsManager
                      .passwordInvalidClientValidationError,
                  specialCharacters: passwordStrength.specialCharacters,
                ),
              ]
            : [];

    final passwordValidationManager = useFieldValidationManager(
      [
        PasswordRequiredFieldValidation(
          onValidationError:
              registerAnalyticsManager.passwordEmptyClientValidationError,
        ),
        ...passwordValidationList,
      ],
      buildMessage: PasswordValidationUtils.buildPasswordValidationMessage,
    );
    return passwordValidationManager;
  }

  Widget buildRegisterSubmitButton({
    @required void Function() onRegisterSubmitFunction,
    @required bool isLoading,
    @required RegisterAnalyticsManager registerAnalyticsManager,
  }) =>
      PrimaryButton(
        buttonKey: const Key('registerSubmitButton'),
        text: useLocalizedStrings().submitButton,
        onTap: () {
          registerAnalyticsManager.submitButtonTapped();
          onRegisterSubmitFunction();
        },
        isLoading: isLoading,
      );

  Widget _buildErrorMessage({
    @required RegisterState registerState,
    @required ValueNotifier<bool> showTermsOfUseError,
  }) {
    if (showTermsOfUseError.value) {
      return Container(
        height: 48,
        alignment: Alignment.center,
        child: InlineErrorWidget(
            padding: const EdgeInsets.only(bottom: 8),
            keyValue: 'registerTermsOfUseError',
            errorMessage:
                useLocalizedStrings().registerPageAgreeTermsOfUseError),
      );
    }

    if (registerState is RegisterErrorState) {
      return InlineErrorWidget(
        padding: const EdgeInsets.only(bottom: 8),
        keyValue: 'registerError',
        errorMessage: registerState.error.localize(useContext()),
      );
    }

    return Container(height: 48);
  }
}
