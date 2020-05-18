import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';

class CustomCheckbox extends HookWidget {
  const CustomCheckbox(
      {@required this.isCheckedValueNotifier,
      @required this.onChanged,
      this.fieldValidationManager,
      this.showError = false,
      this.valueKey});

  final ValueNotifier<bool> isCheckedValueNotifier;
  final ValueChanged<bool> onChanged;
  final FieldValidationManager fieldValidationManager;
  final bool showError;
  final ValueKey valueKey;

  @override
  Widget build(BuildContext context) {
    useListenable(isCheckedValueNotifier);

    return FormField<bool>(
      initialValue: isCheckedValueNotifier.value,
      validator: (_) => fieldValidationManager
          ?.validator(isCheckedValueNotifier.value)
          ?.localize(context),
      builder: (state) => Theme(
        data: ThemeData(
          unselectedWidgetColor:
              showError ? ColorStyles.errorRed : ColorStyles.primaryBlue,
        ),
        child: Checkbox(
          key: valueKey,
          activeColor: ColorStyles.primaryBlue,
          checkColor: ColorStyles.white,
          value: isCheckedValueNotifier.value,
          onChanged: (isChecked) {
            isCheckedValueNotifier.value = isChecked;
            onChanged(isCheckedValueNotifier.value);
          },
        ),
      ),
    );
  }
}
