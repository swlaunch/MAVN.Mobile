import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_form/field_validators.dart';

void main() {
  group('Field Validator Tests', () {
    const _stubValidSpecialCharacters = '!@#\$%&';
    const _stubMinLength = 8;
    const _stubMaxLength = 100;

    test('password should be at least 8 characters', () {
      final minLengthValidator = FieldValidators.minLength(_stubMinLength);

      expect(minLengthValidator(''), true);
      expect(minLengthValidator(' '), true);
      expect(minLengthValidator(null), true);

      expect(minLengthValidator('abcdefg'), false);
      expect(minLengthValidator('abcdefgh'), true);
    });

    test('password should be at no more than 100 characters', () {
      final maxLengthValidator = FieldValidators.maxLength(_stubMinLength);

      expect(maxLengthValidator(''), true);
      expect(maxLengthValidator(' '), true);
      expect(maxLengthValidator(null), true);

      expect(
          FieldValidators.maxLength(_stubMaxLength)(
            '24272618583398501778'
            '24272618583398501778'
            '24272618583398501778'
            '24272618583398501778'
            '24272618583398501778',
          ),
          true);
      expect(
          FieldValidators.maxLength(_stubMaxLength)('24272618583398501778'
              '24272618583398501778'
              '24272618583398501778'
              '24272618583398501778'
              '24272618583398501778'
              '1'),
          false);
    });

    test('text should have at least one number', () {
      expect(FieldValidators.containsNumericCharacters(1)(''), true);
      expect(FieldValidators.containsNumericCharacters(1)(' '), true);
      expect(FieldValidators.containsNumericCharacters(1)(null), true);

      expect(FieldValidators.containsNumericCharacters(1)('abc'), false);

      ['abc1', '1abc', '12ab', 'a12b'].forEach((text) {
        expect(FieldValidators.containsNumericCharacters(1)(text), true);
      });
    });

    test('text should have at least one upper case', () {
      expect(FieldValidators.containsUpperCase(1)(''), true);
      expect(FieldValidators.containsUpperCase(1)(' '), true);
      expect(FieldValidators.containsUpperCase(1)(null), true);

      expect(FieldValidators.containsUpperCase(1)('abc'), false);

      ['ABC', 'Abc', 'aBc', 'abC'].forEach((text) {
        expect(FieldValidators.containsUpperCase(1)(text), true);
      });
    });

    test('text should have at least one lower case', () {
      expect(FieldValidators.containsLowerCase(1)(''), true);
      expect(FieldValidators.containsLowerCase(1)(' '), true);
      expect(FieldValidators.containsLowerCase(1)(null), true);

      expect(FieldValidators.containsLowerCase(1)('ABC'), false);

      ['abc', 'aBC', 'AbC', 'ABc'].forEach((text) {
        expect(FieldValidators.containsLowerCase(1)(text), true);
      });
    });

    test('text should have at least one special sign', () {
      [
        '',
        ' ',
        null,
      ].forEach((text) {
        expect(
            FieldValidators.passwordContainsSpecialCharacters(
                1, _stubValidSpecialCharacters)(text),
            true);
      });

      [
        'abc',
        'Abc',
        'abc1',
      ].forEach((text) {
        expect(
            FieldValidators.passwordContainsSpecialCharacters(
                1, _stubValidSpecialCharacters)(text),
            false);
      });

      [
        'abc@',
        'ab&c',
        'a%bc',
        '\$abc',
        'a#bc',
        'ab!!c',
      ].forEach((text) {
        expect(
            FieldValidators.passwordContainsSpecialCharacters(
                1, _stubValidSpecialCharacters)(text),
            true);
      });
    });

    test('text should only contain letters numbers and valid special signs',
        () {
      [
        '',
        ' ',
        null,
      ].forEach((text) {
        expect(
            FieldValidators.passwordHasNoInvalidCharacters(
                _stubValidSpecialCharacters)(text),
            true);
      });

      [
        'abc',
        'Abc',
        'abc1',
        'abc@',
        'ab&c',
        'a%bc',
        '\$abc',
        'a#bc',
        'ab!!c',
      ].forEach((text) {
        expect(
            FieldValidators.passwordHasNoInvalidCharacters(
                _stubValidSpecialCharacters)(text),
            true);
      });

      [
        'abc@\\',
        'ab&c**',
        '***',
        '~',
        '"',
        ',',
      ].forEach((text) {
        expect(
            FieldValidators.passwordHasNoInvalidCharacters(
                _stubValidSpecialCharacters)(text),
            false);
      });
    });

    test('text should have no white space', () {
      [
        'abc',
        '',
        null,
      ].forEach((value) {
        expect(FieldValidators.whiteSpace(allowWhiteSpace: false)(value), true);
      });

      [
        ' abc',
        'abc ',
        'a b c',
        // ignore: prefer_single_quotes
        """
            a
            b
            c
            """,
        //ignore: prefer_single_quotes
        " ", // tab space
        // ignore: prefer_single_quotes
        " ", // space bar space
        // ignore: prefer_single_quotes
        "   ",
      ].forEach((value) {
        expect(
            FieldValidators.whiteSpace(allowWhiteSpace: false)(value), false);
      });
    });

    test('text should match', () {
      final textEditingController = TextEditingController(text: 'abc');
      expect(FieldValidators.textMatches(textEditingController)('abc'), true);

      textEditingController.text = 'abc';
      expect(
        FieldValidators.textMatches(textEditingController)('abcde'),
        false,
      );
    });

    test('Requred Text', () {
      expect(FieldValidators.requiredText(''), false);
      expect(FieldValidators.requiredText(' '), false);
      expect(FieldValidators.requiredText(' test'), true);
    });

    test('Valid Email', () {
      expect(FieldValidators.emailFormat(null), true);
      expect(FieldValidators.emailFormat(''), true);
      expect(FieldValidators.emailFormat(' '), true);
      expect(FieldValidators.emailFormat('test@test.com'), true);
      expect(FieldValidators.emailFormat('test@test.com '), true);
      expect(FieldValidators.emailFormat(' test@test.com'), true);
      expect(FieldValidators.emailFormat(' test@test.com '), true);
    });

    test('Invalid Email', () {
      expect(FieldValidators.emailFormat('test@test,com'), false);
      expect(FieldValidators.emailFormat('test+test@test,com'), false);
      expect(FieldValidators.emailFormat('testemail+1@gmail.com'), false);
      expect(FieldValidators.emailFormat('test.email+1@gmail.com'), false);
      expect(FieldValidators.emailFormat('test.email1@gmail+.com'), false);
    });

    test('value should be less than or equal to specified value', () {
      final valueToCompare = Decimal.parse('1.62');
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('0.01'), true);
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('1.62'), true);
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('2.01'), false);
    });

    test('double value should be less than or equal to specified value', () {
      final valueToCompare = Decimal.parse('1.6256');
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('0.01'), true);
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('1.62'), true);
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('1.63'), false);
      expect(FieldValidators.lessThanOrEqualTo(valueToCompare)('2.01'), false);
    });

    test('value should not exceed 2 decimnal places', () {
      expect(FieldValidators.maximumTwoDecimalPlaces(null), true);
      expect(FieldValidators.maximumTwoDecimalPlaces(''), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('0.01'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('0.12'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.1'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.10'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.0'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.00'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.12'), true);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.123'), false);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.100'), false);
      expect(FieldValidators.maximumTwoDecimalPlaces('1.12.3'), false);
    });

    test('value should always be positive', () {
      expect(FieldValidators.biggerThanZero(null), true);
      expect(FieldValidators.biggerThanZero(''), true);
      expect(FieldValidators.biggerThanZero('0.01'), true);
      expect(FieldValidators.biggerThanZero('0'), false);
      expect(FieldValidators.biggerThanZero('-12'), false);
      expect(FieldValidators.biggerThanZero('-0.01'), false);
    });
  });
}
