import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_form/delimiter_text_input_formatter.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_field_label.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/rectangular_input_decoration.dart';

class AmountTextField extends HookWidget {
  const AmountTextField({
    @required this.textEditingController,
    @required this.label,
    this.hint,
    this.details,
    this.amountValueKey,
    this.globalKey,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.fieldValidationManager,
    this.onKeyboardTextInputActionTapped,
    this.onKeyboardTextInputActionTappedError,
    this.onKeyboardTextInputActionTappedSuccess,
  });

  final TextEditingController textEditingController;
  final String hint;
  final Widget details;
  final String label;
  final Key amountValueKey;
  final GlobalKey globalKey;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final FieldValidationManager fieldValidationManager;
  final VoidCallback onKeyboardTextInputActionTapped;
  final VoidCallback onKeyboardTextInputActionTappedError;
  final VoidCallback onKeyboardTextInputActionTappedSuccess;

  @override
  Widget build(BuildContext context) {
    final autoValidate = useState(false);

    return Builder(
      key: globalKey,
      builder: (context) => FormField<String>(
        validator: (value) =>
            fieldValidationManager?.validator(value)?.localize(context),
        initialValue: textEditingController?.text,
        autovalidate: autoValidate.value,
        builder: (amountState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FormFieldLabel(
              label,
              hasError: amountState.hasError,
              padding: const EdgeInsets.only(bottom: 4),
            ),
            if (details != null) details,
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: hint,
                    valueKey: amountValueKey,
                    focusNode: focusNode,
                    autoValidate: autoValidate,
                    textEditingController: textEditingController,
                    nextFocusNode: nextFocusNode,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: textInputAction,
                    formFieldState: amountState,
                    fieldValidationManager: fieldValidationManager,
                    onKeyboardTextInputActionTapped:
                        onKeyboardTextInputActionTapped,
                    onKeyboardTextInputActionTappedError:
                        onKeyboardTextInputActionTappedError,
                    onKeyboardTextInputActionTappedSuccess:
                        onKeyboardTextInputActionTappedSuccess,
                    decoration: RectangularInputDecoration(
                        labelText: hint, hasError: amountState.hasError),
                    regularTextStyle: TextStyles.darkHeadersH2,
                    errorTextStyle: TextStyles.headersH2Error,
                    inputFormatters: [DelimiterTextInputFormatter()],
                  ),
                ),
              ],
            ),
            if (amountState.hasError && amountState.errorText != null)
              InlineErrorWidget(
                errorMessage: amountState.errorText,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 8),
              ),
          ],
        ),
      ),
    );
  }
}
