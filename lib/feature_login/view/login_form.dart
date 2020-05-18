import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_login/anaytics/login_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/password_text_field.dart';
import 'package:tuple/tuple.dart';

class LoginForm extends HookWidget with FormMixin {
  const LoginForm({
    this.formKey,
    this.emailGlobalKey,
    this.emailFieldKey,
    this.passwordGlobalKey,
    this.emailTextEditingController,
    this.passwordTextEditingController,
    this.onSubmit,
  });

  final GlobalKey<FormState> formKey;

  final GlobalKey emailGlobalKey;
  final GlobalKey<FormFieldState> emailFieldKey;
  final GlobalKey passwordGlobalKey;
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final loginBloc = useLoginBloc();
    final loginState = useBlocState<LoginState>(loginBloc);

    final router = useRouter();
    final loginAnalyticsManager = useLoginAnalyticsManager();

    final formAutoValidate = useState(false);

    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    final emailValidationManager = useFieldValidationManager([
      EmailRequiredFieldValidation(
        onValidationError:
            loginAnalyticsManager.emailEmptyClientValidationError,
      ),
      EmailInvalidFieldValidation(
        onValidationError:
            loginAnalyticsManager.emailInvalidClientValidationError,
      ),
    ]);

    final passwordValidationManager = useFieldValidationManager([
      PasswordRequiredFieldValidation(
        onValidationError:
            loginAnalyticsManager.passwordEmptyClientValidationError,
      ),
    ]);

    void onLoginSubmitFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: onSubmit,
        validationManagers: [emailValidationManager, passwordValidationManager],
        formKey: formKey,
        focusNodeValidationManagerTuples: [
          Tuple2(emailValidationManager, emailFocusNode),
          Tuple2(passwordValidationManager, passwordFocusNode),
        ],
        refocus: true,
      );
    }

    return Form(
      key: formKey,
      autovalidate: formAutoValidate.value,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FieldPadding(
                CustomTextField(
                  label: useLocalizedStrings().loginPageEmailLabel,
                  hint: useLocalizedStrings().emailAddressHint,
                  valueKey: const Key('emailTextField'),
                  contextGlobalKey: emailGlobalKey,
                  fieldKey: emailFieldKey,
                  focusNode: emailFocusNode,
                  textEditingController: emailTextEditingController,
                  fieldValidationManager: emailValidationManager,
                  nextFocusNode: passwordFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onKeyboardTextInputActionTapped:
                      loginAnalyticsManager.emailKeyboardNextButtonTapped,
                ),
              ),
              PasswordTextField(
                label: useLocalizedStrings().loginPagePasswordLabel,
                hint: useLocalizedStrings().loginPagePasswordHint,
                valueKey: const Key('passwordTextField'),
                contextGlobalKey: passwordGlobalKey,
                focusNode: passwordFocusNode,
                textEditingController: passwordTextEditingController,
                fieldValidationManager: passwordValidationManager,
                textInputAction: TextInputAction.done,
                onKeyboardTextInputActionTapped:
                    loginAnalyticsManager.passwordKeyboardDoneButtonTapped,
                onKeyboardTextInputActionTappedSuccess: onLoginSubmitFunction,
              ),
              const SizedBox(height: 12),
              _buildForgotPasswordButton(router),
              const SizedBox(height: 32),
              if (loginState is LoginErrorState)
                _buildErrorMessage(
                    errorMessage: loginState.error.localize(useContext())),
              buildLoginButton(
                onLoginSubmitFunction: onLoginSubmitFunction,
                loginAnalyticsManager: loginAnalyticsManager,
                isLoading: loginState is LoginLoadingState,
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(Router router) => FlatButton(
        padding: const EdgeInsets.all(0),
        onPressed: router.pushResetPasswordPage,
        child: Text(
          useLocalizedStrings().loginPageForgottenPasswordButton,
          style: TextStyles.linksTextLinkBold,
        ),
      );

  Widget buildLoginButton({
    @required VoidCallback onLoginSubmitFunction,
    @required LoginAnalyticsManager loginAnalyticsManager,
    @required bool isLoading,
  }) =>
      PrimaryButton(
          buttonKey: const Key('loginSubmitButton'),
          text: useLocalizedStrings().loginPageLoginSubmitButton,
          onTap: () {
            loginAnalyticsManager.submitButtonTapped();
            onLoginSubmitFunction();
          },
          isLoading: isLoading);

  Widget _buildErrorMessage({@required String errorMessage}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: InlineErrorWidget(
          keyValue: 'loginError',
          errorMessage: errorMessage,
        ),
      );
}
