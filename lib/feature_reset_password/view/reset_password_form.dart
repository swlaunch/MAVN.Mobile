import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_output.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/field_validation_manager_hook.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/field_padding.dart';

class ResetPasswordForm extends HookWidget with FormMixin {
  const ResetPasswordForm({
    @required this.formKey,
    @required this.emailGlobalKey,
    @required this.resetPasswordBloc,
    @required this.resetPasswordState,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey emailGlobalKey;
  final ResetPasswordBloc resetPasswordBloc;
  final ResetPasswordState resetPasswordState;

  @override
  Widget build(BuildContext context) {
    final emailTextEditingController = useCustomTextEditingController();
    final formAutoValidate = useState(false);
    final emailFocusNode = useFocusNode();
    final resetPasswordState = this.resetPasswordState;

    final emailValidationManager = useFieldValidationManager([
      EmailRequiredFieldValidation(),
      EmailInvalidFieldValidation(),
    ]);

    void onSubmitFunction() {
      validateAndSubmit(
        autoValidate: formAutoValidate,
        context: context,
        onSubmit: () {
          resetPasswordBloc.sendLink(emailTextEditingController.text);
        },
        validationManagers: [emailValidationManager],
        formKey: formKey,
      );
    }

    return Form(
      key: formKey,
      autovalidate: formAutoValidate.value,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onKeyboardTextInputActionTapped: onSubmitFunction,
              ),
            ),
            const SizedBox(height: 32),
            if (resetPasswordState is ResetPasswordErrorState)
              _buildErrorMessage(
                  errorMessage:
                      resetPasswordState.errorMessage.localize(useContext())),
            _buildButton(
              onLoginSubmitFunction: onSubmitFunction,
              isLoading: resetPasswordState is ResetPasswordLoadingState,
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    @required VoidCallback onLoginSubmitFunction,
    @required bool isLoading,
  }) =>
      PrimaryButton(
          buttonKey: const Key('resetPasswordSubmitButton'),
          text: useLocalizedStrings().submitButton,
          onTap: onLoginSubmitFunction,
          isLoading: isLoading);

  Widget _buildErrorMessage({@required String errorMessage}) =>
      InlineErrorWidget(
        keyValue: 'resetPasswordError',
        errorMessage: errorMessage,
      );
}
