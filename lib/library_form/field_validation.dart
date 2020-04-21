import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
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
  final LocalizedStringBuilder localizedString;

  ValueNotifier<bool> isValid = ValueNotifier(true);

  void dispose() => isValid.dispose();
}

class FirstNameRequiredFieldValidation extends FieldValidation<String> {
  FirstNameRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LazyLocalizedStrings.emptyFirstNameClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class LastNameRequiredFieldValidation extends FieldValidation<String> {
  LastNameRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LazyLocalizedStrings.emptyLastNameClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class FullNameRequiredFieldValidation extends FieldValidation<String> {
  FullNameRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LazyLocalizedStrings.emptyFullNameClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class MinStringLengthFieldValidation extends FieldValidation<String> {
  MinStringLengthFieldValidation({
    @required int minLength,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.minLength(minLength),
          localizedString:
              LazyLocalizedStrings.minLengthClientSideValidationError(
                  minLength),
          onValidationError: onValidationError,
        );
}

class MinPhoneNumberStringLengthFieldValidation
    extends FieldValidation<String> {
  MinPhoneNumberStringLengthFieldValidation({
    @required ValueNotifier<CountryCode> countryCodeValueNotifier,
    minLength = FieldConstants.minPhoneNumberLength,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.minPhoneNumberLength(
            minLength,
            countryCodeValueNotifier,
          ),
          localizedString: LazyLocalizedStrings
              .minPhoneNumberLengthClientSideValidationError(minLength),
          onValidationError: onValidationError,
        );
}

class MaxPhoneNumberStringLengthFieldValidation
    extends FieldValidation<String> {
  MaxPhoneNumberStringLengthFieldValidation({
    @required ValueNotifier<CountryCode> countryCodeValueNotifier,
    maxLength = FieldConstants.maxPhoneNumberLength,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.maxPhoneNumberLength(
            maxLength,
            countryCodeValueNotifier,
          ),
          localizedString: LazyLocalizedStrings
              .maxPhoneNumberLengthClientSideValidationError(maxLength),
          onValidationError: onValidationError,
        );
}

class NameInvalidFieldValidation extends FieldValidation<String> {
  NameInvalidFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.nameFormat,
          localizedString:
              LazyLocalizedStrings.invalidCharactersClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class EmailRequiredFieldValidation extends FieldValidation<String> {
  EmailRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LazyLocalizedStrings.emptyEmailClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class EmailInvalidFieldValidation extends FieldValidation<String> {
  EmailInvalidFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.emailFormat,
          localizedString:
              LazyLocalizedStrings.invalidEmailClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PasswordRequiredFieldValidation extends FieldValidation<String> {
  PasswordRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LazyLocalizedStrings.emptyPasswordClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PasswordOnlyContainsValidCharactersValidation
    extends FieldValidation<String> {
  PasswordOnlyContainsValidCharactersValidation({
    @required String specialCharacters,
    VoidCallback onValidationError,
  }) : super(
          validate:
              FieldValidators.passwordHasNoInvalidCharacters(specialCharacters),
          localizedString: LazyLocalizedStrings
              .passwordInvalidCharactersClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PasswordsDoNotMatchFieldValidation extends FieldValidation<String> {
  PasswordsDoNotMatchFieldValidation({
    @required this.otherPasswordTextEditingController,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.textMatches(
            otherPasswordTextEditingController,
          ),
          localizedString:
              LazyLocalizedStrings.passwordsDoNotMatchClientSideValidationError,
          onValidationError: onValidationError,
        );

  final TextEditingController otherPasswordTextEditingController;
}

class PasswordNoWhiteSpaceFieldValidation extends FieldValidation<String> {
  PasswordNoWhiteSpaceFieldValidation({
    @required bool allowWhiteSpace,
    VoidCallback onValidationError,
  }) : super(
          validate:
              FieldValidators.whiteSpace(allowWhiteSpace: allowWhiteSpace),
          localizedString:
              LazyLocalizedStrings.passwordValidationDoNotAllowSpaces,
          onValidationError: onValidationError,
        );
}

class PasswordMinLengthFieldValidation extends FieldValidation<String> {
  PasswordMinLengthFieldValidation({
    @required int minLength,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.minLength(minLength),
          localizedString:
              LazyLocalizedStrings.passwordTooShortError(minLength),
          onValidationError: onValidationError,
        );
}

class PasswordMaxLengthFieldValidation extends FieldValidation<String> {
  PasswordMaxLengthFieldValidation({
    @required int maxLength,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.maxLength(maxLength),
          localizedString: LazyLocalizedStrings.passwordTooLongError(maxLength),
          onValidationError: onValidationError,
        );
}

class PasswordContainsUpperCaseFieldValidation extends FieldValidation<String> {
  PasswordContainsUpperCaseFieldValidation({
    @required int minUppercaseCharacters,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.containsUpperCase(minUppercaseCharacters),
          localizedString: LazyLocalizedStrings.passwordUpperCaseError(
              minUppercaseCharacters),
          onValidationError: onValidationError,
        );
}

class PasswordContainsLowerCaseFieldValidation extends FieldValidation<String> {
  PasswordContainsLowerCaseFieldValidation({
    @required int minLowercaseCharacters,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.containsLowerCase(minLowercaseCharacters),
          localizedString: LazyLocalizedStrings.passwordLowerCaseError(
              minLowercaseCharacters),
          onValidationError: onValidationError,
        );
}

class PasswordContainsNumberValidation extends FieldValidation<String> {
  PasswordContainsNumberValidation({
    @required int minNumericCharacters,
    VoidCallback onValidationError,
  }) : super(
          validate:
              FieldValidators.containsNumericCharacters(minNumericCharacters),
          localizedString:
              LazyLocalizedStrings.passwordNumberError(minNumericCharacters),
          onValidationError: onValidationError,
        );
}

class PasswordContainsSpecialSymbolValidation extends FieldValidation<String> {
  PasswordContainsSpecialSymbolValidation({
    @required int minSpecialCharacters,
    @required String specialCharacters,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.passwordContainsSpecialCharacters(
              minSpecialCharacters, specialCharacters),
          localizedString: LazyLocalizedStrings.passwordSpecialCharactersError(
              minSpecialCharacters, specialCharacters),
          onValidationError: onValidationError,
        );
}

class CountryCodeRequiredFieldValidation extends FieldValidation<CountryCode> {
  CountryCodeRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.countryCodeNotNullNotEmpty,
          localizedString:
              LazyLocalizedStrings.emptyCountryCodeClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PhoneNumberRequiredFieldValidation extends FieldValidation<String> {
  PhoneNumberRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString:
              LazyLocalizedStrings.emptyPhoneNumberClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class PhoneNumberInvalidFieldValidation extends FieldValidation<String> {
  PhoneNumberInvalidFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.phoneFormat,
          localizedString:
              LazyLocalizedStrings.invalidPhoneNumberClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class CountryFieldValidation extends FieldValidation<Country> {
  CountryFieldValidation({
    VoidCallback onValidationError,
    LocalizedStringBuilder errorMessage,
  }) : super(
          validate: FieldValidators.notRequired,
          localizedString: errorMessage,
          onValidationError: onValidationError,
        );
}

class CountryRequiredFieldValidation extends FieldValidation<Country> {
  CountryRequiredFieldValidation({VoidCallback onValidationError})
      : super(
          validate: FieldValidators.countryNotNullNotEmpty,
          localizedString: LazyLocalizedStrings
              .requiredCountryOfResidenceClientSideValidationError,
          onValidationError: onValidationError,
        );
}

class MaximumDecimalPlacesFieldValidation extends FieldValidation<String> {
  MaximumDecimalPlacesFieldValidation({
    @required int precision,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.maximumDecimalPlaces(precision),
          localizedString:
              LazyLocalizedStrings.maximumDecimalPlacesError(precision),
          onValidationError: onValidationError,
        );
}

class WalletAddressRequiredFieldValidation extends FieldValidation<String> {
  WalletAddressRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LazyLocalizedStrings.transactionEmptyAddressError,
          onValidationError: onValidationError,
        );
}

class WalletAddressInvalidFieldValidation extends FieldValidation<String> {
  WalletAddressInvalidFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.emailFormat,
          localizedString: LazyLocalizedStrings.transactionInvalidAddressError,
          onValidationError: onValidationError,
        );
}

class TransferAmountRequiredFieldValidation extends FieldValidation<String> {
  TransferAmountRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LazyLocalizedStrings.transactionAmountRequiredError,
          onValidationError: onValidationError,
        );
}

class TransferAmountInvalidFieldValidation extends FieldValidation<String> {
  TransferAmountInvalidFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.validDouble,
          localizedString: LazyLocalizedStrings.transactionAmountInvalidError,
          onValidationError: onValidationError,
        );
}

class InsufficientBalanceFieldValidation extends FieldValidation<String> {
  InsufficientBalanceFieldValidation({
    @required this.balance,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.lessThanOrEqualTo(balance),
          localizedString:
              LazyLocalizedStrings.transactionAmountGreaterThanBalanceError,
          onValidationError: onValidationError,
        );

  final Decimal balance;
}

class PaymentAmountRequiredFieldValidation extends FieldValidation<String> {
  PaymentAmountRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LazyLocalizedStrings.paymentAmountRequiredError,
          onValidationError: onValidationError,
        );
}

class PaymentAmountInvalidFieldValidation extends FieldValidation<String> {
  PaymentAmountInvalidFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.validDouble,
          localizedString: LazyLocalizedStrings.paymentAmountInvalidError,
          onValidationError: onValidationError,
        );
}

class AmountSmallerOrEqualToInstalment extends FieldValidation<String> {
  AmountSmallerOrEqualToInstalment({
    @required this.instalmentAmount,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.lessThanOrEqualTo(instalmentAmount),
          localizedString:
              LazyLocalizedStrings.propertyPaymentAmountExceedsInstalment,
          onValidationError: onValidationError,
        );

  final Decimal instalmentAmount;
}

class AmountSmallerOrEqualToBill extends FieldValidation<String> {
  AmountSmallerOrEqualToBill({
    @required this.totalBill,
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.lessThanOrEqualTo(totalBill),
          localizedString:
              LazyLocalizedStrings.transferRequestAmountExceedsRequestedError(
                  totalBill.toString()),
          onValidationError: onValidationError,
        );

  final Decimal totalBill;
}

class AmountBiggerThanZero extends FieldValidation<String> {
  AmountBiggerThanZero({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.biggerThanZero,
          localizedString:
              LazyLocalizedStrings.transferRequestAmountIsZeroError,
          onValidationError: onValidationError,
        );
}

class CheckboxShouldBeChecked extends FieldValidation<bool> {
  CheckboxShouldBeChecked({
    LocalizedStringBuilder localizedString,
    VoidCallback onValidationError,
  }) : super(
          validate: (value) => value,
          localizedString: localizedString,
          onValidationError: onValidationError,
        );
}

class LinkingCodeRequiredFieldValidation extends FieldValidation<String> {
  LinkingCodeRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LazyLocalizedStrings
              .emptyLinkAdvancedWalletTextFieldCodeSignatureError,
          onValidationError: onValidationError,
        );
}

class PublicAddressRequiredFieldValidation extends FieldValidation<String> {
  PublicAddressRequiredFieldValidation({
    VoidCallback onValidationError,
  }) : super(
          validate: FieldValidators.requiredText,
          localizedString: LazyLocalizedStrings
              .emptyLinkAdvancedWalletTextFieldPublicAddressError,
          onValidationError: onValidationError,
        );
}
