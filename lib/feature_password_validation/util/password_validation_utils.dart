import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation.dart';

class PasswordValidationUtils {
  static String buildPasswordValidationMessage<T>(
      List<FieldValidation<T>> failedFieldValidationList) {
    final filteredFailedFieldValidationList =
        failedFieldValidationList.where(_isNonInlineValidation);

    if (filteredFailedFieldValidationList.length > 1) {
      return LocalizedStrings.passwordInvalidError;
    }

    if (failedFieldValidationList.isNotEmpty) {
      return failedFieldValidationList.first.localizedString;
    }

    return null;
  }

  static bool _isNonInlineValidation<T>(FieldValidation<T> fieldValidation) =>
      fieldValidation is PasswordMinLengthFieldValidation ||
      fieldValidation is PasswordContainsUpperCaseFieldValidation ||
      fieldValidation is PasswordContainsLowerCaseFieldValidation ||
      fieldValidation is PasswordContainsNumberValidation ||
      fieldValidation is PasswordContainsSpecialSymbolValidation;
}
