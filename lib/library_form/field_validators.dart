import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

typedef FieldValidatorFn<T> = bool Function(T value);

class FieldValidators {
  static bool emailFormat(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }

    const pattern = r"^(?:[a-zA-Z0-9!#$%&'*/=?^_`{|}~-]+"
        r"(?:\.[a-zA-Z0-9!#$%&'*/=?^_`{|}~-]+)*@"
        r'(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)'
        r'+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)$';

    final regExp = RegExp(pattern, caseSensitive: false);

    return regExp.hasMatch(value.trim());
  }

  static bool notRequired<T>(T value) => true;

  static bool requiredText(String value) =>
      !StringUtils.isNullOrWhitespace(value);

  static bool required<T>(T value) => value != null;

  static FieldValidatorFn<String> minLength(int min) =>
      (value) => StringUtils.isNullOrWhitespace(value) || value.length >= min;

  static FieldValidatorFn<String> maxLength(int max) =>
      (value) => StringUtils.isNullOrWhitespace(value) || value.length <= max;

  static FieldValidatorFn<String> minPhoneNumberLength(
    int min,
    ValueNotifier<CountryCode> valueNotifier,
  ) =>
      (value) =>
          StringUtils.isNullOrWhitespace(value) ||
          value.length >= min - (valueNotifier?.value?.code ?? '').length;

  static FieldValidatorFn<String> maxPhoneNumberLength(
    int max,
    ValueNotifier<CountryCode> valueNotifier,
  ) =>
      (value) =>
          StringUtils.isNullOrWhitespace(value) ||
          value.length <= max - (valueNotifier?.value?.code ?? '').length;

  static FieldValidatorFn<String> whiteSpace({bool allowWhiteSpace}) =>
      (value) {
        if (StringUtils.isNullOrEmpty(value) || allowWhiteSpace) {
          return true;
        }

        const pattern = r'^(?=.*\s)';
        final regExp = RegExp(pattern);
        final hasMatch = regExp.hasMatch(value);
        return hasMatch == allowWhiteSpace;
      };

  static FieldValidatorFn<String> containsUpperCase(
    int minUpperCaseCharacters,
  ) =>
      (value) {
        if (StringUtils.isNullOrWhitespace(value)) {
          return true;
        }

        const pattern = r'(?=.*[A-Z])';
        final regExp = RegExp(pattern);
        final matchCount = regExp.allMatches(value).length;
        return matchCount >= minUpperCaseCharacters;
      };

  static FieldValidatorFn<String> containsLowerCase(
    int minLowerCaseCharacters,
  ) =>
      (value) {
        if (StringUtils.isNullOrWhitespace(value)) {
          return true;
        }

        const pattern = r'(?=.*[a-z])';
        final regExp = RegExp(pattern);
        final matchCount = regExp.allMatches(value).length;
        return matchCount >= minLowerCaseCharacters;
      };

  static FieldValidatorFn<String> containsNumericCharacters(
    int minNumericCharacters,
  ) =>
      (value) {
        if (StringUtils.isNullOrWhitespace(value)) {
          return true;
        }

        const pattern = r'(?=.*[0-9])';
        final regExp = RegExp(pattern);
        final matchCount = regExp.allMatches(value).length;
        return matchCount >= minNumericCharacters;
      };

  static FieldValidatorFn<String> passwordContainsSpecialCharacters(
    int minSpecialCharacters,
    String validSpecialCharacters,
  ) =>
      (value) {
        if (StringUtils.isNullOrWhitespace(value)) {
          return true;
        }

        final regExp = RegExp('^(?=.*[$validSpecialCharacters])');
        final matchCount = regExp.allMatches(value).length;
        return matchCount >= minSpecialCharacters;
      };

  static FieldValidatorFn<String> passwordHasNoInvalidCharacters(
    String validSpecialCharacters,
  ) =>
      (value) {
        if (StringUtils.isNullOrWhitespace(value)) {
          return true;
        }

        final regExp = RegExp('^[a-zA-Z0-9$validSpecialCharacters]*\$');
        return regExp.hasMatch(value);
      };

  static bool nameFormat(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }

    const pattern =
        r"(^([a-zA-Z]+[\- ]?)+[a-zA-Z'’]+$)|(^([\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]+[\- ]?)+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]+$)";
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(value.trim());
  }

  static bool phoneFormat(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }

    const pattern = r'^[0-9 A-Z a-z #;,()+*-]{1,30}$';
    final regExp = RegExp(pattern, caseSensitive: false);

    return regExp.hasMatch(value.trim());
  }

  static bool countryCodeNotNullNotEmpty(CountryCode countryCode) =>
      countryCode != null &&
      countryCode.id != null &&
      countryCode.code != null &&
      countryCode.name != null;

  static bool countryNotNullNotEmpty(Country country) =>
      country is Country &&
      country != null &&
      country.id != null &&
      country.name != null;

  static FieldValidatorFn<String> textMatches(
    TextEditingController otherTextEditingController,
  ) =>
      (fieldText) {
        final otherText = otherTextEditingController.text;

        return fieldText == otherText;
      };

  static bool validDouble(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }

    return double.tryParse(value.trim()) != null;
  }

  static FieldValidatorFn<String> maximumDecimalPlaces(int precision) =>
      (fieldText) {
        if (StringUtils.isNullOrWhitespace(fieldText)) {
          return true;
        }

        final pattern = r'^\d+\.?\d{0,2}$'.replaceAll(r'2', '$precision');
        final regExp = RegExp(pattern, caseSensitive: false);
        return regExp.hasMatch(fieldText.trim());
      };

  static bool maximumTwoDecimalPlaces(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }

    const pattern = r'^\d+\.?\d{0,2}$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(value.trim());
  }

  static FieldValidatorFn<String> lessThanOrEqualTo(Decimal balance) =>
      (fieldText) => Decimal.parse(fieldText) <= balance;

  static bool atLeastOneTextRequired(List<String> items) =>
      items.any((item) => requiredText(item));

  static bool biggerThanZero(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }
    return double.tryParse(value.trim()) > 0;
  }

  static FieldValidatorFn<String> matchesLength(int length) =>
      (value) => value.length == length;

  static bool alphaNumeric(String value) {
    if (StringUtils.isNullOrWhitespace(value)) {
      return true;
    }

    const pattern = r'^[a-zA-Z0-9]+$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(value);
  }
}
