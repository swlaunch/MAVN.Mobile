import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    @required this.hint,
    @required this.valueKey,
    this.label,
    this.focusNode,
    this.contextGlobalKey,
    this.textEditingController,
    this.validationManager,
    this.fieldValidationManager,
    this.nextFocusNode,
    this.onKeyboardTextInputActionTapped,
    this.onKeyboardTextInputActionTappedError,
    this.onKeyboardTextInputActionTappedSuccess,
    this.textInputAction,
  });

  final String hint;
  final String label;
  final Key valueKey;
  final GlobalKey contextGlobalKey;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final FieldValidationManager validationManager;
  final FieldValidationManager fieldValidationManager;
  final FocusNode nextFocusNode;
  final VoidCallback onKeyboardTextInputActionTapped;
  final VoidCallback onKeyboardTextInputActionTappedError;
  final VoidCallback onKeyboardTextInputActionTappedSuccess;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final isPasswordFieldObscured = useState(true);

    return CustomTextField(
      hint: hint,
      label: label,
      valueKey: valueKey,
      contextGlobalKey: contextGlobalKey,
      focusNode: focusNode,
      fieldValidationManager: fieldValidationManager,
      nextFocusNode: nextFocusNode,
      textInputAction: textInputAction,
      obscureText: isPasswordFieldObscured.value,
      textEditingController: textEditingController,
      onKeyboardTextInputActionTapped: onKeyboardTextInputActionTapped,
      onKeyboardTextInputActionTappedSuccess:
          onKeyboardTextInputActionTappedSuccess,
      onKeyboardTextInputActionTappedError:
          onKeyboardTextInputActionTappedError,
      suffix: GestureDetector(
        key: const Key('obscurePasswordButton'),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          isPasswordFieldObscured.value = !isPasswordFieldObscured.value;
        },
        child: Text(isPasswordFieldObscured.value ? 'Show' : 'Hide',
            style: TextStyles.linksTextLinkBold),
      ),
    );
  }
}
