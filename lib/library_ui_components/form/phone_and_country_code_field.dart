import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/inline_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_text_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/form_field_label.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/full_page_select_field.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/read_only_text_field.dart';

class PhoneAndCountryCodeField extends HookWidget {
  const PhoneAndCountryCodeField({
    @required this.selectedCountryCodeNotifier,
    @required this.phoneNumberTextEditingController,
    @required this.label,
    this.hint,
    this.phoneNumberValueKey,
    this.countryCodeValueKey,
    this.phoneAndCountryCodeContextGlobalKey,
    this.countryCodeInputGlobalKey,
    this.countryCodeFocusNode,
    this.phoneNumberFocusNode,
    this.phoneIsReadOnly = false,
    this.nextFocusNode,
    this.textInputAction,
    this.phoneNumberValidationManager,
    this.countryCodeValidationManager,
    this.onKeyboardTextInputActionTapped,
    this.onKeyboardTextInputActionTappedError,
    this.onKeyboardTextInputActionTappedSuccess,
    this.externalValidationError,
    this.autoValidate,
  });

  final ValueNotifier<CountryCode> selectedCountryCodeNotifier;
  final TextEditingController phoneNumberTextEditingController;
  final String hint;
  final String label;
  final Key phoneNumberValueKey;
  final Key countryCodeValueKey;
  final GlobalKey phoneAndCountryCodeContextGlobalKey;
  final GlobalKey<FormFieldState<CountryCode>> countryCodeInputGlobalKey;
  final FocusNode countryCodeFocusNode;
  final FocusNode phoneNumberFocusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final FieldValidationManager phoneNumberValidationManager;
  final FieldValidationManager countryCodeValidationManager;
  final VoidCallback onKeyboardTextInputActionTapped;
  final VoidCallback onKeyboardTextInputActionTappedError;
  final VoidCallback onKeyboardTextInputActionTappedSuccess;
  final bool phoneIsReadOnly;
  final String externalValidationError;
  final ValueNotifier autoValidate;

  @override
  Widget build(BuildContext context) {
    final _autoValidate = autoValidate ?? useState(false);
    final countryCodeCurrentState = countryCodeInputGlobalKey?.currentState;
    final countryCodeHasError =
        countryCodeCurrentState != null && countryCodeCurrentState.hasError;

    void onCountryCodeUpdated() {
      if (_autoValidate.value) {
        phoneNumberValidationManager
            .validate(phoneNumberTextEditingController.value);
      }
    }

    useListenable(selectedCountryCodeNotifier)
      ..removeListener(onCountryCodeUpdated)
      ..addListener(onCountryCodeUpdated);

    return Builder(
        key: phoneAndCountryCodeContextGlobalKey,
        builder: (context) => FormField<String>(
              validator: (value) => phoneNumberValidationManager
                  ?.validator(value)
                  ?.localize(context),
              initialValue: phoneNumberTextEditingController?.text,
              autovalidate: _autoValidate.value,
              builder: (phoneNumberState) => Column(
                children: <Widget>[
                  FormFieldLabel(
                    label,
                    hasError: countryCodeHasError || phoneNumberState.hasError,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IntrinsicWidth(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FullPageSelectField<CountryCode>(
                            selectedValueNotifier: selectedCountryCodeNotifier,
                            displayValueSelector: (selectedValue) =>
                                selectedValue.code,
                            routerFn: (router) => router.pushCountryCodePage(),
                            key: countryCodeValueKey,
                            hint: LocalizedStrings.of(context)
                                .countryCodeEmptyPrompt,
                            inputGlobalKey: countryCodeInputGlobalKey,
                            fieldValidationManager:
                                countryCodeValidationManager,
                            focusNode: countryCodeFocusNode,
                            nextFocusNode: phoneIsReadOnly
                                ? nextFocusNode
                                : phoneNumberFocusNode,
                            showErrorText: false,
                          ),
                        ),
                      ),
                      _getPhoneNumberField(_autoValidate, phoneNumberState),
                    ],
                  ),
                  if (countryCodeHasError &&
                      countryCodeCurrentState?.errorText != null)
                    _buildInlineErrorWidget(countryCodeCurrentState.errorText),
                  if (phoneNumberState.hasError &&
                      phoneNumberState.errorText != null)
                    _buildInlineErrorWidget(phoneNumberState.errorText),
                  if (externalValidationError != null)
                    _buildInlineErrorWidget(externalValidationError),
                ],
              ),
            ));
  }

  Widget _buildInlineErrorWidget(String errorText) => InlineErrorWidget(
        errorMessage: errorText,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 8),
      );

  Widget _getPhoneNumberField(ValueNotifier<bool> autoValidate,
      FormFieldState<String> phoneNumberState) {
    if (phoneIsReadOnly) {
      return Expanded(
        child: ReadOnlyTextField(
          valueKey: phoneNumberValueKey,
          textEditingController: phoneNumberTextEditingController,
        ),
      );
    } else {
      return Expanded(
        child: CustomTextField(
          hint: hint,
          valueKey: phoneNumberValueKey,
          focusNode: phoneNumberFocusNode,
          autoValidate: autoValidate,
          textEditingController: phoneNumberTextEditingController,
          nextFocusNode: nextFocusNode,
          keyboardType: TextInputType.phone,
          textInputAction: textInputAction,
          formFieldState: phoneNumberState,
          fieldValidationManager: phoneNumberValidationManager,
          onKeyboardTextInputActionTapped: onKeyboardTextInputActionTapped,
          onKeyboardTextInputActionTappedError:
              onKeyboardTextInputActionTappedError,
          onKeyboardTextInputActionTappedSuccess:
              onKeyboardTextInputActionTappedSuccess,
        ),
      );
    }
  }
}
