import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/library_form/field_validators.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

abstract class PasswordValidationRule {
  ///Checks whether the input value adheres to the rule and returns the value
  bool validate();

  ///Returns the text description of the rule
  String getDescription();
}

class PasswordMinLengthValidationRule extends PasswordValidationRule {
  PasswordMinLengthValidationRule({this.minCharacters, this.password});

  final int minCharacters;
  final String password;

  @override
  bool validate() =>
      !StringUtils.isNullOrWhitespace(password) &&
      FieldValidators.minLength(minCharacters)(password);

  @override
  String getDescription() =>
      LocalizedStrings.passwordValidationMinCharacters(minCharacters);
}

class PasswordMaxLengthValidationRule extends PasswordValidationRule {
  PasswordMaxLengthValidationRule({this.maxCharacters, this.password});

  final int maxCharacters;
  final String password;

  @override
  bool validate() =>
      !StringUtils.isNullOrWhitespace(password) &&
      FieldValidators.maxLength(maxCharacters)(password);

  @override
  String getDescription() =>
      LocalizedStrings.passwordValidationMinCharacters(maxCharacters);
}

class PasswordUpperCaseValidationRule extends PasswordValidationRule {
  PasswordUpperCaseValidationRule({
    @required this.minUpperCaseCharacters,
    @required this.password,
  });

  final int minUpperCaseCharacters;
  final String password;

  @override
  bool validate() =>
      !StringUtils.isNullOrWhitespace(password) &&
      FieldValidators.containsUpperCase(minUpperCaseCharacters)(password);

  @override
  String getDescription() =>
      LocalizedStrings.passwordValidationMinUpperCaseCharacters(
          minUpperCaseCharacters);
}

class PasswordLowerCaseValidationRule extends PasswordValidationRule {
  PasswordLowerCaseValidationRule({
    @required this.minLowerCaseCharacters,
    @required this.password,
  });

  final int minLowerCaseCharacters;
  final String password;

  @override
  bool validate() =>
      !StringUtils.isNullOrWhitespace(password) &&
      FieldValidators.containsLowerCase(minLowerCaseCharacters)(password);

  @override
  String getDescription() =>
      LocalizedStrings.passwordValidationMinLowerCaseCharacters(
          minLowerCaseCharacters);
}

class PasswordSpecialCharactersValidationRule extends PasswordValidationRule {
  PasswordSpecialCharactersValidationRule({
    @required this.minSpecialCharacters,
    @required this.specialCharacters,
    @required this.password,
  });

  final int minSpecialCharacters;
  final String specialCharacters;
  final String password;

  @override
  bool validate() =>
      !StringUtils.isNullOrWhitespace(password) &&
      FieldValidators.passwordContainsSpecialCharacters(
          minSpecialCharacters, specialCharacters)(password);

  @override
  String getDescription() =>
      LocalizedStrings.passwordValidationMinSpecialCharacters(
          minSpecialCharacters, specialCharacters);
}

class PasswordNumbersValidationRule extends PasswordValidationRule {
  PasswordNumbersValidationRule({
    @required this.minNumericCharacters,
    @required this.password,
  });

  final int minNumericCharacters;
  final String password;

  @override
  bool validate() =>
      !StringUtils.isNullOrWhitespace(password) &&
      FieldValidators.containsNumericCharacters(minNumericCharacters)(password);

  @override
  String getDescription() =>
      LocalizedStrings.passwordValidationMinNumericCharacters(
          minNumericCharacters);
}
