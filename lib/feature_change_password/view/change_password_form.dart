import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/util/password_validation_utils.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/view/password_validation_rules_widget.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/password_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:tuple/tuple.dart';

class ChangePasswordForm extends HookWidget with FormMixin {
  const ChangePasswordForm({
    @required this.state,
    @required this.buttonText,
    this.formKey,
    this.passwordGlobalKey,
    this.confirmPasswordGlobalKey,
    this.passwordTextEditingController,
    this.confirmPasswordTextEditingController,
    this.onSubmitTap,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey passwordGlobalKey;
  final GlobalKey confirmPasswordGlobalKey;
  final TextEditingController passwordTextEditingController;
  final TextEditingController confirmPasswordTextEditingController;
  final VoidCallback onSubmitTap;
  final BaseState state;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final passwordValidationBloc = usePasswordValidationBloc();

    final state = this.state;

    final formAutoValidate = useState(false);

    final passwordFocusNode = useFocusNode();
    final confirmPasswordFocusNode = useFocusNode();

    final getMobileSettingsUseCase = useGetMobileSettingsUseCase(context);

    final passwordValidationManager =
        _getPasswordValidationManager(getMobileSettingsUseCase);

    final confirmPasswordValidationManager = useFieldValidationManager([
      PasswordsDoNotMatchFieldValidation(
        otherPasswordTextEditingController: passwordTextEditingController,
      )
    ]);

    void onSubmitButtonTap() {
      validateAndSubmit(
          autoValidate: formAutoValidate,
          context: context,
          onSubmit: onSubmitTap,
          validationManagers: [
            passwordValidationManager,
            confirmPasswordValidationManager
          ],
          formKey: formKey,
          refocusAndEnsureVisible: true,
          focusNodeValidationManagerKeyTuples: [
            Tuple3(passwordValidationManager, passwordFocusNode,
                passwordGlobalKey),
            Tuple3(confirmPasswordValidationManager, confirmPasswordFocusNode,
                confirmPasswordGlobalKey),
          ]);
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

    return DismissKeyboardOnTap(
      child: Form(
        key: formKey,
        autovalidate: formAutoValidate.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FieldPadding(
              PasswordTextField(
                label: useLocalizedStrings().changePasswordPagePasswordLabel,
                hint: useLocalizedStrings().changePasswordPagePasswordHint,
                valueKey: const Key('passwordTextField'),
                contextGlobalKey: passwordGlobalKey,
                focusNode: passwordFocusNode,
                textEditingController: passwordTextEditingController,
                fieldValidationManager: passwordValidationManager,
                nextFocusNode: confirmPasswordFocusNode,
                textInputAction: TextInputAction.next,
              ),
            ),
            FieldPadding(
              PasswordTextField(
                label: useLocalizedStrings().confirmPasswordLabel,
                hint:
                    useLocalizedStrings().changePasswordPageConfirmPasswordHint,
                valueKey: const Key('confirmPasswordTextField'),
                contextGlobalKey: confirmPasswordGlobalKey,
                focusNode: confirmPasswordFocusNode,
                textEditingController: confirmPasswordTextEditingController,
                fieldValidationManager: confirmPasswordValidationManager,
                textInputAction: TextInputAction.done,
                onKeyboardTextInputActionTappedSuccess: onSubmitButtonTap,
              ),
            ),
            const PasswordValidationRulesWidget(),
            const SizedBox(height: 56),
            if (state is BaseInlineErrorState)
              _buildInlineError(state.errorMessage.localize(useContext())),
            _buildChangePasswordButton(
                onSubmitTap: onSubmitButtonTap,
                isLoading: state is BaseLoadingState,
                buttonText: buttonText),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  FieldValidationManager<String> _getPasswordValidationManager(
      GetMobileSettingsUseCase getMobileSettingsUseCase) {
    final passwordStrength =
        getMobileSettingsUseCase.execute()?.passwordStrength;

    final List<FieldValidation<String>> passwordValidationList =
        passwordStrength != null
            ? [
                PasswordNoWhiteSpaceFieldValidation(
                    allowWhiteSpace: passwordStrength.canUseSpaces),
                PasswordMaxLengthFieldValidation(
                  maxLength: passwordStrength.maxLength,
                ),
                PasswordMinLengthFieldValidation(
                  minLength: passwordStrength.minLength,
                ),
                PasswordContainsUpperCaseFieldValidation(
                  minUppercaseCharacters: passwordStrength.minUpperCase,
                ),
                PasswordContainsLowerCaseFieldValidation(
                  minLowercaseCharacters: passwordStrength.minLowerCase,
                ),
                PasswordContainsNumberValidation(
                  minNumericCharacters: passwordStrength.minNumbers,
                ),
                PasswordContainsSpecialSymbolValidation(
                  minSpecialCharacters: passwordStrength.minSpecialSymbols,
                  specialCharacters: passwordStrength.specialCharacters,
                ),
                PasswordOnlyContainsValidCharactersValidation(
                  specialCharacters: passwordStrength.specialCharacters,
                ),
              ]
            : [];

    final passwordValidationManager = useFieldValidationManager(
      [
        PasswordRequiredFieldValidation(),
        ...passwordValidationList,
      ],
      buildMessage: PasswordValidationUtils.buildPasswordValidationMessage,
    );
    return passwordValidationManager;
  }

  Widget _buildChangePasswordButton({
    @required VoidCallback onSubmitTap,
    @required bool isLoading,
    @required String buttonText,
  }) =>
      PrimaryButton(
        buttonKey: const Key('changePasswordSubmitButton'),
        text: buttonText,
        onTap: onSubmitTap,
        isLoading: isLoading,
      );

  Widget _buildInlineError(String message) => InlineErrorWidget(
        keyValue: 'changePasswordError',
        errorMessage: message,
      );
}
