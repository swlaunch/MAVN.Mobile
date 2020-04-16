import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/full_page_select_field.dart';

class SelectCountryField extends StatelessWidget {
  const SelectCountryField({
    @required this.selectedCountryNotifier,
    this.valueKey,
    this.label,
    this.hint,
    this.listPageTitle,
    this.inputGlobalKey,
    this.fieldValidationManager,
    this.focusNode,
    this.nextFocusNode,
  });

  final ValueNotifier<Country> selectedCountryNotifier;
  final Key valueKey;
  final String label;
  final String hint;
  final String listPageTitle;
  final FieldValidationManager fieldValidationManager;
  final GlobalKey<FormFieldState<Country>> inputGlobalKey;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) => FullPageSelectField<Country>(
        selectedValueNotifier: selectedCountryNotifier,
        displayValueSelector: (selectedValue) => selectedValue.name,
        routerFn: (router) => router.pushCountryPage(pageTitle: listPageTitle),
        key: valueKey,
        label: label,
        hint: hint,
        inputGlobalKey: inputGlobalKey,
        fieldValidationManager: fieldValidationManager,
        focusNode: focusNode,
        nextFocusNode: nextFocusNode,
      );
}
