import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';
import 'package:tuple/tuple.dart';

mixin FormMixin {
  void dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void refocusTextField(BuildContext context, FocusNode textFieldFocusNode) {
    FocusScope.of(context).requestFocus(textFieldFocusNode);
  }

  void refocusTextFieldByKey(GlobalKey key, FocusNode textFieldFocusNode) {
    FocusScope.of(key.currentContext).requestFocus(textFieldFocusNode);
    Scrollable.ensureVisible(key.currentContext);
  }

  void validateAndSubmit({
    @required ValueNotifier<bool> autoValidate,
    @required BuildContext context,
    @required VoidCallback onSubmit,
    @required List<FieldValidationManager> validationManagers,
    @required GlobalKey<FormState> formKey,
    List<Tuple2<FieldValidationManager, FocusNode>>
        focusNodeValidationManagerTuples,
    bool refocus = false,
    bool refocusAndEnsureVisible = false,
    List<Tuple3<FieldValidationManager, FocusNode, Key>>
        focusNodeValidationManagerKeyTuples,
  }) {
    if (formKey.currentState.validate()) {
      onSubmit();
      dismissKeyboard(context);
    } else {
      autoValidate.value = true;

      validationManagers.forEach(
          (validationManager) => validationManager.notifyValidationErrors());

      if (refocus) {
        _refocusFirstInvalid(focusNodeValidationManagerTuples, context);
        return;
      }
    }

    if (refocusAndEnsureVisible) {
      _refocusAndEnsureVisibleFirstInvalid(focusNodeValidationManagerKeyTuples);
    }
  }

  void _refocusAndEnsureVisibleFirstInvalid(
      List<Tuple3<FieldValidationManager, FocusNode, Key>>
          focusNodeValidationManagerKeyTuples) {
    if (ListUtils.isNullOrEmpty(focusNodeValidationManagerKeyTuples)) return;
    final invalid = focusNodeValidationManagerKeyTuples
        .firstWhere((tuple) => !tuple.item1.isValid(), orElse: () => null);
    if (invalid != null) {
      refocusTextFieldByKey(
        invalid.item3,
        invalid.item2,
      );
    }
  }

  void _refocusFirstInvalid(
      List<Tuple2<FieldValidationManager, FocusNode>>
          focusNodeValidationManagerTuples,
      BuildContext context) {
    if (ListUtils.isNullOrEmpty(focusNodeValidationManagerTuples)) return;
    final invalid = focusNodeValidationManagerTuples
        .firstWhere((tuple) => !tuple.item1.isValid(), orElse: () => null);
    if (invalid != null) {
      refocusTextField(
        context,
        invalid.item2,
      );
    }
  }
}
