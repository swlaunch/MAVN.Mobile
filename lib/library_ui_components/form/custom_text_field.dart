import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/focus_state_hook.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_field_label.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/styled_input_decoration.dart';

typedef onErrorCallback = void Function(String errorMessage);

class CustomTextField extends HookWidget {
  const CustomTextField({
    @required this.textEditingController,
    this.hint,
    this.label,
    this.contextGlobalKey,
    this.valueKey,
    this.fieldKey,
    this.keyboardType,
    this.fieldValidationManager,
    this.focusNode,
    this.nextFocusNode,
    this.onKeyboardTextInputActionTapped,
    this.onKeyboardTextInputActionTappedError,
    this.onKeyboardTextInputActionTappedSuccess,
    this.textInputAction,
    this.obscureText = false,
    this.decoration,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforced = false,
    this.suffix,
    this.formFieldState,
    this.inputFormatters,
    this.autoValidate,
    this.textCapitalization = TextCapitalization.none,
    this.regularTextStyle = TextStyles.darkInputTextBold,
    this.errorTextStyle = TextStyles.inputTextBoldError,
    this.disabledTextStyle = TextStyles.inputTextBoldDisabled,
    this.enabled = true,
    this.enableCopyPaste = true,
  });

  final TextEditingController textEditingController;
  final ValueKey valueKey;
  final GlobalKey contextGlobalKey;
  final GlobalKey<FormFieldState> fieldKey;
  final String hint;
  final String label;
  final TextInputType keyboardType;
  final FieldValidationManager fieldValidationManager;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final VoidCallback onKeyboardTextInputActionTapped;
  final VoidCallback onKeyboardTextInputActionTappedError;
  final VoidCallback onKeyboardTextInputActionTappedSuccess;
  final TextInputAction textInputAction;
  final bool obscureText;
  final InputDecoration decoration;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final bool maxLengthEnforced;
  final Widget suffix;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldState<String> formFieldState;
  final ValueNotifier autoValidate;
  final TextCapitalization textCapitalization;
  final TextStyle regularTextStyle;
  final TextStyle errorTextStyle;
  final TextStyle disabledTextStyle;
  final bool enabled;
  final bool enableCopyPaste;

  @override
  Widget build(BuildContext context) {
    final _autoValidate = autoValidate ?? useState(false);

    useFocusState(
      context: context,
      focusNode: focusNode,
    );

    void _handleKeyboardTextInputActionTapped(FormFieldState<String> state) {
      if (onKeyboardTextInputActionTapped != null) {
        onKeyboardTextInputActionTapped();
      }

      if (state.hasError) {
        if (onKeyboardTextInputActionTappedError != null) {
          onKeyboardTextInputActionTappedError();
        }

        fieldValidationManager?.notifyValidationErrors();
      } else {
        if (onKeyboardTextInputActionTappedSuccess != null) {
          onKeyboardTextInputActionTappedSuccess();
        }

        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      }
    }

    void onSubmitted(String value, FormFieldState<String> state) {
      state.validate();
      _handleKeyboardTextInputActionTapped(state);
      if (state.hasError) {
        _autoValidate.value = true;
      }
    }

    if (formFieldState != null) {
      return Builder(
        key: contextGlobalKey,
        builder: (context) => _buildTextField(
          onSubmitted: (value) => onSubmitted(value, formFieldState),
          state: formFieldState,
        ),
      );
    }
    return Builder(
      key: contextGlobalKey,
      builder: (context) => FormField<String>(
        key: fieldKey,
        // value is returning null when the textEditingController is not used.
        // Therefore textEditingController?.text is used instead.
        validator: fieldValidationManager != null
            ? (_) => fieldValidationManager
                .validator(textEditingController?.text)
                .localize(context)
            : null,
        initialValue: textEditingController?.text,
        autovalidate: _autoValidate.value,
        builder: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (label != null) FormFieldLabel(label, hasError: state.hasError),
            _buildTextField(
              onSubmitted: (value) => onSubmitted(value, state),
              state: state,
            ),
            if (state.hasError)
              InlineErrorWidget(
                errorMessage: state.errorText,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 8),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    FormFieldState state,
    ValueChanged<String> onSubmitted,
  }) =>
      TextField(
        key: valueKey,
        keyboardType: keyboardType,
        focusNode: focusNode,
        textInputAction: textInputAction,
        style: _getTextStyle(state),
        cursorColor: ColorStyles.primaryBlue,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        //This is to override Done's button automatic
        //dismissal of the keyboard
        onEditingComplete: () {},
        controller: textEditingController,
        decoration: decoration ??
            StyledInputDecoration(
              labelText: hint,
              suffix: suffix,
              hasError: state.hasError,
            ),
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforced: maxLengthEnforced,
        onChanged: state.didChange,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        enabled: enabled,
        enableInteractiveSelection: enableCopyPaste,
      );

  TextStyle _getTextStyle(FormFieldState state) {
    if (state.hasError) {
      return errorTextStyle;
    }
    if (!enabled) {
      return disabledTextStyle;
    }
    return regularTextStyle;
  }
}
