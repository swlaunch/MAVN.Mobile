import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';

class MultilineTextField extends HookWidget {
  const MultilineTextField({
    @required this.valueKey,
    this.label,
    this.hint,
    this.focusNode,
    this.contextGlobalKey,
    this.textEditingController,
    this.validationManager,
    this.fieldValidationManager,
    this.onKeyboardTextInputActionTapped,
    this.onKeyboardTextInputActionTappedError,
    this.onKeyboardTextInputActionTappedSuccess,
    this.textInputAction,
  });

  final String label;
  final String hint;
  final Key valueKey;
  final GlobalKey<FormFieldState> contextGlobalKey;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final FieldValidationManager validationManager;
  final FieldValidationManager fieldValidationManager;
  final VoidCallback onKeyboardTextInputActionTapped;
  final VoidCallback onKeyboardTextInputActionTappedError;
  final VoidCallback onKeyboardTextInputActionTappedSuccess;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) => CustomTextField(
        hint: hint,
        label: label,
        valueKey: valueKey,
        contextGlobalKey: contextGlobalKey,
        focusNode: focusNode,
        fieldValidationManager: fieldValidationManager,
        textInputAction: textInputAction,
        textEditingController: textEditingController,
        minLines: 1,
        maxLines: 999,
        maxLength: 1000,
        maxLengthEnforced: true,
        onKeyboardTextInputActionTapped: onKeyboardTextInputActionTapped,
        onKeyboardTextInputActionTappedSuccess:
            onKeyboardTextInputActionTappedSuccess,
        onKeyboardTextInputActionTappedError:
            onKeyboardTextInputActionTappedError,
        textCapitalization: TextCapitalization.sentences,
      );
}
