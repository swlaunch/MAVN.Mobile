import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/ui_components/radio_button.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/on_dispose_hook.dart';
import 'package:lykke_mobile_mavn/library_form/decimal_text_input_formatter.dart';
import 'package:lykke_mobile_mavn/library_form/delimiter_text_input_formatter.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_field_label.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/rectangular_input_decoration.dart';

class PropertyPaymentAmountWidget extends HookWidget {
  const PropertyPaymentAmountWidget({
    @required this.textEditingController,
    @required this.label,
    this.hint,
    this.details,
    this.amountValueKey,
    this.globalKey,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.fieldFullAmountValidationManager,
    this.fieldPartialAmountValidationManager,
    this.onKeyboardTextInputActionTapped,
    this.onKeyboardTextInputActionTappedError,
    this.onKeyboardTextInputActionTappedSuccess,
    this.fullAmount,
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
  final FieldValidationManager fieldFullAmountValidationManager;
  final FieldValidationManager fieldPartialAmountValidationManager;
  final VoidCallback onKeyboardTextInputActionTapped;
  final VoidCallback onKeyboardTextInputActionTappedError;
  final VoidCallback onKeyboardTextInputActionTappedSuccess;
  final String fullAmount;

  @override
  Widget build(BuildContext context) {
    final propertyAmountBloc = usePropertyPaymentAmountBloc();
    final propertyAmountState = useBlocState(propertyAmountBloc);

    final localSettingsRepository = useLocalSettingsRepository();

    final autoValidate = useState(false);

    useBlocEventListener(propertyAmountBloc, (event) {
      if (event is PropertyPaymentUpdatedAmountEvent) {
        textEditingController.text = event.amount;
      }
    });

    dynamic onOptionSelected(dynamic selectedAmountSize) {
      propertyAmountBloc.switchAmountSize(selectedAmountSize);
      return selectedAmountSize;
    }

    void onTextChangedListener() {
      propertyAmountBloc.setAmount(textEditingController.text);
    }

    useEffect(() {
      propertyAmountBloc.initialize(fullAmount: fullAmount);
    }, [globalKey]);

    useEffect(() {
      textEditingController.addListener(onTextChangedListener);
    }, [textEditingController]);
    useOnDispose(() {
      textEditingController.removeListener(onTextChangedListener);
    });
    if (propertyAmountState is PropertyPaymentSelectedAmountState) {
      return Builder(
        key: globalKey,
        builder: (context) => FormField<String>(
          validator: (value) =>
              propertyAmountState.amountSize == AmountSize.partial
                  ? fieldPartialAmountValidationManager
                      ?.validator(value)
                      ?.localize(context)
                  : fieldFullAmountValidationManager
                      ?.validator(value)
                      ?.localize(context),
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
              _buildRadioGroup(
                  context, propertyAmountState.amountSize, onOptionSelected),
              if (details != null) ...[const SizedBox(height: 8), details],
              const SizedBox(height: 8),
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
                      fieldValidationManager:
                          propertyAmountState.amountSize == AmountSize.partial
                              ? fieldPartialAmountValidationManager
                              : fieldFullAmountValidationManager,
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
                      disabledTextStyle: TextStyles.headersH2Disabled,
                      enabled:
                          propertyAmountState.amountSize == AmountSize.partial,
                      enableCopyPaste: false,
                      inputFormatters: [
                        DelimiterTextInputFormatter(),
                        DecimalTextInputFormatter(
                            decimalRange: localSettingsRepository
                                .getMobileSettings()
                                .tokenPrecision),
                      ],
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

    return Container();
  }

  Widget _buildRadioGroup(
          BuildContext context, AmountSize selected, Function onChanged) =>
      Row(
        children: <Widget>[
          _buildRadioButton(
            value: AmountSize.full,
            groupValue: selected,
            onChanged: onChanged,
            text: LocalizedStrings.of(context).propertyPaymentFull,
          ),
          const SizedBox(width: 16),
          _buildRadioButton(
            value: AmountSize.partial,
            groupValue: selected,
            onChanged: onChanged,
            text: LocalizedStrings.of(context).propertyPaymentPartial,
          ),
        ],
      );

  Widget _buildRadioButton({
    AmountSize value,
    AmountSize groupValue,
    Function(dynamic val) onChanged,
    String text,
  }) =>
      RadioButton(
        title: text,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      );
}
