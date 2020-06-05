import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MobileSettings extends Equatable {
  const MobileSettings({
    @required this.supportPhoneNumber,
    @required this.supportEmail,
    @required this.termsOfUseUrl,
    @required this.privacyUrl,
    @required this.tokenPrecision,
    @required this.baseCurrency,
    @required this.tokenSymbol,
    @required this.registrationMobileSettings,
    @required this.passwordStrength,
    @required this.appVersion,
    @required this.dAppMobileSettings,
    @required this.pinCode,
  });

  MobileSettings.fromJson(Map<String, dynamic> json)
      : supportPhoneNumber = json['CustomerSupportPhoneNumber'],
        supportEmail = json['CustomerSupportEmail'],
        termsOfUseUrl = json['PrivacyAndTermsUrl'],
        privacyUrl = json['PrivacyUrl'],
        tokenPrecision = json['TokenPrecision'],
        baseCurrency = json['BaseCurrencyCode'],
        tokenSymbol = json['TokenSymbol'],
        registrationMobileSettings =
            RegistrationMobileSettings.fromJson(json['Registration']),
        passwordStrength = PasswordStrength.fromJson(json['PasswordStrength']),
        appVersion = AppVersion.fromJson(json['AppVersion']),
        dAppMobileSettings = DAppMobileSettings.fromJson(json['DApp']),
        pinCode = PinCode.fromJson(json['PinCode']);

  final String supportPhoneNumber;
  final String supportEmail;
  final String termsOfUseUrl;
  final String privacyUrl;
  final int tokenPrecision;
  final String baseCurrency;
  final String tokenSymbol;
  final RegistrationMobileSettings registrationMobileSettings;
  final PasswordStrength passwordStrength;
  final AppVersion appVersion;
  final DAppMobileSettings dAppMobileSettings;
  final PinCode pinCode;

  Map<String, dynamic> toJson() => {
        'CustomerSupportPhoneNumber': supportPhoneNumber,
        'CustomerSupportEmail': supportEmail,
        'PrivacyAndTermsUrl': termsOfUseUrl,
        'PrivacyUrl': privacyUrl,
        'TokenPrecision': tokenPrecision,
        'BaseCurrencyCode': baseCurrency,
        'TokenSymbol': tokenSymbol,
        'Registration': registrationMobileSettings.toJson(),
        'PasswordStrength': passwordStrength.toJson(),
        'AppVersion': appVersion.toJson(),
        'DApp': dAppMobileSettings.toJson(),
        'PinCode': pinCode.toJson(),
      };

  @override
  List get props => [
        supportPhoneNumber,
        supportEmail,
        termsOfUseUrl,
        privacyUrl,
        tokenPrecision,
        baseCurrency,
        tokenSymbol,
        registrationMobileSettings,
        passwordStrength,
        appVersion,
        dAppMobileSettings,
        pinCode,
      ];
}

class DAppMobileSettings extends Equatable {
  DAppMobileSettings.fromJson(Map<String, dynamic> json)
      : linkWalletAppUrlTemplate = json['LinkWalletAppUrlTemplate'];

  final String linkWalletAppUrlTemplate;

  Map<String, dynamic> toJson() => {
        'LinkWalletAppUrlTemplate': linkWalletAppUrlTemplate,
      };

  @override
  List get props => [linkWalletAppUrlTemplate];
}

class RegistrationMobileSettings extends Equatable {
  const RegistrationMobileSettings(
      {@required this.verificationCodeExpirationPeriod});

  RegistrationMobileSettings.fromJson(Map<String, dynamic> json)
      : verificationCodeExpirationPeriod =
            _toDuration(json['VerificationCodeExpirationPeriod']);

  final Duration verificationCodeExpirationPeriod;

  Map<String, dynamic> toJson() => {
        'VerificationCodeExpirationPeriod':
            _fromDuration(verificationCodeExpirationPeriod)
      };

  static Duration _toDuration(String s) {
    var hours = 0;
    var minutes = 0;
    final parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    final seconds = int.parse(parts[parts.length - 1]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  static String _fromDuration(Duration duration) =>
      duration.toString().split('.').first.padLeft(8, '0');

  @override
  List get props => [verificationCodeExpirationPeriod];
}

class PasswordStrength extends Equatable {
  const PasswordStrength({
    @required this.minLength,
    @required this.maxLength,
    @required this.minUpperCase,
    @required this.minLowerCase,
    @required this.minNumbers,
    @required this.minSpecialSymbols,
    @required this.specialCharacters,
    @required this.canUseSpaces,
  });

  PasswordStrength.fromJson(Map<String, dynamic> json)
      : minLength = json['MinimumLength'],
        maxLength = json['MaximumLength'],
        minUpperCase = json['MinUpperCase'],
        minLowerCase = json['MinLowerCase'],
        minNumbers = json['MinNumbers'],
        minSpecialSymbols = json['MinSpecialSymbols'],
        specialCharacters = json['SpecialCharacters'],
        canUseSpaces = json['Spaces'];

  final int minLength;
  final int maxLength;
  final int minUpperCase;
  final int minLowerCase;
  final int minNumbers;
  final int minSpecialSymbols;
  final String specialCharacters;
  final bool canUseSpaces;

  Map<String, dynamic> toJson() => {
        'MinimumLength': minLength,
        'MaximumLength': maxLength,
        'MinUpperCase': minUpperCase,
        'MinLowerCase': minLowerCase,
        'MinNumbers': minNumbers,
        'MinSpecialSymbols': minSpecialSymbols,
        'SpecialCharacters': specialCharacters,
        'Spaces': canUseSpaces,
      };

  @override
  List get props => [
        minLength,
        maxLength,
        minUpperCase,
        minLowerCase,
        minNumbers,
        minSpecialSymbols,
        specialCharacters,
        canUseSpaces,
      ];
}

class PinCode extends Equatable {
  const PinCode({
    @required this.pinCodeLength,
    @required this.pinCodeWarningAttemptCount,
    @required this.pinCodeMaximumAttemptCount,
  });

  PinCode.fromJson(Map<String, dynamic> json)
      : pinCodeLength = json['PinCodeLength'],
        pinCodeWarningAttemptCount = json['PinCodeWarningAttemptCount'],
        pinCodeMaximumAttemptCount = json['PinCodeMaximumAttemptCount'];

  final int pinCodeLength;
  final int pinCodeWarningAttemptCount;
  final int pinCodeMaximumAttemptCount;

  Map<String, dynamic> toJson() => {
        'PinCodeLength': pinCodeLength,
        'PinCodeWarningAttemptCount': pinCodeWarningAttemptCount,
        'PinCodeMaximumAttemptCount': pinCodeMaximumAttemptCount,
      };

  @override
  List get props => [
        pinCodeLength,
        pinCodeWarningAttemptCount,
        pinCodeMaximumAttemptCount,
      ];
}

class AppVersion extends Equatable {
  const AppVersion({
    @required this.latestAppVersion,
    @required this.latestMandatoryUpgradeAppVersion,
  });

  AppVersion.fromJson(Map<String, dynamic> json)
      : latestAppVersion = json['LatestAppVersion'],
        latestMandatoryUpgradeAppVersion =
            json['LatestMandatoryUpgradeAppVersion'];

  final String latestAppVersion;
  final String latestMandatoryUpgradeAppVersion;

  Map<String, dynamic> toJson() => {
        'LatestAppVersion': latestAppVersion,
        'LatestMandatoryUpgradeAppVersion': latestMandatoryUpgradeAppVersion,
      };

  @override
  List get props => [
        latestAppVersion,
        latestMandatoryUpgradeAppVersion,
      ];
}
