import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/constants/field_constants.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/library_form/field_validators.dart';

class FieldValidation<T> {
  FieldValidation({
    @required this.validate,
    @required this.localizedString,
    this.onValidationError,
  });

  final VoidCallback onValidationError;
  final FieldValidatorFn<T> validate;
  final String localizedString;

  ValueNotifier<bool> isValid = ValueNotifier(true);

  void dispose() => isValid.dispose();
}

class FirstNameRequiredFieldValidation extends FieldValidation<String> {
  FirstNameRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LocalizedStrings.emptyFirstNameClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class LastNameRequiredFieldValidation extends FieldValidation<String> {
  LastNameRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LocalizedStrings.emptyLastNameClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class FullNameRequiredFieldValidation extends FieldValidation<String> {
  FullNameRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LocalizedStrings.emptyFullNameClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class MinStringLengthFieldValidation extends FieldValidation<String> {
  MinStringLengthFieldValidation({
    @required minLength,
    onValidationError,
  }) : super(
          validate: FieldValidators.minLength(minLength),
          localizedString:
              LocalizedStrings.minLengthClientSideValidationError(minLength),
          onValidationError: onValidationError,
        );
}

class MinPhoneNumberStringLengthFieldValidation
    extends FieldValidation<String> {
  MinPhoneNumberStringLengthFieldValidation({
    @required countryCodeValueNotifier,
    minLength = FieldConstants.minPhoneNumberLength,
    onValidationError,
  }) : super(
          validate: FieldValidators.minPhoneNumberLength(
            minLength,
            countryCodeValueNotifier,
          ),
          localizedString:
              LocalizedStrings.minPhoneNumberLengthClientSideValidationError(
                  minLength),
          onValidationError: onValidationError,
        );
}

class MaxPhoneNumberStringLengthFieldValidation
    extends FieldValidation<String> {
  MaxPhoneNumberStringLengthFieldValidation({
    @required countryCodeValueNotifier,
    maxLength = FieldConstants.maxPhoneNumberLength,
    onValidationError,
  }) : super(
          validate: FieldValidators.maxPhoneNumberLength(
            maxLength,
            countryCodeValueNotifier,
          ),
          localizedString:
              LocalizedStrings.maxPhoneNumberLengthClientSideValidationError(
                  maxLength),
          onValidationError: onValidationError,
        );
}

class NameInvalidFieldValidation extends FieldValidation<String> {
  NameInvalidFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.nameFormat,
          localizedString:
              LocalizedStrings.invalidCharactersClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class EmailRequiredFieldValidation extends FieldValidation<String> {
  EmailRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LocalizedStrings.emptyEmailClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class EmailInvalidFieldValidation extends FieldValidation<String> {
  EmailInvalidFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.emailFormat,
          localizedString:
              LocalizedStrings.invalidEmailClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PasswordRequiredFieldValidation extends FieldValidation<String> {
  PasswordRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LocalizedStrings.emptyPasswordClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PasswordOnlyContainsValidCharactersValidation
    extends FieldValidation<String> {
  PasswordOnlyContainsValidCharactersValidation({
    @required String specialCharacters,
    onValidationError,
  }) : super(
          validate:
              FieldValidators.passwordHasNoInvalidCharacters(specialCharacters),
          localizedString: LocalizedStrings
              .passwordInvalidCharactersClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PasswordsDoNotMatchFieldValidation extends FieldValidation<String> {
  PasswordsDoNotMatchFieldValidation({
    @required this.otherPasswordTextEditingController,
    onValidationError,
  }) : super(
          validate: FieldValidators.textMatches(
            otherPasswordTextEditingController,
          ),
          localizedString:
              LocalizedStrings.passwordsDoNotMatchClientSideValidationError,
          onValidationError: onValidationError,
        );

  final TextEditingController otherPasswordTextEditingController;
}

class PasswordNoWhiteSpaceFieldValidation extends FieldValidation<String> {
  PasswordNoWhiteSpaceFieldValidation({
    @required bool allowWhiteSpace,
    onValidationError,
  }) : super(
          validate:
              FieldValidators.whiteSpace(allowWhiteSpace: allowWhiteSpace),
          localizedString: LocalizedStrings.passwordValidationDoNotAllowSpaces,
          onValidationError: onValidationError,
        );
}

class PasswordMinLengthFieldValidation extends FieldValidation<String> {
  PasswordMinLengthFieldValidation({
    @required minLength,
    onValidationError,
  }) : super(
          validate: FieldValidators.minLength(minLength),
          localizedString: LocalizedStrings.passwordTooShortError(minLength),
          onValidationError: onValidationError,
        );
}

class PasswordMaxLengthFieldValidation extends FieldValidation<String> {
  PasswordMaxLengthFieldValidation({
    @required maxLength,
    onValidationError,
  }) : super(
          validate: FieldValidators.maxLength(maxLength),
          localizedString: LocalizedStrings.passwordTooLongError(maxLength),
          onValidationError: onValidationError,
        );
}

class PasswordContainsUpperCaseFieldValidation extends FieldValidation<String> {
  PasswordContainsUpperCaseFieldValidation({
    @required minUppercaseCharacters,
    onValidationError,
  }) : super(
          validate: FieldValidators.containsUpperCase(minUppercaseCharacters),
          localizedString:
              LocalizedStrings.passwordUpperCaseError(minUppercaseCharacters),
          onValidationError: onValidationError,
        );
}

class PasswordContainsLowerCaseFieldValidation extends FieldValidation<String> {
  PasswordContainsLowerCaseFieldValidation({
    @required minLowercaseCharacters,
    onValidationError,
  }) : super(
          validate: FieldValidators.containsLowerCase(minLowercaseCharacters),
          localizedString:
              LocalizedStrings.passwordLowerCaseError(minLowercaseCharacters),
          onValidationError: onValidationError,
        );
}

class PasswordContainsNumberValidation extends FieldValidation<String> {
  PasswordContainsNumberValidation({
    @required minNumericCharacters,
    onValidationError,
  }) : super(
          validate:
              FieldValidators.containsNumericCharacters(minNumericCharacters),
          localizedString:
              LocalizedStrings.passwordNumberError(minNumericCharacters),
          onValidationError: onValidationError,
        );
}

class PasswordContainsSpecialSymbolValidation extends FieldValidation<String> {
  PasswordContainsSpecialSymbolValidation({
    @required minSpecialCharacters,
    @required String specialCharacters,
    onValidationError,
  }) : super(
          validate: FieldValidators.passwordContainsSpecialCharacters(
              minSpecialCharacters, specialCharacters),
          localizedString: LocalizedStrings.passwordSpecialCharactersError(
              minSpecialCharacters, specialCharacters),
          onValidationError: onValidationError,
        );
}

class CountryCodeRequiredFieldValidation extends FieldValidation<CountryCode> {
  CountryCodeRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.countryCodeNotNullNotEmpty,
          localizedString:
              LocalizedStrings.emptyCountryCodeClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PhoneNumberRequiredFieldValidation extends FieldValidation<String> {
  PhoneNumberRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LocalizedStrings.emptyPhoneNumberClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PhoneNumberInvalidFieldValidation extends FieldValidation<String> {
  PhoneNumberInvalidFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.phoneFormat,
          localizedString:
              LocalizedStrings.invalidPhoneNumberClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class CountryFieldValidation extends FieldValidation<Country> {
  CountryFieldValidation({
    onValidationError,
    errorMessage,
  }) : super(
          validate: FieldValidators.notRequired,
          localizedString: errorMessage ?? '',
          onValidationError: onValidationError,
        );
}

class CountryRequiredFieldValidation extends FieldValidation<Country> {
  CountryRequiredFieldValidation({
    onValidationError,
    errorMessage,
  }) : super(
          validate: FieldValidators.countryNotNullNotEmpty,
          localizedString: errorMessage ??
              LocalizedStrings
                  .requiredCountryOfResidenceClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class MaximumDecimalPlacesFieldValidation extends FieldValidation<String> {
  MaximumDecimalPlacesFieldValidation({
    @required precision,
    onValidationError,
  }) : super(
          validate: FieldValidators.maximumDecimalPlaces(precision),
          localizedString:
              LocalizedStrings.maximumDecimalPlacesError(precision),
          onValidationError: onValidationError,
        );
}

class WalletAddressRequiredFieldValidation extends FieldValidation<String> {
  WalletAddressRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LocalizedStrings.transactionEmptyAddressError,
          onValidationError: onValidationError,
        );
}

class WalletAddressInvalidFieldValidation extends FieldValidation<String> {
  WalletAddressInvalidFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.emailFormat,
          localizedString: LocalizedStrings.transactionInvalidAddressError,
          onValidationError: onValidationError,
        );
}

class TransferAmountRequiredFieldValidation extends FieldValidation<String> {
  TransferAmountRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LocalizedStrings.transactionAmountRequiredError,
          onValidationError: onValidationError,
        );
}

class TransferAmountInvalidFieldValidation extends FieldValidation<String> {
  TransferAmountInvalidFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.validDouble,
          localizedString: LocalizedStrings.transactionAmountInvalidError,
          onValidationError: onValidationError,
        );
}

class InsufficientBalanceFieldValidation extends FieldValidation<String> {
  InsufficientBalanceFieldValidation({
    @required this.balance,
    onValidationError,
  }) : super(
          validate: FieldValidators.lessThanOrEqualTo(balance),
          localizedString:
              LocalizedStrings.transactionAmountGreaterThanBalanceError,
          onValidationError: onValidationError,
        );

  final Decimal balance;
}

class PaymentAmountRequiredFieldValidation extends FieldValidation<String> {
  PaymentAmountRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LocalizedStrings.paymentAmountRequiredError,
          onValidationError: onValidationError,
        );
}

class PaymentAmountInvalidFieldValidation extends FieldValidation<String> {
  PaymentAmountInvalidFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.validDouble,
          localizedString: LocalizedStrings.paymentAmountInvalidError,
          onValidationError: onValidationError,
        );
}

class AmountSmallerOrEqualToInstalment extends FieldValidation<String> {
  AmountSmallerOrEqualToInstalment({
    @required this.instalmentAmount,
    onValidationError,
  }) : super(
          validate: FieldValidators.lessThanOrEqualTo(instalmentAmount),
          localizedString:
              LocalizedStrings.propertyPaymentAmountExceedsInstalment,
          onValidationError: onValidationError,
        );

  final Decimal instalmentAmount;
}

class AmountSmallerOrEqualToBill extends FieldValidation<String> {
  AmountSmallerOrEqualToBill({
    @required this.totalBill,
    onValidationError,
  }) : super(
          validate: FieldValidators.lessThanOrEqualTo(totalBill),
          localizedString:
              LocalizedStrings.transferRequestAmountExceedsRequestedError(
                  totalBill.toString()),
          onValidationError: onValidationError,
        );

  final Decimal totalBill;
}

class AmountBiggerThanZero extends FieldValidation<String> {
  AmountBiggerThanZero({
    onValidationError,
  }) : super(
          validate: FieldValidators.biggerThanZero,
          localizedString: LocalizedStrings.transferRequestAmountIsZeroError,
          onValidationError: onValidationError,
        );
}

class CheckboxShouldBeChecked extends FieldValidation<bool> {
  CheckboxShouldBeChecked({
    localizedString,
    onValidationError,
  }) : super(
          validate: (value) => value,
          localizedString: localizedString,
          onValidationError: onValidationError,
        );
}

class LinkingCodeRequiredFieldValidation extends FieldValidation<String> {
  LinkingCodeRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LocalizedStrings
              .emptyLinkAdvancedWalletTextFieldCodeSignatureError,
          onValidationError: onValidationError,
        );
}

class PublicAddressRequiredFieldValidation extends FieldValidation<String> {
  PublicAddressRequiredFieldValidation({
    onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LocalizedStrings
              .emptyLinkAdvancedWalletTextFieldPublicAddressError,
          onValidationError: onValidationError,
        );
}
