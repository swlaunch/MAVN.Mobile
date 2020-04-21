import 'package:flutter/widgets.dart';

import 'localized_strings.dart';

typedef String LocalizedStringSelector(LocalizedStrings localizedStrings);

class LocalizedStringBuilder {
  LocalizedStringBuilder(this._stringSelector, this._stringName);

  LocalizedStringBuilder.custom(String message)
      : _stringSelector = ((_) => message),
        _stringName = message;

  LocalizedStringBuilder.empty()
      : _stringSelector = ((_) => null),
        _stringName = 'empty';

  final LocalizedStringSelector _stringSelector;
  final String _stringName;

  String localize(BuildContext context) => from(LocalizedStrings.of(context));

  String from(LocalizedStrings localizedStrings) =>
      _stringSelector(localizedStrings);

  @override
  bool operator ==(other) =>
      other is LocalizedStringBuilder && other._stringName == _stringName;

  @override
  int get hashCode => _stringName.hashCode;
}

LocalizedStringBuilder _builder(
        LocalizedStringSelector selector, String stringName) =>
    LocalizedStringBuilder(selector, stringName);

class LazyLocalizedStrings {
  //region Common API errors

  static LocalizedStringBuilder get networkErrorTitle =>
      _builder((_) => _.networkErrorTitle, 'networkErrorTitle');

  static LocalizedStringBuilder get networkError =>
      _builder((_) => _.networkError, 'networkError');

  static LocalizedStringBuilder genericError(String serviceNumber) => _builder(
      (_) => _.genericError(serviceNumber), 'genericError($serviceNumber)');

  static LocalizedStringBuilder get defaultGenericError =>
      _builder((_) => _.defaultGenericError, 'defaultGenericError');

  static LocalizedStringBuilder get genericErrorShort =>
      _builder((_) => _.genericErrorShort, 'genericErrorShort');

  static LocalizedStringBuilder get somethingIsNotRightError =>
      _builder((_) => _.somethingIsNotRightError, 'somethingIsNotRightError');

  static LocalizedStringBuilder get couldNotLoadBalanceError =>
      _builder((_) => _.couldNotLoadBalanceError, 'couldNotLoadBalanceError');

// endregion Common API errors

// region Customer API errors

  static LocalizedStringBuilder get referralLeadAlreadyExistError => _builder(
      (_) => _.referralLeadAlreadyExistError, 'referralLeadAlreadyExistError');

  static LocalizedStringBuilder get referralLeadAlreadyConfirmedError =>
      _builder((_) => _.referralLeadAlreadyConfirmedError,
          'referralLeadAlreadyConfirmedError');

  static LocalizedStringBuilder get canNotReferYourselfError =>
      _builder((_) => _.canNotReferYourselfError, 'canNotReferYourselfError');

  static LocalizedStringBuilder get cannotGetOffersError =>
      _builder((_) => _.cannotGetOffersError, 'cannotGetOffersError');

  static LocalizedStringBuilder get noVouchersInStockError =>
      _builder((_) => _.noVouchersInStockError, 'noVouchersInStockError');

// endregion Customer API errors
//region Common Form Elements

  static LocalizedStringBuilder feeLabel(String fee) =>
      _builder((_) => _.feeLabel(fee), 'feeLabel($fee)');

  static LocalizedStringBuilder transferTokenAmountLabel(String token) =>
      _builder((_) => _.transferTokenAmountLabel(token),
          'transferTokenAmountLabel($token)');

  static LocalizedStringBuilder get emailRequiredLabel =>
      _builder((_) => _.emailRequiredLabel, 'emailRequiredLabel');

  static LocalizedStringBuilder get emailAddressHint =>
      _builder((_) => _.emailAddressHint, 'emailAddressHint');

  static LocalizedStringBuilder get enterAmountHint =>
      _builder((_) => _.enterAmountHint, 'enterAmountHint');

  static LocalizedStringBuilder get firstNameRequiredLabel =>
      _builder((_) => _.firstNameRequiredLabel, 'firstNameRequiredLabel');

  static LocalizedStringBuilder get firstNameNotRequiredLabel =>
      _builder((_) => _.firstNameNotRequiredLabel, 'firstNameNotRequiredLabel');

  static LocalizedStringBuilder get firstNameHint =>
      _builder((_) => _.firstNameHint, 'firstNameHint');

  static LocalizedStringBuilder get lastNameRequiredLabel =>
      _builder((_) => _.lastNameRequiredLabel, 'lastNameRequiredLabel');

  static LocalizedStringBuilder get lastNameNotRequiredLabel =>
      _builder((_) => _.lastNameNotRequiredLabel, 'lastNameNotRequiredLabel');

  static LocalizedStringBuilder get lastNameHint =>
      _builder((_) => _.lastNameHint, 'lastNameHint');

  static LocalizedStringBuilder get passwordRequiredLabel =>
      _builder((_) => _.passwordRequiredLabel, 'passwordRequiredLabel');

  static LocalizedStringBuilder get passwordHint =>
      _builder((_) => _.passwordHint, 'passwordHint');

  static LocalizedStringBuilder get phoneNumberLabel =>
      _builder((_) => _.phoneNumberLabel, 'phoneNumberLabel');

  static LocalizedStringBuilder get phoneNumberRequiredLabel =>
      _builder((_) => _.phoneNumberRequiredLabel, 'phoneNumberRequiredLabel');

  static LocalizedStringBuilder get phoneNumberHint =>
      _builder((_) => _.phoneNumberHint, 'phoneNumberHint');

  static LocalizedStringBuilder get noteLabel =>
      _builder((_) => _.noteLabel, 'noteLabel');

  static LocalizedStringBuilder get noteHint =>
      _builder((_) => _.noteHint, 'noteHint');

  static LocalizedStringBuilder get nationalityLabel =>
      _builder((_) => _.nationalityLabel, 'nationalityLabel');

  static LocalizedStringBuilder get nationalityOptionalLabel =>
      _builder((_) => _.nationalityOptionalLabel, 'nationalityOptionalLabel');

  static LocalizedStringBuilder get nationalityHint =>
      _builder((_) => _.nationalityHint, 'nationalityHint');

//endregion Common Form Elements

// region Common client side validation errors

  static LocalizedStringBuilder get emptyEmailClientSideValidationError =>
      _builder((_) => _.emptyEmailClientSideValidationError,
          'emptyEmailClientSideValidationError');

  static LocalizedStringBuilder get invalidEmailClientSideValidationError =>
      _builder((_) => _.invalidEmailClientSideValidationError,
          'invalidEmailClientSideValidationError');

  static LocalizedStringBuilder get emptyNameClientSideValidationError =>
      _builder((_) => _.emptyNameClientSideValidationError,
          'emptyNameClientSideValidationError');

  static LocalizedStringBuilder get emptyFirstNameClientSideValidationError =>
      _builder((_) => _.emptyFirstNameClientSideValidationError,
          'emptyFirstNameClientSideValidationError');

  static LocalizedStringBuilder get invalidFirstNameClientSideValidationError =>
      _builder((_) => _.invalidFirstNameClientSideValidationError,
          'invalidFirstNameClientSideValidationError');

  static LocalizedStringBuilder get emptyLastNameClientSideValidationError =>
      _builder((_) => _.emptyLastNameClientSideValidationError,
          'emptyLastNameClientSideValidationError');

  static LocalizedStringBuilder get emptyFullNameClientSideValidationError =>
      _builder((_) => _.emptyFullNameClientSideValidationError,
          'emptyFullNameClientSideValidationError');

  static LocalizedStringBuilder get invalidLastNameClientSideValidationError =>
      _builder((_) => _.invalidLastNameClientSideValidationError,
          'invalidLastNameClientSideValidationError');

  static LocalizedStringBuilder get emptyCountryCodeClientSideValidationError =>
      _builder((_) => _.emptyCountryCodeClientSideValidationError,
          'emptyCountryCodeClientSideValidationError');

  static LocalizedStringBuilder get emptyPhoneNumberClientSideValidationError =>
      _builder((_) => _.emptyPhoneNumberClientSideValidationError,
          'emptyPhoneNumberClientSideValidationError');

  static LocalizedStringBuilder
      get invalidPhoneNumberClientSideValidationError => _builder(
          (_) => _.invalidPhoneNumberClientSideValidationError,
          'invalidPhoneNumberClientSideValidationError');

  static LocalizedStringBuilder minLengthClientSideValidationError(
          int minLength) =>
      _builder((_) => _.minLengthClientSideValidationError(minLength),
          'minLengthClientSideValidationError($minLength)');

  static LocalizedStringBuilder minPhoneNumberLengthClientSideValidationError(
          int minLength) =>
      _builder(
          (_) => _.minPhoneNumberLengthClientSideValidationError(minLength),
          'networkErrorTitle($minLength)');

  static LocalizedStringBuilder maxPhoneNumberLengthClientSideValidationError(
          int maxLength) =>
      _builder(
          (_) => _.maxPhoneNumberLengthClientSideValidationError(maxLength),
          'maxPhoneNumberLengthClientSideValidationError($maxLength)');

  static LocalizedStringBuilder
      get invalidCharactersClientSideValidationError => _builder(
          (_) => _.invalidCharactersClientSideValidationError,
          'invalidCharactersClientSideValidationError');

  static LocalizedStringBuilder get emptyPasswordClientSideValidationError =>
      _builder((_) => _.emptyPasswordClientSideValidationError,
          'emptyPasswordClientSideValidationError');

  static LocalizedStringBuilder
      get passwordsDoNotMatchClientSideValidationError => _builder(
          (_) => _.passwordsDoNotMatchClientSideValidationError,
          'passwordsDoNotMatchClientSideValidationError');

  static LocalizedStringBuilder
      get passwordInvalidCharactersClientSideValidationError => _builder(
          (_) => _.passwordInvalidCharactersClientSideValidationError,
          'passwordInvalidCharactersClientSideValidationError');

  static LocalizedStringBuilder passwordTooShortError(int count) => _builder(
      (_) => _.passwordTooShortError(count), 'passwordTooShortError($count)');

  static LocalizedStringBuilder passwordTooLongError(int count) => _builder(
      (_) => _.passwordTooLongError(count), 'passwordTooLongError($count)');

  static LocalizedStringBuilder passwordUpperCaseError(int count) => _builder(
      (_) => _.passwordUpperCaseError(count), 'passwordUpperCaseError($count)');

  static LocalizedStringBuilder passwordLowerCaseError(int count) => _builder(
      (_) => _.passwordLowerCaseError(count), 'passwordLowerCaseError($count)');

  static LocalizedStringBuilder passwordNumberError(int count) => _builder(
      (_) => _.passwordNumberError(count), 'passwordNumberError($count)');

  static LocalizedStringBuilder passwordSpecialCharactersError(
          int count, String specialCharacters) =>
      _builder(
          (_) => _.passwordSpecialCharactersError(count, specialCharacters),
          'passwordSpecialCharactersError($count, $specialCharacters)');

  static LocalizedStringBuilder
      get requiredCountryOfResidenceClientSideValidationError => _builder(
          (_) => _.requiredCountryOfResidenceClientSideValidationError,
          'requiredCountryOfResidenceClientSideValidationError');

  static LocalizedStringBuilder get requiredPhotoIdClientSideValidationError =>
      _builder((_) => _.requiredPhotoIdClientSideValidationError,
          'requiredPhotoIdClientSideValidationError');

  static LocalizedStringBuilder
      get requiredPhotoIdFrontSideClientSideValidationError => _builder(
          (_) => _.requiredPhotoIdFrontSideClientSideValidationError,
          'requiredPhotoIdFrontSideClientSideValidationError');

  static LocalizedStringBuilder
      get requiredPhotoIdBackSideClientSideValidationError => _builder(
          (_) => _.requiredPhotoIdBackSideClientSideValidationError,
          'requiredPhotoIdBackSideClientSideValidationError');

  static LocalizedStringBuilder maximumDecimalPlacesError(int precision) =>
      _builder((_) => _.maximumDecimalPlacesError(precision),
          'maximumDecimalPlacesError($precision)');

// endregion Common client side validation errors

//region Password Validation

  static LocalizedStringBuilder get passwordInvalidError =>
      _builder((_) => _.passwordInvalidError, 'passwordInvalidError');

  static LocalizedStringBuilder passwordValidationMinCharacters(int count) =>
      _builder((_) => _.passwordValidationMinCharacters(count),
          'passwordValidationMinCharacters($count)');

  static LocalizedStringBuilder passwordValidationMinUpperCaseCharacters(
          int count) =>
      _builder((_) => _.passwordValidationMinUpperCaseCharacters(count),
          'passwordValidationMinUpperCaseCharacters($count)');

  static LocalizedStringBuilder passwordValidationMinLowerCaseCharacters(
          int count) =>
      _builder((_) => _.passwordValidationMinLowerCaseCharacters(count),
          'passwordValidationMinLowerCaseCharacters($count)');

  static LocalizedStringBuilder passwordValidationMinNumericCharacters(
          int count) =>
      _builder((_) => _.passwordValidationMinNumericCharacters(count),
          'passwordValidationMinNumericCharacters($count)');

  static LocalizedStringBuilder passwordValidationMinSpecialCharacters(
          int count, String specialCharacters) =>
      _builder(
          (_) => _.passwordValidationMinSpecialCharacters(
              count, specialCharacters),
          'passwordValidationMinSpecialCharacters($count, $specialCharacters)');

  static LocalizedStringBuilder get passwordValidationAllowSpaces => _builder(
      (_) => _.passwordValidationAllowSpaces, 'passwordValidationAllowSpaces');

  static LocalizedStringBuilder get passwordValidationDoNotAllowSpaces =>
      _builder((_) => _.passwordValidationDoNotAllowSpaces,
          'passwordValidationDoNotAllowSpaces');

//endregion Password Validation

// region Common Camera View
  static LocalizedStringBuilder get cameraViewGuide =>
      _builder((_) => _.cameraViewGuide, 'cameraViewGuide');

  static LocalizedStringBuilder get cameraPreviewTitle =>
      _builder((_) => _.cameraPreviewTitle, 'cameraPreviewTitle');

  static LocalizedStringBuilder get cameraPreviewRetakeButton =>
      _builder((_) => _.cameraPreviewRetakeButton, 'cameraPreviewRetakeButton');

// endregion Common Camera View

//region Common button labels
  static LocalizedStringBuilder get submitButton =>
      _builder((_) => _.submitButton, 'submitButton');

  static LocalizedStringBuilder get nextPageButton =>
      _builder((_) => _.nextPageButton, 'nextPageButton');

  static LocalizedStringBuilder get continueButton =>
      _builder((_) => _.continueButton, 'continueButton');

  static LocalizedStringBuilder get retryButton =>
      _builder((_) => _.retryButton, 'retryButton');

  static LocalizedStringBuilder get backToWalletButton =>
      _builder((_) => _.backToWalletButton, 'backToWalletButton');

  static LocalizedStringBuilder backToTokenWalletButton(String token) =>
      _builder((_) => _.backToTokenWalletButton(token),
          'backToTokenWalletButton($token)');

  static LocalizedStringBuilder sendTokensButton(String token) =>
      _builder((_) => _.sendTokensButton(token), 'sendTokensButton($token)');

  static LocalizedStringBuilder get contactUsButton =>
      _builder((_) => _.contactUsButton, 'contactUsButton');

  static LocalizedStringBuilder get getStartedButton =>
      _builder((_) => _.getStartedButton, 'getStartedButton');

  static LocalizedStringBuilder get transferTokensButton =>
      _builder((_) => _.transferTokensButton, 'transferTokensButton');

//endregion Common button labels

  //region Common Form elements

  static LocalizedStringBuilder stepOf(String step, String totalSteps) =>
      _builder((_) => _.stepOf(step, totalSteps), 'stepOf($step, $totalSteps)');

  //endregion Common Form elements

//region Onboarding Page
  static LocalizedStringBuilder onboardingPage1Title(String appName) =>
      _builder((_) => _.onboardingPage1Title(appName),
          'onboardingPage1Title($appName)');

  static LocalizedStringBuilder onboardingPage2Title(String token) => _builder(
      (_) => _.onboardingPage2Title(token), 'onboardingPage2Title($token)');

  static LocalizedStringBuilder onboardingPage2Details(
          String token, String company) =>
      _builder((_) => _.onboardingPage2Details(token, company),
          'onboardingPage2Details($token, $company)');

  static LocalizedStringBuilder onboardingPage3Title(String token) => _builder(
      (_) => _.onboardingPage3Title(token), 'onboardingPage3Title($token)');

  static LocalizedStringBuilder onboardingPage3Details(
          String token, String company) =>
      _builder((_) => _.onboardingPage3Details(token, company),
          'onboardingPage3Details($token, $company)');

  static LocalizedStringBuilder get onboardingSkipButton =>
      _builder((_) => _.onboardingSkipButton, 'onboardingSkipButton');

//endregion Onboarding Page

//region Welcome Page
  static LocalizedStringBuilder welcomePageHeader(String appName) =>
      _builder((_) => _.welcomePageHeader(appName), 'welcomePageHeader');

  static LocalizedStringBuilder welcomePageSubHeader(String token) => _builder(
      (_) => _.welcomePageSubHeader(token), 'welcomePageSubHeader($token)');

  static LocalizedStringBuilder get welcomeSignInButtonText =>
      _builder((_) => _.welcomeSignInButtonText, 'welcomeSignInButtonText');

  static LocalizedStringBuilder get welcomeCreateAccountButtonText => _builder(
      (_) => _.welcomeCreateAccountButtonText,
      'welcomeCreateAccountButtonText');

  static LocalizedStringBuilder get socialOrContinueWith =>
      _builder((_) => _.socialOrContinueWith, 'socialOrContinueWith');

//endregion

// region Login Page

  static LocalizedStringBuilder get loginPageHeader =>
      _builder((_) => _.loginPageHeader, 'loginPageHeader');

  static LocalizedStringBuilder get loginPageEmailLabel =>
      _builder((_) => _.loginPageEmailLabel, 'loginPageEmailLabel');

  static LocalizedStringBuilder get loginPagePasswordLabel =>
      _builder((_) => _.loginPagePasswordLabel, 'loginPagePasswordLabel');

  static LocalizedStringBuilder get loginPagePasswordHint =>
      _builder((_) => _.loginPagePasswordHint, 'loginPagePasswordHint');

  static LocalizedStringBuilder get loginPageLoginSubmitButton => _builder(
      (_) => _.loginPageLoginSubmitButton, 'loginPageLoginSubmitButton');

  static LocalizedStringBuilder get loginPageForgottenPasswordButton =>
      _builder((_) => _.loginPageForgottenPasswordButton,
          'loginPageForgottenPasswordButton');

  static LocalizedStringBuilder get loginPageInvalidCredentialsError =>
      _builder((_) => _.loginPageInvalidCredentialsError,
          'loginPageInvalidCredentialsError');

  static LocalizedStringBuilder get loginPageUnauthorizedRedirectionMessage =>
      _builder((_) => _.loginPageUnauthorizedRedirectionMessage,
          'loginPageUnauthorizedRedirectionMessage');

  static LocalizedStringBuilder loginPageLoginAttemptWarningMessage(
          int attemptNumber) =>
      _builder((_) => _.loginPageLoginAttemptWarningMessage(attemptNumber),
          'loginPageLoginAttemptWarningMessage($attemptNumber)');

  static LocalizedStringBuilder loginPageTooManyRequestMessage(
          int numberOfMinutes) =>
      _builder((_) => _.loginPageTooManyRequestMessage(numberOfMinutes),
          'loginPageTooManyRequestMessage($numberOfMinutes)');

// endregion Login Page

// region Register Page
  static LocalizedStringBuilder get personalDetailsHeader =>
      _builder((_) => _.personalDetailsHeader, 'personalDetailsHeader');

  static LocalizedStringBuilder get createAPasswordHeader =>
      _builder((_) => _.createAPasswordHeader, 'createAPasswordHeader');

  static LocalizedStringBuilder get phoneNumberHeader =>
      _builder((_) => _.phoneNumberHeader, 'phoneNumberHeader');

  static LocalizedStringBuilder get addPhoneAndRefCodeHeader =>
      _builder((_) => _.addPhoneAndRefCodeHeader, 'addPhoneAndRefCodeHeader');

  static LocalizedStringBuilder get registerPageHeader =>
      _builder((_) => _.registerPageHeader, 'registerPageHeader');

  static LocalizedStringBuilder get registerPageRegisterSubmitButton =>
      _builder((_) => _.registerPageRegisterSubmitButton,
          'registerPageRegisterSubmitButton');

  static LocalizedStringBuilder get registerPageBackendInvalidEmailError =>
      _builder((_) => _.registerPageBackendInvalidEmailError,
          'registerPageBackendInvalidEmailError');

  static LocalizedStringBuilder get registerPageBackendInvalidPasswordError =>
      _builder((_) => _.registerPageBackendInvalidPasswordError,
          'registerPageBackendInvalidPasswordError');

  static LocalizedStringBuilder get registerPageLoginAlreadyInUseError =>
      _builder((_) => _.registerPageLoginAlreadyInUseError,
          'registerPageLoginAlreadyInUseError');

  static LocalizedStringBuilder get registerPageAgreeTermsOfUse => _builder(
      (_) => _.registerPageAgreeTermsOfUse, 'registerPageAgreeTermsOfUse');

  static LocalizedStringBuilder get registerPageAgreeTermsOfUseError =>
      _builder((_) => _.registerPageAgreeTermsOfUseError,
          'registerPageAgreeTermsOfUseError');

// endregion Register Page

// region Set phone number page
  static LocalizedStringBuilder get setPhoneNumberPageTitle =>
      _builder((_) => _.setPhoneNumberPageTitle, 'setPhoneNumberPageTitle');

  static LocalizedStringBuilder get setPhoneNumberVerifyButton => _builder(
      (_) => _.setPhoneNumberVerifyButton, 'setPhoneNumberVerifyButton');

// endregion Set phone number page

//region Phone Number Verification Page

  static LocalizedStringBuilder get phoneNumberVerificationPageTitle =>
      _builder((_) => _.phoneNumberVerificationPageTitle,
          'phoneNumberVerificationPageTitle');

  static LocalizedStringBuilder phoneNumberVerificationDetails(
          String phoneNumber) =>
      _builder((_) => _.phoneNumberVerificationDetails(phoneNumber),
          'phoneNumberVerificationDetails($phoneNumber)');

  static LocalizedStringBuilder get phoneNumberVerificationCodeResent =>
      _builder((_) => _.phoneNumberVerificationCodeResent,
          'phoneNumberVerificationCodeResent');

  static LocalizedStringBuilder get phoneNumberVerificationRequestNewCode =>
      _builder((_) => _.phoneNumberVerificationRequestNewCode,
          'phoneNumberVerificationRequestNewCode');

  static LocalizedStringBuilder phoneNumberVerificationResendCodeTimer(
          String timeLeft) =>
      _builder((_) => _.phoneNumberVerificationResendCodeTimer(timeLeft),
          'phoneNumberVerificationResendCodeTimer($timeLeft)');

  static LocalizedStringBuilder get phoneNumberVerificationCodeNotSentError =>
      _builder((_) => _.phoneNumberVerificationCodeNotSentError,
          'phoneNumberVerificationCodeNotSentError');

  static LocalizedStringBuilder get phoneNumberVerificationExpiredCodeError =>
      _builder((_) => _.phoneNumberVerificationExpiredCodeError,
          'phoneNumberVerificationExpiredCodeError');

  static LocalizedStringBuilder get phoneNumberVerificationInvalidCodeError =>
      _builder((_) => _.phoneNumberVerificationInvalidCodeError,
          'phoneNumberVerificationInvalidCodeError');

//endregion Phone Number Verification Page

// region Country Code list Page

  static LocalizedStringBuilder get countryCodeListPageTitle =>
      _builder((_) => _.countryCodeListPageTitle, 'countryCodeListPageTitle');

  static LocalizedStringBuilder get countryCodeEmptyPrompt =>
      _builder((_) => _.countryCodeEmptyPrompt, 'countryCodeEmptyPrompt');

// endregion Country Code list Page

// region Country list Page

  static LocalizedStringBuilder get countryListPageTitle =>
      _builder((_) => _.countryListPageTitle, 'countryListPageTitle');

// endregion Country list Page

// region Nationality list Page

  static LocalizedStringBuilder get nationalityListPageTitle =>
      _builder((_) => _.nationalityListPageTitle, 'nationalityListPageTitle');

// endregion Nationality list Page

// region common country list text

  static LocalizedStringBuilder get countryListFilterHint =>
      _builder((_) => _.countryListFilterHint, 'countryListFilterHint');

// endregion common country list text

// region common list text

  static LocalizedStringBuilder get listNoResultsTitle =>
      _builder((_) => _.listNoResultsTitle, 'listNoResultsTitle');

  static LocalizedStringBuilder get listNoResultsDetails =>
      _builder((_) => _.listNoResultsDetails, 'listNoResultsDetails');

// endregion common list text

//region Home Page

  static LocalizedStringBuilder get search =>
      _builder((_) => _.search, 'search');

  static LocalizedStringBuilder get yourOffers =>
      _builder((_) => _.yourOffers, 'yourOffers');

  static LocalizedStringBuilder get monthlyChallenges =>
      _builder((_) => _.monthlyChallenges, 'monthlyChallenges');

  static LocalizedStringBuilder get monthlyChallengesSubtitle =>
      _builder((_) => _.monthlyChallengesSubtitle, 'monthlyChallengesSubtitle');

  static LocalizedStringBuilder get homePageCountdownTitle =>
      _builder((_) => _.homePageCountdownTitle, 'homePageCountdownTitle');

  static LocalizedStringBuilder get homePageCountdownSubtitle =>
      _builder((_) => _.homePageCountdownSubtitle, 'homePageCountdownSubtitle');

  static LocalizedStringBuilder homePageCountdownViewAll(int count) => _builder(
      (_) => _.homePageCountdownViewAll(count),
      'homePageCountdownViewAll($count)');

//endregion Home Page

//region Offers

  static LocalizedStringBuilder get offers =>
      _builder((_) => _.offers, 'offers');

  static LocalizedStringBuilder get earn => _builder((_) => _.earn, 'earn');

  static LocalizedStringBuilder get redeem =>
      _builder((_) => _.redeem, 'redeem');

//endregion Offers

// region Balance Box

  static LocalizedStringBuilder get balanceBoxErrorMessage =>
      _builder((_) => _.balanceBoxErrorMessage, 'balanceBoxErrorMessage');

  static LocalizedStringBuilder get balanceBoxHeader =>
      _builder((_) => _.balanceBoxHeader, 'balanceBoxHeader');

// endregion Balance Box

// region Wallet Page

  static LocalizedStringBuilder get walletPageMyTotalTokens =>
      _builder((_) => _.walletPageMyTotalTokens, 'walletPageMyTotalTokens');

  static LocalizedStringBuilder get walletPageTitle =>
      _builder((_) => _.walletPageTitle, 'walletPageTitle');

  static LocalizedStringBuilder get transfer =>
      _builder((_) => _.transfer, 'transfer');

  static LocalizedStringBuilder get receive =>
      _builder((_) => _.receive, 'receive');

  static LocalizedStringBuilder get requests =>
      _builder((_) => _.requests, 'requests');

  static LocalizedStringBuilder from(String sender) =>
      _builder((_) => _.from(sender), 'from($sender)');

  static LocalizedStringBuilder to(String recipient) =>
      _builder((_) => _.to(recipient), 'to($recipient)');

  static LocalizedStringBuilder walletPageSendButtonSubtitle(String token) =>
      _builder((_) => _.walletPageSendButtonSubtitle(token),
          'walletPageSendButtonSubtitle($token)');

  static LocalizedStringBuilder walletPageReceiveButtonTitle(String token) =>
      _builder((_) => _.walletPageReceiveButtonTitle(token),
          'walletPageReceiveButtonTitle($token)');

  static LocalizedStringBuilder walletPageReceiveButtonSubtitle(String token) =>
      _builder((_) => _.walletPageReceiveButtonSubtitle(token),
          'walletPageReceiveButtonSubtitle($token)');

  static LocalizedStringBuilder get walletPageTransferRequestsTitle => _builder(
      (_) => _.walletPageTransferRequestsTitle,
      'walletPageTransferRequestsTitle');

  static LocalizedStringBuilder get externalWalletTitle =>
      _builder((_) => _.externalWalletTitle, 'externalWalletTitle');

  static LocalizedStringBuilder get externalWalletHint =>
      _builder((_) => _.externalWalletHint, 'externalWalletHint');

  static LocalizedStringBuilder externalLinkWalletDescription(String token) =>
      _builder((_) => _.externalLinkWalletDescription(token),
          'externalLinkWalletDescription($token)');

  static LocalizedStringBuilder get linkSimpleWalletDescription => _builder(
      (_) => _.linkSimpleWalletDescription, 'linkSimpleWalletDescription');

// ignore: lines_longer_than_80_chars

  static LocalizedStringBuilder walletPagePaymentRequestsSubtitle(int count) =>
      _builder((_) => _.walletPagePaymentRequestsSubtitle(count),
          'walletPagePaymentRequestsSubtitle($count)');

  static LocalizedStringBuilder get walletPageTransactionHistoryEmpty =>
      _builder((_) => _.walletPageTransactionHistoryEmpty,
          'walletPageTransactionHistoryEmpty');

  static LocalizedStringBuilder walletPageTransactionHistorySentType(
          String token) =>
      _builder((_) => _.walletPageTransactionHistorySentType(token),
          'walletPageTransactionHistorySentType($token)');

  static LocalizedStringBuilder walletPageTransactionHistoryReceivedType(
          String token) =>
      _builder((_) => _.walletPageTransactionHistoryReceivedType(token),
          'walletPageTransactionHistoryReceivedType($token)');

  static LocalizedStringBuilder get walletPageTransactionHistoryRewardType =>
      _builder((_) => _.walletPageTransactionHistoryRewardType,
          'walletPageTransactionHistoryRewardType');

  static LocalizedStringBuilder get walletPageTransactionHistoryRefundType =>
      _builder((_) => _.walletPageTransactionHistoryRefundType,
          'walletPageTransactionHistoryRefundType');

  static LocalizedStringBuilder get walletPageTransactionHistoryPaymentType =>
      _builder((_) => _.walletPageTransactionHistoryPaymentType,
          'walletPageTransactionHistoryPaymentType');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryWalletLinkingType => _builder(
          (_) => _.walletPageTransactionHistoryWalletLinkingType,
          'walletPageTransactionHistoryWalletLinkingType');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryTransferToExternalType => _builder(
          (_) => _.walletPageTransactionHistoryTransferToExternalType,
          'walletPageTransactionHistoryTransferToExternalType');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryTransferFromExternalType => _builder(
          (_) => _.walletPageTransactionHistoryTransferFromExternalType,
          'walletPageTransactionHistoryTransferFromExternalType');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryTransferFeeType => _builder(
          (_) => _.walletPageTransactionHistoryTransferFeeType,
          'walletPageTransactionHistoryTransferFeeType');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryVoucherPurchaseType => _builder(
          (_) => _.walletPageTransactionHistoryVoucherPurchaseType,
          'walletPageTransactionHistoryVoucherPurchaseType');

  static LocalizedStringBuilder get walletPageTransactionHistoryTitle =>
      _builder((_) => _.walletPageTransactionHistoryTitle,
          'walletPageTransactionHistoryTitle');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryInitialPageError => _builder(
          (_) => _.walletPageTransactionHistoryInitialPageError,
          'walletPageTransactionHistoryInitialPageError');

  static LocalizedStringBuilder
      get walletPageTransactionHistoryPaginationError => _builder(
          (_) => _.walletPageTransactionHistoryPaginationError,
          'walletPageTransactionHistoryPaginationError');

  static LocalizedStringBuilder get walletPageWalletDisabledError => _builder(
      (_) => _.walletPageWalletDisabledError, 'walletPageWalletDisabledError');

  static LocalizedStringBuilder get walletPageWalletDisabledErrorMessage =>
      _builder((_) => _.walletPageWalletDisabledErrorMessage,
          'walletPageWalletDisabledErrorMessage');

// endregion Wallet Page

// region Lead Referral Page
  static LocalizedStringBuilder get leadReferralPageTitle =>
      _builder((_) => _.leadReferralPageTitle, 'leadReferralPageTitle');

  static LocalizedStringBuilder
      get leadReferralFormPageCommunityOfInterestLabel => _builder(
          (_) => _.leadReferralFormPageCommunityOfInterestLabel,
          'leadReferralFormPageCommunityOfInterestLabel');

// endregion Lead Referral Page

// region Lead Referral Success Page
  static LocalizedStringBuilder leadReferralSuccessPageDetails(
          String refereeFirstName, String refereeLastName) =>
      _builder(
          (_) => _.leadReferralSuccessPageDetails(
              refereeFirstName, refereeLastName),
          'leadReferralSuccessPageDetails($refereeFirstName, $refereeLastName)'); // ignore: lines_longer_than_80_chars

  static LocalizedStringBuilder leadReferralSuccessPageDetailsPartnerName(
          String partnerName) =>
      _builder((_) => _.leadReferralSuccessPageDetailsPartnerName(partnerName),
          'leadReferralSuccessPageDetailsPartnerName($partnerName)');

// endregion Lead Referral Success Page

//region Referral Success shared elements

  static LocalizedStringBuilder get referralSuccessPageTitle =>
      _builder((_) => _.referralSuccessPageTitle, 'referralSuccessPageTitle');

  static LocalizedStringBuilder get referralSuccessPageSubDetails =>
      _builder((_) => _.referralSuccessPageSubDetails, 'networkErrorTitle');

  static LocalizedStringBuilder get referralSuccessGoToRefsButton => _builder(
      (_) => _.referralSuccessGoToRefsButton, 'referralSuccessGoToRefsButton');

//endregion Referral Success shared elements

//region LeadReferralAcceptedPage

  static LocalizedStringBuilder get leadReferralAcceptedSuccessBody => _builder(
      (_) => _.leadReferralAcceptedSuccessBody,
      'leadReferralAcceptedSuccessBody');

//endregion LeadReferralAcceptedPage

// region Hotel Referral Page
  static LocalizedStringBuilder get hotelReferralPageTitle =>
      _builder((_) => _.hotelReferralPageTitle, 'hotelReferralPageTitle');

  static LocalizedStringBuilder get hotelReferralPageDescription => _builder(
      (_) => _.hotelReferralPageDescription, 'hotelReferralPageDescription');

  static LocalizedStringBuilder get hotelReferralPageButton =>
      _builder((_) => _.hotelReferralPageButton, 'hotelReferralPageButton');

  static LocalizedStringBuilder hotelReferralPartnerInfo(String partnerName) =>
      _builder((_) => _.hotelReferralPartnerInfo(partnerName),
          'hotelReferralPartnerInfo($partnerName)');

  static LocalizedStringBuilder get hotelReferralStakingInfo =>
      _builder((_) => _.hotelReferralStakingInfo, 'hotelReferralStakingInfo');

  static LocalizedStringBuilder get hotelReferralFullNameFieldLabel => _builder(
      (_) => _.hotelReferralFullNameFieldLabel,
      'hotelReferralFullNameFieldLabel');

  static LocalizedStringBuilder get hotelReferralFullNameFieldHint => _builder(
      (_) => _.hotelReferralFullNameFieldHint,
      'hotelReferralFullNameFieldHint');

// endregion Hotel Referral Page

// region Hotel Referral Success Page
  static LocalizedStringBuilder hotelReferralSuccessPageDetails(
          String refereeFullName) =>
      _builder((_) => _.hotelReferralSuccessPageDetails(refereeFullName),
          'hotelReferralSuccessPageDetails($refereeFullName)');

  static LocalizedStringBuilder hotelReferralSuccessPageDetailsPartnerName(
          String partnerName) =>
      _builder((_) => _.hotelReferralSuccessPageDetailsPartnerName(partnerName),
          'hotelReferralSuccessPageDetailsPartnerName($partnerName)');

// endregion Hotel Referral Success Page

// region Hotel Referral Accepted Page
  static LocalizedStringBuilder hotelReferralAcceptedSuccessBody(
          String token, String company) =>
      _builder((_) => _.hotelReferralAcceptedSuccessBody(token, company),
          'hotelReferralAcceptedSuccessBody($token, $company)');

// endregion Hotel Referral Accepted Page

// region Hotel Referral Error Page
  static LocalizedStringBuilder get hotelReferralErrorTitle =>
      _builder((_) => _.hotelReferralErrorTitle, 'hotelReferralErrorTitle');

  static LocalizedStringBuilder get hotelReferralErrorDetails =>
      _builder((_) => _.hotelReferralErrorDetails, 'hotelReferralErrorDetails');

  static LocalizedStringBuilder get hotelReferralErrorLeadAlreadyExists =>
      _builder((_) => _.hotelReferralErrorLeadAlreadyExists,
          'hotelReferralErrorLeadAlreadyExists');

// endregion Hotel Referral Error Page

// region Referral list Page
  static LocalizedStringBuilder get referralListPageTitle =>
      _builder((_) => _.referralListPageTitle, 'referralListPageTitle');

  static LocalizedStringBuilder get referralListPageDescription => _builder(
      (_) => _.referralListPageDescription, 'referralListPageDescription');

  static LocalizedStringBuilder get referralListRequestGenericErrorSubtitle =>
      _builder((_) => _.referralListRequestGenericErrorSubtitle,
          'referralListRequestGenericErrorSubtitle');

  static LocalizedStringBuilder get referralListRequestGenericErrorTitle =>
      _builder((_) => _.referralListRequestGenericErrorTitle,
          'referralListRequestGenericErrorTitle');

  static LocalizedStringBuilder get pendingReferralListEmptyState => _builder(
      (_) => _.pendingReferralListEmptyState, 'pendingReferralListEmptyState');

  static LocalizedStringBuilder get approvedReferralListEmptyState => _builder(
      (_) => _.approvedReferralListEmptyState,
      'approvedReferralListEmptyState');

  static LocalizedStringBuilder get expiredReferralListEmptyState => _builder(
      (_) => _.expiredReferralListEmptyState, 'expiredReferralListEmptyState');

  static LocalizedStringBuilder get referralListOngoingTab =>
      _builder((_) => _.referralListOngoingTab, 'referralListOngoingTab');

  static LocalizedStringBuilder get referralListCompletedTab =>
      _builder((_) => _.referralListCompletedTab, 'referralListCompletedTab');

  static LocalizedStringBuilder get referralListExpiredTab =>
      _builder((_) => _.referralListExpiredTab, 'referralListExpiredTab');

// endregion Referral list Page

//region Referral Shared Elements

  static LocalizedStringBuilder get referralAcceptedSuccessTitle => _builder(
      (_) => _.referralAcceptedSuccessTitle, 'referralAcceptedSuccessTitle');

  static LocalizedStringBuilder get referralAcceptedTitle =>
      _builder((_) => _.referralAcceptedTitle, 'referralAcceptedTitle');

  static LocalizedStringBuilder get referralAcceptedNotFoundError => _builder(
      (_) => _.referralAcceptedNotFoundError, 'referralAcceptedNotFoundError');

  static LocalizedStringBuilder get referralAcceptedInvalidCode => _builder(
      (_) => _.referralAcceptedInvalidCode, 'referralAcceptedInvalidCode');

//endregion Referral Shared Elements

//region P2P Transaction Page

  static LocalizedStringBuilder transactionFormPageTitle(String token) =>
      _builder((_) => _.transactionFormPageTitle(token),
          'transactionFormPageTitle($token)');

  static LocalizedStringBuilder transactionFormPageSubDetails(String token) =>
      _builder((_) => _.transactionFormPageSubDetails(token),
          'transactionFormPageSubDetails($token)');

  static LocalizedStringBuilder transactionFormStakedAmount(
          String lockedAmount) =>
      _builder((_) => _.transactionFormStakedAmount(lockedAmount),
          'transactionFormStakedAmount($lockedAmount)');

  static LocalizedStringBuilder get transactionFormScanQRCode =>
      _builder((_) => _.transactionFormScanQRCode, 'transactionFormScanQRCode');

  static LocalizedStringBuilder get transactionFormOr =>
      _builder((_) => _.transactionFormOr, 'transactionFormOr');

  static LocalizedStringBuilder get transactionReceiverEmailAddressLabel =>
      _builder((_) => _.transactionReceiverEmailAddressLabel,
          'transactionReceiverEmailAddressLabel');

  static LocalizedStringBuilder get transactionReceiverEmailAddressHint =>
      _builder((_) => _.transactionReceiverEmailAddressHint,
          'transactionReceiverEmailAddressHint');

  static LocalizedStringBuilder transactionAmountTokensLabel(String token) =>
      _builder((_) => _.transactionAmountTokensLabel(token),
          'transactionAmountTokensLabel($token)');

  static LocalizedStringBuilder get transactionAmountOfTokensHint => _builder(
      (_) => _.transactionAmountOfTokensHint, 'transactionAmountOfTokensHint');

  static LocalizedStringBuilder get transactionEmptyAddressError => _builder(
      (_) => _.transactionEmptyAddressError, 'transactionEmptyAddressError');

  static LocalizedStringBuilder get transactionInvalidAddressError => _builder(
      (_) => _.transactionInvalidAddressError,
      'transactionInvalidAddressError');

  static LocalizedStringBuilder get transactionAmountRequiredError => _builder(
      (_) => _.transactionAmountRequiredError,
      'transactionAmountRequiredError');

  static LocalizedStringBuilder get transactionAmountInvalidError => _builder(
      (_) => _.transactionAmountInvalidError, 'transactionAmountInvalidError');

  static LocalizedStringBuilder get transactionAmountGreaterThanBalanceError =>
      _builder((_) => _.transactionAmountGreaterThanBalanceError,
          'transactionAmountGreaterThanBalanceError');

  static LocalizedStringBuilder get barcodeScanPermissionError => _builder(
      (_) => _.barcodeScanPermissionError, 'barcodeScanPermissionError');

  static LocalizedStringBuilder get barcodeScanError =>
      _builder((_) => _.barcodeScanError, 'barcodeScanError');

  static LocalizedStringBuilder get copyEmail =>
      _builder((_) => _.copyEmail, 'copyEmail');

//endregion P2P Transaction Page

//region Transaction Success Page

  static LocalizedStringBuilder get transactionSuccessTitle =>
      _builder((_) => _.transactionSuccessTitle, 'transactionSuccessTitle');

  static LocalizedStringBuilder get transactionSuccessDetails =>
      _builder((_) => _.transactionSuccessDetails, 'transactionSuccessDetails');

//endregion Transaction Success Page

//region Wallet linking

  static LocalizedStringBuilder get insufficientFunds =>
      _builder((_) => _.insufficientFunds, 'insufficientFunds');

  static LocalizedStringBuilder get linkYourWallet =>
      _builder((_) => _.linkYourWallet, 'linkYourWallet');

  static LocalizedStringBuilder get walletLinkingInProgress =>
      _builder((_) => _.walletLinkingInProgress, 'walletLinkingInProgress');

  static LocalizedStringBuilder get linkSimpleWalletInstructionCopyUrl =>
      _builder((_) => _.linkSimpleWalletInstructionCopyUrl,
          'linkSimpleWalletInstructionCopyUrl');

  static LocalizedStringBuilder get linkSimpleWalletInstructionSwitchToWallet =>
      _builder((_) => _.linkSimpleWalletInstructionSwitchToWallet,
          'linkSimpleWalletInstructionSwitchToWallet');

  static LocalizedStringBuilder get linkSimpleWalletInstructionPasteAddress =>
      _builder((_) => _.linkSimpleWalletInstructionPasteAddress,
          'linkSimpleWalletInstructionPasteAddress');

  static LocalizedStringBuilder get linkSimpleWalletInstructionPasteLink =>
      _builder((_) => _.linkSimpleWalletInstructionPasteLink,
          'linkSimpleWalletInstructionPasteLink');

  static LocalizedStringBuilder get linkWalletInstructionSelectWallet =>
      _builder((_) => _.linkWalletInstructionSelectWallet,
          'linkWalletInstructionSelectWallet');

  static LocalizedStringBuilder get linkWalletInstructionConfirmLinking =>
      _builder((_) => _.linkWalletInstructionConfirmLinking,
          'linkWalletInstructionConfirmLinking');

  static LocalizedStringBuilder get linkWalletInstructionFees =>
      _builder((_) => _.linkWalletInstructionFees, 'linkWalletInstructionFees');

  static LocalizedStringBuilder get linkWalletChooseSupportedWallets =>
      _builder((_) => _.linkWalletChooseSupportedWallets,
          'linkWalletChooseSupportedWallets');

  static LocalizedStringBuilder get linkWalletHeader =>
      _builder((_) => _.linkWalletHeader, 'linkWalletHeader');

  static LocalizedStringBuilder get linkSimpleWalletHeader =>
      _builder((_) => _.linkSimpleWalletHeader, 'linkSimpleWalletHeader');

  static LocalizedStringBuilder get simpleWalletsTitle =>
      _builder((_) => _.simpleWalletsTitle, 'simpleWalletsTitle');

  static LocalizedStringBuilder get simpleWalletsDescription =>
      _builder((_) => _.simpleWalletsDescription, 'simpleWalletsDescription');

  static LocalizedStringBuilder get advancedWalletsTitle =>
      _builder((_) => _.advancedWalletsTitle, 'advancedWalletsTitle');

  static LocalizedStringBuilder get advancedWalletsDescription => _builder(
      (_) => _.advancedWalletsDescription, 'advancedWalletsDescription');

  static LocalizedStringBuilder get dapBrowserHint =>
      _builder((_) => _.dapBrowserHint, 'dapBrowserHint');

  static LocalizedStringBuilder get linkWalletInProgressHeader => _builder(
      (_) => _.linkWalletInProgressHeader, 'linkWalletInProgressHeader');

  static LocalizedStringBuilder get linkWalletInProgressTitle =>
      _builder((_) => _.linkWalletInProgressTitle, 'linkWalletInProgressTitle');

  static LocalizedStringBuilder get linkWalletInProgressDescription => _builder(
      (_) => _.linkWalletInProgressDescription,
      'linkWalletInProgressDescription');

  static LocalizedStringBuilder get linkedWalletHeader =>
      _builder((_) => _.linkedWalletHeader, 'linkedWalletHeader');

  static LocalizedStringBuilder get sendToExternalWalletButton => _builder(
      (_) => _.sendToExternalWalletButton, 'sendToExternalWalletButton');

  static LocalizedStringBuilder sendToExternalWalletButtonSubtitle(
          String token) =>
      _builder((_) => _.sendToExternalWalletButtonSubtitle(token),
          'sendToExternalWalletButtonSubtitle($token)');

  static LocalizedStringBuilder get receiveExternalWalletButton => _builder(
      (_) => _.receiveExternalWalletButton, 'receiveExternalWalletButton');

  static LocalizedStringBuilder receiveExternalWalletButtonSubtitle(
          String token) =>
      _builder((_) => _.receiveExternalWalletButtonSubtitle(token),
          'receiveExternalWalletButtonSubtitle($token)');

  static LocalizedStringBuilder get unlinkExternalWalletButton => _builder(
      (_) => _.unlinkExternalWalletButton, 'unlinkExternalWalletButton');

  static LocalizedStringBuilder get unlinkExternalWalletButtonSubtitle =>
      _builder((_) => _.unlinkExternalWalletButtonSubtitle,
          'unlinkExternalWalletButtonSubtitle');

  static LocalizedStringBuilder get linkAdvancedWalletHeader =>
      _builder((_) => _.linkAdvancedWalletHeader, 'linkAdvancedWalletHeader');

  static LocalizedStringBuilder get linkAdvancedWalletDescription => _builder(
      (_) => _.linkAdvancedWalletDescription, 'linkAdvancedWalletDescription');

  static LocalizedStringBuilder get linkAdvancedWalletInstructionCopyCode =>
      _builder((_) => _.linkAdvancedWalletInstructionCopyCode,
          'linkAdvancedWalletInstructionCopyCode');

  static LocalizedStringBuilder get linkAdvancedWalletInstructionSwitchApp =>
      _builder((_) => _.linkAdvancedWalletInstructionSwitchApp,
          'linkAdvancedWalletInstructionSwitchApp');

  static LocalizedStringBuilder get linkAdvancedWalletInstructionSignMessage =>
      _builder((_) => _.linkAdvancedWalletInstructionSignMessage,
          'linkAdvancedWalletInstructionSignMessage');

  static LocalizedStringBuilder
      get linkAdvancedWalletInstructionCopySignature => _builder(
          (_) => _.linkAdvancedWalletInstructionCopySignature,
          'linkAdvancedWalletInstructionCopySignature');

  static LocalizedStringBuilder
      get linkAdvancedWalletInstructionPasteSignature => _builder(
          (_) => _.linkAdvancedWalletInstructionPasteSignature,
          'linkAdvancedWalletInstructionPasteSignature');

  static LocalizedStringBuilder
      get linkAdvancedWalletInstructionPublicAddress => _builder(
          (_) => _.linkAdvancedWalletInstructionPublicAddress,
          'linkAdvancedWalletInstructionPublicAddress');

  static LocalizedStringBuilder get linkAdvancedWalletButton =>
      _builder((_) => _.linkAdvancedWalletButton, 'linkAdvancedWalletButton');

  static LocalizedStringBuilder
      get linkAdvancedWalletTextFieldCodeSignatureTitle => _builder(
          (_) => _.linkAdvancedWalletTextFieldCodeSignatureTitle,
          'linkAdvancedWalletTextFieldCodeSignatureTitle');

  static LocalizedStringBuilder
      get linkAdvancedWalletTextFieldCodeSignatureHint => _builder(
          (_) => _.linkAdvancedWalletTextFieldCodeSignatureHint,
          'linkAdvancedWalletTextFieldCodeSignatureHint');

  static LocalizedStringBuilder
      get emptyLinkAdvancedWalletTextFieldCodeSignatureError => _builder(
          (_) => _.emptyLinkAdvancedWalletTextFieldCodeSignatureError,
          'emptyLinkAdvancedWalletTextFieldCodeSignatureError');

  static LocalizedStringBuilder
      get linkAdvancedWalletTextFieldPublicAddressTitle => _builder(
          (_) => _.linkAdvancedWalletTextFieldPublicAddressTitle,
          'linkAdvancedWalletTextFieldPublicAddressTitle');

  static LocalizedStringBuilder
      get linkAdvancedWalletTextFieldPublicAddressHint => _builder(
          (_) => _.linkAdvancedWalletTextFieldPublicAddressHint,
          'linkAdvancedWalletTextFieldPublicAddressHint');

  static LocalizedStringBuilder
      get emptyLinkAdvancedWalletTextFieldPublicAddressError => _builder(
          (_) => _.emptyLinkAdvancedWalletTextFieldPublicAddressError,
          'emptyLinkAdvancedWalletTextFieldPublicAddressError');

  static LocalizedStringBuilder linkWalletReceiveTitle(String token) =>
      _builder((_) => _.linkWalletReceiveTitle(token),
          'linkWalletReceiveTitle($token)');

  static LocalizedStringBuilder linkWalletReceiveHint(String token) => _builder(
      (_) => _.linkWalletReceiveHint(token), 'linkWalletReceiveHint($token)');

  static LocalizedStringBuilder get linkWalletReceiveCopyAddress => _builder(
      (_) => _.linkWalletReceiveCopyAddress, 'linkWalletReceiveCopyAddress');

  static LocalizedStringBuilder get linkWalletReceiveNote =>
      _builder((_) => _.linkWalletReceiveNote, 'linkWalletReceiveNote');

  static LocalizedStringBuilder get linkWalletTransferFailedTitle => _builder(
      (_) => _.linkWalletTransferFailedTitle, 'linkWalletTransferFailedTitle');

  static LocalizedStringBuilder get linkWalletTransferFailedDetails => _builder(
      (_) => _.linkWalletTransferFailedDetails,
      'linkWalletTransferFailedDetails');

  static LocalizedStringBuilder get linkWalletTransferFailedSubDetails =>
      _builder((_) => _.linkWalletTransferFailedSubDetails,
          'linkWalletTransferFailedSubDetails');

  static LocalizedStringBuilder linkedWalletSendTitle(String token) => _builder(
      (_) => _.linkedWalletSendTitle(token), 'linkedWalletSendTitle($token)');

  static LocalizedStringBuilder linkedWalletSendHint(String token) => _builder(
      (_) => _.linkedWalletSendHint(token), 'linkedWalletSendHint($token)');

  static LocalizedStringBuilder get linkingWalletDisabled =>
      _builder((_) => _.linkingWalletDisabled, 'linkingWalletDisabled');

//endregion Wallet linking

//region Wallet Unlinking

  static LocalizedStringBuilder get unlinkWalletInProgressHeader => _builder(
      (_) => _.unlinkWalletInProgressHeader, 'unlinkWalletInProgressHeader');

  static LocalizedStringBuilder get unlinkWalletInProgressTitle => _builder(
      (_) => _.unlinkWalletInProgressTitle, 'unlinkWalletInProgressTitle');

//endregion Wallet Unlinking

//region Social Page
  static LocalizedStringBuilder get socialPageTitle =>
      _builder((_) => _.socialPageTitle, 'socialPageTitle');

  static LocalizedStringBuilder get socialPageComingSoon =>
      _builder((_) => _.socialPageComingSoon, 'socialPageComingSoon');

//region Spend Page

  static LocalizedStringBuilder get spendPageTitle =>
      _builder((_) => _.spendPageTitle, 'spendPageTitle');

  static LocalizedStringBuilder get spendRulePageEmpty =>
      _builder((_) => _.spendRulePageEmpty, 'spendRulePageEmpty');

  static LocalizedStringBuilder get doneButton =>
      _builder((_) => _.doneButton, 'doneButton');

  static LocalizedStringBuilder get offerDetailGenericError =>
      _builder((_) => _.offerDetailGenericError, 'offerDetailGenericError');

  static LocalizedStringBuilder voucherStockCount(int stockCount) => _builder(
      (_) => _.voucherStockCount(stockCount), 'voucherStockCount($stockCount)');

  static LocalizedStringBuilder voucherSoldCountInfo(int soldCount) => _builder(
      (_) => _.voucherSoldCountInfo(soldCount),
      'voucherSoldCountInfo($soldCount)');

  static LocalizedStringBuilder get voucherDetailsAmount =>
      _builder((_) => _.voucherDetailsAmount, 'voucherDetailsAmount');

  static LocalizedStringBuilder get voucherDetailsAvailableBalance => _builder(
      (_) => _.voucherDetailsAvailableBalance,
      'voucherDetailsAvailableBalance');

  static LocalizedStringBuilder get tokensLocked =>
      _builder((_) => _.tokensLocked, 'tokensLocked');

  static LocalizedStringBuilder get redeemVoucherButton =>
      _builder((_) => _.redeemVoucherButton, 'redeemVoucherButton');

  static LocalizedStringBuilder get redeemVoucherInsufficientFunds => _builder(
      (_) => _.redeemVoucherInsufficientFunds,
      'redeemVoucherInsufficientFunds');

  static LocalizedStringBuilder get outOfStockDescription =>
      _builder((_) => _.outOfStockDescription, 'outOfStockDescription');

//endregion Spend Page

//region Real Estate Payment

  static LocalizedStringBuilder get realEstateListChooseAProperty => _builder(
      (_) => _.realEstateListChooseAProperty, 'realEstateListChooseAProperty');

  static LocalizedStringBuilder get realEstateListNoPurchases =>
      _builder((_) => _.realEstateListNoPurchases, 'realEstateListNoPurchases');

  static LocalizedStringBuilder get instalmentListChooseAnInstalment =>
      _builder((_) => _.instalmentListChooseAnInstalment,
          'instalmentListChooseAnInstalment');

  static LocalizedStringBuilder get installmentOverdue =>
      _builder((_) => _.installmentOverdue, 'installmentOverdue');

//endregion Real Estate Payment

// region Property Payment Page
  static LocalizedStringBuilder get propertyPaymentPageTitle =>
      _builder((_) => _.propertyPaymentPageTitle, 'propertyPaymentPageTitle');

  static LocalizedStringBuilder get propertyPaymentPageSubDetails => _builder(
      (_) => _.propertyPaymentPageSubDetails, 'propertyPaymentPageSubDetails');

  static LocalizedStringBuilder get propertyPaymentFull =>
      _builder((_) => _.propertyPaymentFull, 'propertyPaymentFull');

  static LocalizedStringBuilder get propertyPaymentPartial =>
      _builder((_) => _.propertyPaymentPartial, 'propertyPaymentPartial');

  static LocalizedStringBuilder get propertyPaymentProperty =>
      _builder((_) => _.propertyPaymentProperty, 'propertyPaymentProperty');

  static LocalizedStringBuilder get propertyPaymentAvailableBalanceLabel =>
      _builder((_) => _.propertyPaymentAvailableBalanceLabel,
          'propertyPaymentAvailableBalanceLabel');

  static LocalizedStringBuilder propertyPaymentConversionHolder(
          String amount, String currencyName) =>
      _builder((_) => _.propertyPaymentConversionHolder(amount, currencyName),
          'propertyPaymentConversionHolder($amount, $currencyName)');

  static LocalizedStringBuilder get propertyPaymentAmountExceedsInstalment =>
      _builder((_) => _.propertyPaymentAmountExceedsInstalment,
          'propertyPaymentAmountExceedsInstalment');

  static LocalizedStringBuilder currencyConversionLabel(String amountInToken,
          String token, String amountInCurrency, String currency) =>
      _builder(
          (_) => _.currencyConversionLabel(
              amountInToken, token, amountInCurrency, currency),
          'currencyConversionLabel($amountInToken, $token, $amountInCurrency, $currency)'); // ignore: lines_longer_than_80_chars

  static LocalizedStringBuilder get paymentAmountRequiredError => _builder(
      (_) => _.paymentAmountRequiredError, 'paymentAmountRequiredError');

  static LocalizedStringBuilder get paymentAmountInvalidError =>
      _builder((_) => _.paymentAmountInvalidError, 'paymentAmountInvalidError');

  static LocalizedStringBuilder get emptyPaymentInvoiceError =>
      _builder((_) => _.emptyPaymentInvoiceError, 'emptyPaymentInvoiceError');

  static LocalizedStringBuilder get insufficientBalanceError =>
      _builder((_) => _.insufficientBalanceError, 'insufficientBalanceError');

  static LocalizedStringBuilder get paymentSuccessDetails =>
      _builder((_) => _.paymentSuccessDetails, 'paymentSuccessDetails');

// endregion Property Payment Page

//region Redemption Success Page

  static LocalizedStringBuilder get redemptionSuccessTitle =>
      _builder((_) => _.redemptionSuccessTitle, 'redemptionSuccessTitle');

  static LocalizedStringBuilder get redemptionSuccessCopyTitle => _builder(
      (_) => _.redemptionSuccessCopyTitle, 'redemptionSuccessCopyTitle');

  static LocalizedStringBuilder get redemptionSuccessDetailsText => _builder(
      (_) => _.redemptionSuccessDetailsText, 'redemptionSuccessDetailsText');

  static LocalizedStringBuilder get redemptionSuccessDetailsLink => _builder(
      (_) => _.redemptionSuccessDetailsLink, 'redemptionSuccessDetailsLink');

  static LocalizedStringBuilder get redemptionSuccessOpenVoucherAppButton =>
      _builder((_) => _.redemptionSuccessOpenVoucherAppButton,
          'redemptionSuccessOpenVoucherAppButton');

  static LocalizedStringBuilder get redemptionSuccessToastMessage => _builder(
      (_) => _.redemptionSuccessToastMessage, 'redemptionSuccessToastMessage');

//endregion Redemption Success Page

//region Account Deactivated Page

  static LocalizedStringBuilder get accountDeactivatedPageTitle => _builder(
      (_) => _.accountDeactivatedPageTitle, 'accountDeactivatedPageTitle');

  static LocalizedStringBuilder get accountDeactivatedPageMessagePart1 =>
      _builder((_) => _.accountDeactivatedPageMessagePart1,
          'accountDeactivatedPageMessagePart1');

  static LocalizedStringBuilder accountDeactivatedPageMessagePart2(
          String token) =>
      _builder((_) => _.accountDeactivatedPageMessagePart2(token),
          'accountDeactivatedPageMessagePart2($token)');

  static LocalizedStringBuilder accountDeactivatedPageMessagePart3(
          String contactNumber) =>
      _builder((_) => _.accountDeactivatedPageMessagePart3(contactNumber),
          'accountDeactivatedPageMessagePart3($contactNumber)');

  static LocalizedStringBuilder get accountDeactivatedPageMessageClosePart1 =>
      _builder((_) => _.accountDeactivatedPageMessageClosePart1,
          'accountDeactivatedPageMessageClosePart1');

  static LocalizedStringBuilder accountDeactivatedPageMessageClosePart2(
          String token) =>
      _builder((_) => _.accountDeactivatedPageMessageClosePart2(token),
          'accountDeactivatedPageMessageClosePart2($token)');

  static LocalizedStringBuilder get accountDeactivatedPageContactButton =>
      _builder((_) => _.accountDeactivatedPageContactButton,
          'accountDeactivatedPageContactButton');

  static LocalizedStringBuilder
      get accountDeactivatedLaunchContactNumberError => _builder(
          (_) => _.accountDeactivatedLaunchContactNumberError,
          'accountDeactivatedLaunchContactNumberError');

//endregion Account Deactivated Page

//region Warning Dialog

  static LocalizedStringBuilder get warningDialogLeavingPageTitle => _builder(
      (_) => _.warningDialogLeavingPageTitle, 'warningDialogLeavingPageTitle');

  static LocalizedStringBuilder get warningDialogLeavingPageDetails => _builder(
      (_) => _.warningDialogLeavingPageDetails,
      'warningDialogLeavingPageDetails');

  static LocalizedStringBuilder get warningDialogYesButton =>
      _builder((_) => _.warningDialogYesButton, 'warningDialogYesButton');

  static LocalizedStringBuilder get warningDialogNoButton =>
      _builder((_) => _.warningDialogNoButton, 'warningDialogNoButton');

  static LocalizedStringBuilder get warningDialogNoThanksButton => _builder(
      (_) => _.warningDialogNoThanksButton, 'warningDialogNoThanksButton');

  static LocalizedStringBuilder get warningDialogGoToSettings =>
      _builder((_) => _.warningDialogGoToSettings, 'warningDialogGoToSettings');

//endregion Warning Dialog

//region Account Page
  static LocalizedStringBuilder get accountPageLogOutConfirmTitle => _builder(
      (_) => _.accountPageLogOutConfirmTitle, 'accountPageLogOutConfirmTitle');

  static LocalizedStringBuilder get accountPageLogOutConfirmContent => _builder(
      (_) => _.accountPageLogOutConfirmContent,
      'accountPageLogOutConfirmContent');

  static LocalizedStringBuilder get accountPageTitle =>
      _builder((_) => _.accountPageTitle, 'accountPageTitle');

  static LocalizedStringBuilder get accountPagePersonalDetailsOption =>
      _builder((_) => _.accountPagePersonalDetailsOption,
          'accountPagePersonalDetailsOption');

  static LocalizedStringBuilder get referralTrackingPersonalDetailsOption =>
      _builder((_) => _.referralTrackingPersonalDetailsOption,
          'referralTrackingPersonalDetailsOption');

  static LocalizedStringBuilder get vouchersOption =>
      _builder((_) => _.vouchersOption, 'vouchersOption');

  static LocalizedStringBuilder get accountPageChangePasswordOption => _builder(
      (_) => _.accountPageChangePasswordOption,
      'accountPageChangePasswordOption');

  static LocalizedStringBuilder get accountPageLogoutOption =>
      _builder((_) => _.accountPageLogoutOption, 'accountPageLogoutOption');

  static LocalizedStringBuilder accountAppVersion(String appVersion) =>
      _builder((_) => _.accountAppVersion(appVersion),
          'accountAppVersion($appVersion)');

  static LocalizedStringBuilder get accountPageBiometricsSignInOptionAndroid =>
      _builder((_) => _.accountPageBiometricsSignInOptionAndroid,
          'accountPageBiometricsSignInOptionAndroid');

  static LocalizedStringBuilder get accountPageBiometricsSignInOptionIOS =>
      _builder((_) => _.accountPageBiometricsSignInOptionIOS,
          'accountPageBiometricsSignInOptionIOS');

  static LocalizedStringBuilder get contactUsPageDetail =>
      _builder((_) => _.contactUsPageDetail, 'contactUsPageDetail');

  static LocalizedStringBuilder get contactUsPhoneNumber =>
      _builder((_) => _.contactUsPhoneNumber, 'contactUsPhoneNumber');

  static LocalizedStringBuilder get contactUsEmail =>
      _builder((_) => _.contactUsEmail, 'contactUsEmail');

  static LocalizedStringBuilder get contactUsWhatsApp =>
      _builder((_) => _.contactUsWhatsApp, 'contactUsWhatsApp');

  static LocalizedStringBuilder get contactUsWhatsAppStartingMessage =>
      _builder((_) => _.contactUsWhatsAppStartingMessage,
          'contactUsWhatsAppStartingMessage');

  static LocalizedStringBuilder get contactUsLaunchContactNumberError =>
      _builder((_) => _.contactUsLaunchContactNumberError,
          'contactUsLaunchContactNumberError');

  static LocalizedStringBuilder get contactUsLaunchContactEmailError =>
      _builder((_) => _.contactUsLaunchContactEmailError,
          'contactUsLaunchContactEmailError');

  static LocalizedStringBuilder get contactUsGenericErrorSubtitle => _builder(
      (_) => _.contactUsGenericErrorSubtitle, 'contactUsGenericErrorSubtitle');

//endregion Account Page

//region Delete Account Dialog

  static LocalizedStringBuilder get deleteAccountDialogTitle =>
      _builder((_) => _.deleteAccountDialogTitle, 'deleteAccountDialogTitle');

  static LocalizedStringBuilder get deleteAccountDialogDetails => _builder(
      (_) => _.deleteAccountDialogDetails, 'deleteAccountDialogDetails');

  static LocalizedStringBuilder get deleteAccountDialogDeleteButton => _builder(
      (_) => _.deleteAccountDialogDeleteButton,
      'deleteAccountDialogDeleteButton');

  static LocalizedStringBuilder get deleteAccountDialogCancelButton => _builder(
      (_) => _.deleteAccountDialogCancelButton,
      'deleteAccountDialogCancelButton');

//endregion Delete Account Dialog

//region Change password

  static LocalizedStringBuilder get changePasswordPagePrompt =>
      _builder((_) => _.changePasswordPagePrompt, 'changePasswordPagePrompt');

  static LocalizedStringBuilder get changePasswordPagePasswordLabel => _builder(
      (_) => _.changePasswordPagePasswordLabel,
      'changePasswordPagePasswordLabel');

  static LocalizedStringBuilder get changePasswordPageConfirmPasswordHint =>
      _builder((_) => _.changePasswordPageConfirmPasswordHint,
          'changePasswordPageConfirmPasswordHint');

  static LocalizedStringBuilder get changePasswordPagePasswordHint => _builder(
      (_) => _.changePasswordPagePasswordHint,
      'changePasswordPagePasswordHint');

//endregion Change password
//region Change password success
  static LocalizedStringBuilder get changePasswordSuccessTitle => _builder(
      (_) => _.changePasswordSuccessTitle, 'changePasswordSuccessTitle');

  static LocalizedStringBuilder get changePasswordSuccessDetails => _builder(
      (_) => _.changePasswordSuccessDetails, 'changePasswordSuccessDetails');

  static LocalizedStringBuilder get changePasswordSuccessBackToAccountButton =>
      _builder((_) => _.changePasswordSuccessBackToAccountButton,
          'changePasswordSuccessBackToAccountButton');

//endregion Change password success

//region Common Password elements

  static LocalizedStringBuilder get confirmPasswordLabel =>
      _builder((_) => _.confirmPasswordLabel, 'confirmPasswordLabel');

  static LocalizedStringBuilder get passwordGuide =>
      _builder((_) => _.passwordGuide, 'passwordGuide');

  static LocalizedStringBuilder get changePassword =>
      _builder((_) => _.changePassword, 'changePassword');

//endregion Common Password elements

//region Reset Password elements

  static LocalizedStringBuilder get resetPasswordTitle =>
      _builder((_) => _.resetPasswordTitle, 'resetPasswordTitle');

  static LocalizedStringBuilder get resetPasswordSendLinkHint =>
      _builder((_) => _.resetPasswordSendLinkHint, 'resetPasswordSendLinkHint');

  static LocalizedStringBuilder get resetPasswordSentEmailHint => _builder(
      (_) => _.resetPasswordSentEmailHint, 'resetPasswordSentEmailHint');

  static LocalizedStringBuilder get resetPassword =>
      _builder((_) => _.resetPassword, 'resetPassword');

  static LocalizedStringBuilder get resetPasswordPrompt =>
      _builder((_) => _.resetPasswordPrompt, 'resetPasswordPrompt');

  static LocalizedStringBuilder get setPasswordSuccessTitle =>
      _builder((_) => _.setPasswordSuccessTitle, 'setPasswordSuccessTitle');

  static LocalizedStringBuilder get setPasswordSuccessDetails =>
      _builder((_) => _.setPasswordSuccessDetails, 'setPasswordSuccessDetails');

  static LocalizedStringBuilder get setPasswordSuccessBackToAccountButton =>
      _builder((_) => _.setPasswordSuccessBackToAccountButton,
          'setPasswordSuccessBackToAccountButton');

//endregion Reset Password elements

//region Pin elements
  static LocalizedStringBuilder get pinCreatedSuccessTitle =>
      _builder((_) => _.pinCreatedSuccessTitle, 'pinCreatedSuccessTitle');

  static LocalizedStringBuilder get pinCreatedSuccessDetails =>
      _builder((_) => _.pinCreatedSuccessDetails, 'pinCreatedSuccessDetails');

  static LocalizedStringBuilder get pinErrorDoesNotMatch =>
      _builder((_) => _.pinErrorDoesNotMatch, 'pinErrorDoesNotMatch');

  static LocalizedStringBuilder pinErrorRemainingAttempts(int count) =>
      _builder((_) => _.pinErrorRemainingAttempts(count),
          'pinErrorRemainingAttempts($count)');

  static LocalizedStringBuilder get pinErrorIncorrectPassCode =>
      _builder((_) => _.pinErrorIncorrectPassCode, 'pinErrorIncorrectPassCode');

  static LocalizedStringBuilder get pinShow =>
      _builder((_) => _.pinShow, 'pinShow');

  static LocalizedStringBuilder get pinHide =>
      _builder((_) => _.pinHide, 'pinHide');

  static LocalizedStringBuilder get pinConfirmHeading =>
      _builder((_) => _.pinConfirmHeading, 'pinConfirmHeading');

  static LocalizedStringBuilder get pinConfirmDescription =>
      _builder((_) => _.pinConfirmDescription, 'pinConfirmDescription');

  static LocalizedStringBuilder get pinCreateHeading =>
      _builder((_) => _.pinCreateHeading, 'pinCreateHeading');

  static LocalizedStringBuilder pinCreateDescription(String appName) =>
      _builder((_) => _.pinCreateDescription(appName),
          'pinCreateDescription($appName)');

  static LocalizedStringBuilder get pinSignInHeading =>
      _builder((_) => _.pinSignInHeading, 'pinSignInHeading');

  static LocalizedStringBuilder get pinSignInDescription =>
      _builder((_) => _.pinSignInDescription, 'pinSignInDescription');

  static LocalizedStringBuilder get pinVerificationDescription => _builder(
      (_) => _.pinVerificationDescription, 'pinVerificationDescription');

  static LocalizedStringBuilder get pinForgotButton =>
      _builder((_) => _.pinForgotButton, 'pinForgotButton');

  static LocalizedStringBuilder get useFaceIDButton =>
      _builder((_) => _.useFaceIDButton, 'useFaceIDButton');

  static LocalizedStringBuilder get useBiometricButton =>
      _builder((_) => _.useBiometricButton, 'useBiometricButton');

  static LocalizedStringBuilder get useFingerprintButton =>
      _builder((_) => _.useFingerprintButton, 'useFingerprintButton');

  static LocalizedStringBuilder get pinForgotPageTitle =>
      _builder((_) => _.pinForgotPageTitle, 'pinForgotPageTitle');

  static LocalizedStringBuilder get pinForgotPageDescription =>
      _builder((_) => _.pinForgotPageDescription, 'pinForgotPageDescription');

  static LocalizedStringBuilder get pinForgotPageButton =>
      _builder((_) => _.pinForgotPageButton, 'pinForgotPageButton');

//endregion Pin elements

//region P2P Transaction Page

  static LocalizedStringBuilder receiveTokenPageTitle(String token) => _builder(
      (_) => _.receiveTokenPageTitle(token), 'receiveTokenPageTitle($token)');

  static LocalizedStringBuilder get receiveTokenPageSubDetails => _builder(
      (_) => _.receiveTokenPageSubDetails, 'receiveTokenPageSubDetails');

  static LocalizedStringBuilder get receiveTokenPageGenericErrorTitle =>
      _builder((_) => _.receiveTokenPageGenericErrorTitle,
          'receiveTokenPageGenericErrorTitle');

  static LocalizedStringBuilder get receiveTokenPageGenericErrorSubtitle =>
      _builder((_) => _.receiveTokenPageGenericErrorSubtitle,
          'receiveTokenPageGenericErrorSubtitle');

//endregion P2P Transaction Page

//region Earn Page

  static LocalizedStringBuilder get referAHotelSectionTitle =>
      _builder((_) => _.referAHotelSectionTitle, 'referAHotelSectionTitle');

  static LocalizedStringBuilder get inviteFriendSectionTitle =>
      _builder((_) => _.inviteFriendSectionTitle, 'inviteFriendSectionTitle');

  static LocalizedStringBuilder get inviteFriendEarnUpToPart1 =>
      _builder((_) => _.inviteFriendEarnUpToPart1, 'inviteFriendEarnUpToPart1');

  static LocalizedStringBuilder get inviteFriendEarnUpToPart2 =>
      _builder((_) => _.inviteFriendEarnUpToPart2, 'inviteFriendEarnUpToPart2');

  static LocalizedStringBuilder get earnRulePageInitialPageError => _builder(
      (_) => _.earnRulePageInitialPageError, 'earnRulePageInitialPageError');

  static LocalizedStringBuilder get earnRulePagePaginationError => _builder(
      (_) => _.earnRulePagePaginationError, 'earnRulePagePaginationError');

  static LocalizedStringBuilder get earnRulePageEmpty =>
      _builder((_) => _.earnRulePageEmpty, 'earnRulePageEmpty');

//endregion Earn Page

//region Earn Detail Page

  static LocalizedStringBuilder get earnDetailPageGenericErrorSubTitle =>
      _builder((_) => _.earnDetailPageGenericErrorSubTitle,
          'earnDetailPageGenericErrorSubTitle');

  static LocalizedStringBuilder earnRuleValidDate(
          String fromDate, String toDate) =>
      _builder((_) => _.earnRuleValidDate(fromDate, toDate),
          'earnRuleValidDate($fromDate, $toDate)');

  static LocalizedStringBuilder get earnRuleUnlimitedParticipationInfo =>
      _builder((_) => _.earnRuleUnlimitedParticipationInfo,
          'earnRuleUnlimitedParticipationInfo');

  static LocalizedStringBuilder get earnRuleOnlyOnceParticipationInfo =>
      _builder((_) => _.earnRuleOnlyOnceParticipationInfo,
          'earnRuleOnlyOnceParticipationInfo');

  static LocalizedStringBuilder earnRuleLimitedParticipationInfo(int number) =>
      _builder((_) => _.earnRuleLimitedParticipationInfo(number),
          'earnRuleLimitedParticipationInfo($number)');

  static LocalizedStringBuilder earnRuleLimitedCompletionInfo(
          int number, int total) =>
      _builder((_) => _.earnRuleLimitedCompletionInfo(number, total),
          'earnRuleLimitedCompletionInfo($number, $total)');

  static LocalizedStringBuilder earnRuleUnlimitedCompletionInfo(int number) =>
      _builder((_) => _.earnRuleUnlimitedCompletionInfo(number),
          'earnRuleUnlimitedCompletionInfo($number)');

  static LocalizedStringBuilder get earnRuleRewardBoxTitle =>
      _builder((_) => _.earnRuleRewardBoxTitle, 'earnRuleRewardBoxTitle');

  static LocalizedStringBuilder earnRuleRewardBoxSubTitle(String token) =>
      _builder((_) => _.earnRuleRewardBoxSubTitle(token),
          'earnRuleRewardBoxSubTitle($token)');

  static LocalizedStringBuilder get earnRuleCampaignMissionTitle => _builder(
      (_) => _.earnRuleCampaignMissionTitle, 'earnRuleCampaignMissionTitle');

  static LocalizedStringBuilder get earnRuleCampaignMissionSubtitle => _builder(
      (_) => _.earnRuleCampaignMissionSubtitle,
      'earnRuleCampaignMissionSubtitle');

  static LocalizedStringBuilder get earnRuleConditionCompleted => _builder(
      (_) => _.earnRuleConditionCompleted, 'earnRuleConditionCompleted');

  static LocalizedStringBuilder get earnRuleConditionGetStarted => _builder(
      (_) => _.earnRuleConditionGetStarted, 'earnRuleConditionGetStarted');

  static LocalizedStringBuilder earnRuleCompletionMessage(String token) =>
      _builder((_) => _.earnRuleCompletionMessage(token),
          'earnRuleCompletionMessage($token)');

  static LocalizedStringBuilder get earnRuleViewOtherOffers =>
      _builder((_) => _.earnRuleViewOtherOffers, 'earnRuleViewOtherOffers');

  static LocalizedStringBuilder get earnRuleDetailsHowItWorks =>
      _builder((_) => _.earnRuleDetailsHowItWorks, 'earnRuleDetailsHowItWorks');

  static LocalizedStringBuilder get earnRuleDetailsEarnUponCompletion =>
      _builder((_) => _.earnRuleDetailsEarnUponCompletion,
          'earnRuleDetailsEarnUponCompletion');

  static LocalizedStringBuilder
      get earnRuleDetailsEarnUponCompletionConversionRate => _builder(
          (_) => _.earnRuleDetailsEarnUponCompletionConversionRate,
          'earnRuleDetailsEarnUponCompletionConversionRate');

  static LocalizedStringBuilder get earnRuleDetailsStakingAmountPart1 =>
      _builder((_) => _.earnRuleDetailsStakingAmountPart1,
          'earnRuleDetailsStakingAmountPart1');

  static LocalizedStringBuilder get earnRuleDetailsStakingAmountPart2 =>
      _builder((_) => _.earnRuleDetailsStakingAmountPart2,
          'earnRuleDetailsStakingAmountPart2');

  static LocalizedStringBuilder get earnRuleDetailsParticipationLimit =>
      _builder((_) => _.earnRuleDetailsParticipationLimit,
          'earnRuleDetailsParticipationLimit');

  static LocalizedStringBuilder earnRuleDetailsParticipationCount(
          int participationCount) =>
      _builder((_) => _.earnRuleDetailsParticipationCount(participationCount),
          'earnRuleDetailsParticipationCount($participationCount)');

  static LocalizedStringBuilder get earnRuleDetailsUnlimitedParticipation =>
      _builder((_) => _.earnRuleDetailsUnlimitedParticipation,
          'earnRuleDetailsUnlimitedParticipation');

  static LocalizedStringBuilder get earnRuleDetailsPreviousParticipationPart1 =>
      _builder((_) => _.earnRuleDetailsPreviousParticipationPart1,
          'earnRuleDetailsPreviousParticipationPart1');

  static LocalizedStringBuilder get earnRuleDetailsPreviousParticipationPart2 =>
      _builder((_) => _.earnRuleDetailsPreviousParticipationPart2,
          'earnRuleDetailsPreviousParticipationPart2');

  static LocalizedStringBuilder get earnRuleDetailsPreviousParticipationPart3 =>
      _builder((_) => _.earnRuleDetailsPreviousParticipationPart3,
          'earnRuleDetailsPreviousParticipationPart3');

  static LocalizedStringBuilder get earnRuleDetailsReadMoreButton => _builder(
      (_) => _.earnRuleDetailsReadMoreButton, 'earnRuleDetailsReadMoreButton');

  static LocalizedStringBuilder get earnRuleDetailsOfferUnavailableTitle =>
      _builder((_) => _.earnRuleDetailsOfferUnavailableTitle,
          'earnRuleDetailsOfferUnavailableTitle');

  static LocalizedStringBuilder get earnRuleDetailsViewOffersButton => _builder(
      (_) => _.earnRuleDetailsViewOffersButton,
      'earnRuleDetailsViewOffersButton');

  static LocalizedStringBuilder get earnRuleDetailsLowBalanceErrorPart1 =>
      _builder((_) => _.earnRuleDetailsLowBalanceErrorPart1,
          'earnRuleDetailsLowBalanceErrorPart1');

  static LocalizedStringBuilder get earnRuleDetailsLowBalanceErrorPart2 =>
      _builder((_) => _.earnRuleDetailsLowBalanceErrorPart2,
          'earnRuleDetailsLowBalanceErrorPart2');

  static LocalizedStringBuilder get earnRuleDetailsParticipationLimitError =>
      _builder((_) => _.earnRuleDetailsParticipationLimitError,
          'earnRuleDetailsParticipationLimitError');

//region How it works page

  static LocalizedStringBuilder get earnRuleIndicativeAmountInfoHospitality =>
      _builder((_) => _.earnRuleIndicativeAmountInfoHospitality,
          'earnRuleIndicativeAmountInfoHospitality');

  static LocalizedStringBuilder get earnRuleIndicativeAmountInfoRealEstate =>
      _builder((_) => _.earnRuleIndicativeAmountInfoRealEstate,
          'earnRuleIndicativeAmountInfoRealEstate');

  static LocalizedStringBuilder get earnRuleIndicativeAmountInfoGeneric =>
      _builder((_) => _.earnRuleIndicativeAmountInfoGeneric,
          'earnRuleIndicativeAmountInfoGeneric');

  static LocalizedStringBuilder get stakingDetailsPart1 =>
      _builder((_) => _.stakingDetailsPart1, 'stakingDetailsPart1');

  static LocalizedStringBuilder get stakingDetailsRealEstatePart5 => _builder(
      (_) => _.stakingDetailsRealEstatePart5, 'stakingDetailsRealEstatePart5');

  static LocalizedStringBuilder get stakingDetailsRealEstateStakingRulePart1 =>
      _builder((_) => _.stakingDetailsRealEstateStakingRulePart1,
          'stakingDetailsRealEstateStakingRulePart1');

  static LocalizedStringBuilder
      get stakingDetailsRealEstateStakingRulePart2_100percent => _builder(
          (_) => _.stakingDetailsRealEstateStakingRulePart2_100percent,
          'stakingDetailsRealEstateStakingRulePart2_100percent');

  static LocalizedStringBuilder stakingDetailsRealEstateBurningRulePart1(
          String time) =>
      _builder((_) => _.stakingDetailsRealEstateBurningRulePart1(time),
          'stakingDetailsRealEstateBurningRulePart1($time)');

  static LocalizedStringBuilder get stakingDetailsRealEstateBurningRulePart2 =>
      _builder((_) => _.stakingDetailsRealEstateBurningRulePart2,
          'stakingDetailsRealEstateBurningRulePart2');

  static LocalizedStringBuilder get stakingDetailsLockedAmount => _builder(
      (_) => _.stakingDetailsLockedAmount, 'stakingDetailsLockedAmount');

  static LocalizedStringBuilder get stakingDetailsReward =>
      _builder((_) => _.stakingDetailsReward, 'stakingDetailsReward');

//endregion How it works page

//endregion Earn Detail Page

//region Common texts

  static LocalizedStringBuilder get copiedToClipboard =>
      _builder((_) => _.copiedToClipboard, 'copiedToClipboard');

  static LocalizedStringBuilder amountTokens(int amount, String token) =>
      _builder((_) => _.amountTokens(amount, token),
          'amountTokens($amount, $token)');

//endregion Common texts

//region Bottom bar texts

  static LocalizedStringBuilder get bottomBarExplore =>
      _builder((_) => _.bottomBarExplore, 'bottomBarExplore');

  static LocalizedStringBuilder get bottomBarOffers =>
      _builder((_) => _.bottomBarOffers, 'bottomBarOffers');

  static LocalizedStringBuilder get bottomBarWallet =>
      _builder((_) => _.bottomBarWallet, 'bottomBarWallet');

  static LocalizedStringBuilder get bottomBarSocial =>
      _builder((_) => _.bottomBarSocial, 'bottomBarSocial');

//endregion Bottom bar texts

//region Maintenance
  static LocalizedStringBuilder get maintenanceTitle =>
      _builder((_) => _.maintenanceTitle, 'maintenanceTitle');

  static LocalizedStringBuilder maintenanceDescription(String period) =>
      _builder((_) => _.maintenanceDescription(period),
          'maintenanceDescription($period)');

  static LocalizedStringBuilder get maintenanceErrorMessage =>
      _builder((_) => _.maintenanceErrorMessage, 'maintenanceErrorMessage');

  static LocalizedStringBuilder get maintenanceErrorCoupleOfHours => _builder(
      (_) => _.maintenanceErrorCoupleOfHours, 'maintenanceErrorCoupleOfHours');

  static LocalizedStringBuilder hours(int hours) =>
      _builder((_) => _.hours(hours), 'hours($hours)');

//endregion Maintenance

//region Payment Request Page

  static LocalizedStringBuilder get transferRequestTitle =>
      _builder((_) => _.transferRequestTitle, 'transferRequestTitle');

  static LocalizedStringBuilder transferRequestIdHolder(String id) => _builder(
      (_) => _.transferRequestIdHolder(id), 'transferRequestIdHolder($id)');

  static LocalizedStringBuilder transferRequestInfoHolder(
          String transferRequestOrganization) =>
      _builder((_) => _.transferRequestInfoHolder(transferRequestOrganization),
          'transferRequestInfoHolder($transferRequestOrganization)');

  static LocalizedStringBuilder get transferRequestTotalBillLabel => _builder(
      (_) => _.transferRequestTotalBillLabel, 'transferRequestTotalBillLabel');

  static LocalizedStringBuilder transferRequestTotalBillHolder(
    String amountTokens,
    String token,
    String amountCurrency,
    String currencyCode,
  ) =>
      _builder(
          (_) => _.transferRequestTotalBillHolder(
              amountTokens, token, amountCurrency, currencyCode),
          'transferRequestTotalBillHolder($amountTokens, $token, $amountCurrency, $currencyCode)'); // ignore: lines_longer_than_80_chars

  static LocalizedStringBuilder get transferRequestWalletBalanceLabel =>
      _builder((_) => _.transferRequestWalletBalanceLabel,
          'transferRequestWalletBalanceLabel');

  static LocalizedStringBuilder amountTokensHolder(
          String amount, String token) =>
      _builder((_) => _.amountTokensHolder(amount, token),
          'amountTokensHolder($amount, $token)');

  static LocalizedStringBuilder get transferRequestRecipientLabel => _builder(
      (_) => _.transferRequestRecipientLabel, 'transferRequestRecipientLabel');

  static LocalizedStringBuilder get transferRequestRemainingTimeLabel =>
      _builder((_) => _.transferRequestRemainingTimeLabel,
          'transferRequestRemainingTimeLabel');

  static LocalizedStringBuilder expirationFormatDays(int days) => _builder(
      (_) => _.expirationFormatDays(days), 'expirationFormatDays($days)');

  static LocalizedStringBuilder transferRequestSendingAmountLabel(
          String token) =>
      _builder((_) => _.transferRequestSendingAmountLabel(token),
          'transferRequestSendingAmountLabel($token)');

  static LocalizedStringBuilder transferRequestAmountExceedsRequestedError(
          String requestedAmount) =>
      _builder(
          (_) => _.transferRequestAmountExceedsRequestedError(requestedAmount),
          'transferRequestAmountExceedsRequestedError($requestedAmount)');

  static LocalizedStringBuilder get transferRequestGenericError => _builder(
      (_) => _.transferRequestGenericError, 'transferRequestGenericError');

  static LocalizedStringBuilder get transferRequestAmountIsZeroError =>
      _builder((_) => _.transferRequestAmountIsZeroError,
          'transferRequestAmountIsZeroError');

  static LocalizedStringBuilder get transferRequestNotEnoughTokensError =>
      _builder((_) => _.transferRequestNotEnoughTokensError,
          'transferRequestNotEnoughTokensError');

  static LocalizedStringBuilder get transferRequestInvalidStateError =>
      _builder((_) => _.transferRequestInvalidStateError,
          'transferRequestInvalidStateError');

  static LocalizedStringBuilder get transferRequestRejectButton => _builder(
      (_) => _.transferRequestRejectButton, 'transferRequestRejectButton');

  static LocalizedStringBuilder get transferRequestRejectDialogText => _builder(
      (_) => _.transferRequestRejectDialogText,
      'transferRequestRejectDialogText');

  static LocalizedStringBuilder get transferRequestSuccessTitle => _builder(
      (_) => _.transferRequestSuccessTitle, 'transferRequestSuccessTitle');

  static LocalizedStringBuilder get transferRequestSuccessDetails => _builder(
      (_) => _.transferRequestSuccessDetails, 'transferRequestSuccessDetails');

//endregion Payment Request Page

//region Transfer Request Expired Page

  static LocalizedStringBuilder get transferRequestExpiredTitle => _builder(
      (_) => _.transferRequestExpiredTitle, 'transferRequestExpiredTitle');

  static LocalizedStringBuilder get transferRequestExpiredDetails => _builder(
      (_) => _.transferRequestExpiredDetails, 'transferRequestExpiredDetails');

//endregion Transfer Request Expired Page

//region Payment Request List Page
  static LocalizedStringBuilder get transferRequestListPageTitle => _builder(
      (_) => _.transferRequestListPageTitle, 'transferRequestListPageTitle');

  static LocalizedStringBuilder get transferRequestListGenericError => _builder(
      (_) => _.transferRequestListGenericError,
      'transferRequestListGenericError');

//endregion Payment Request List Page

//region PaymentRequestStatusCard

  static LocalizedStringBuilder get transferRequestStatusCardRecipientLabel =>
      _builder((_) => _.transferRequestStatusCardRecipientLabel,
          'transferRequestStatusCardRecipientLabel');

  static LocalizedStringBuilder
      get transferRequestStatusCardSendingAmountLabel => _builder(
          (_) => _.transferRequestStatusCardSendingAmountLabel,
          'transferRequestStatusCardSendingAmountLabel');

  static LocalizedStringBuilder get transferRequestStatusCardTotalBillLabel =>
      _builder((_) => _.transferRequestStatusCardTotalBillLabel,
          'transferRequestStatusCardTotalBillLabel');

  static LocalizedStringBuilder transferRequestStatusCardRecipientIdLabel(
          String recipientId) =>
      _builder((_) => _.transferRequestStatusCardRecipientIdLabel(recipientId),
          'transferRequestStatusCardRecipientIdLabel($recipientId)');

  static LocalizedStringBuilder get transferRequestStatusCardStatusCancelled =>
      _builder((_) => _.transferRequestStatusCardStatusCancelled,
          'transferRequestStatusCardStatusCancelled');

  static LocalizedStringBuilder get transferRequestStatusCardStatusCompleted =>
      _builder((_) => _.transferRequestStatusCardStatusCompleted,
          'transferRequestStatusCardStatusCompleted');

  static LocalizedStringBuilder get transferRequestStatusCardStatusExpired =>
      _builder((_) => _.transferRequestStatusCardStatusExpired,
          'transferRequestStatusCardStatusExpired');

  static LocalizedStringBuilder get transferRequestStatusCardStatusFailed =>
      _builder((_) => _.transferRequestStatusCardStatusFailed,
          'transferRequestStatusCardStatusFailed');

  static LocalizedStringBuilder get transferRequestStatusCardStatusPending =>
      _builder((_) => _.transferRequestStatusCardStatusPending,
          'transferRequestStatusCardStatusPending');

  static LocalizedStringBuilder get transferRequestStatusCardStatusConfirmed =>
      _builder((_) => _.transferRequestStatusCardStatusConfirmed,
          'transferRequestStatusCardStatusConfirmed');

  static LocalizedStringBuilder get transferRequestOngoingTab =>
      _builder((_) => _.transferRequestOngoingTab, 'transferRequestOngoingTab');

  static LocalizedStringBuilder get transferRequestCompletedTab => _builder(
      (_) => _.transferRequestCompletedTab, 'transferRequestCompletedTab');

  static LocalizedStringBuilder get transferRequestUnsuccessfulTab => _builder(
      (_) => _.transferRequestUnsuccessfulTab,
      'transferRequestUnsuccessfulTab');

  static LocalizedStringBuilder get transferRequestEmptyOngoing => _builder(
      (_) => _.transferRequestEmptyOngoing, 'transferRequestEmptyOngoing');

  static LocalizedStringBuilder get transferRequestEmptyCompleted => _builder(
      (_) => _.transferRequestEmptyCompleted, 'transferRequestEmptyCompleted');

  static LocalizedStringBuilder get transferRequestEmptyUnsuccessful =>
      _builder((_) => _.transferRequestEmptyUnsuccessful,
          'transferRequestEmptyUnsuccessful');

//endregion PaymentRequestStatusCard

//region Hotel Pre Checkout Dialog

  static LocalizedStringBuilder get hotelPreCheckoutDialogHeading => _builder(
      (_) => _.hotelPreCheckoutDialogHeading, 'hotelPreCheckoutDialogHeading');

  static LocalizedStringBuilder get hotelPreCheckoutDialogViewInvoiceButton =>
      _builder((_) => _.hotelPreCheckoutDialogViewInvoiceButton,
          'hotelPreCheckoutDialogViewInvoiceButton');

//endregion Hotel Pre Checkout Dialog

//region Biometric Authentication
  static LocalizedStringBuilder get biometricAuthenticationDialogTitleAndroid =>
      _builder((_) => _.biometricAuthenticationDialogTitleAndroid,
          'biometricAuthenticationDialogTitleAndroid');

  static LocalizedStringBuilder
      get biometricAuthenticationDialogMessageAndroid => _builder(
          (_) => _.biometricAuthenticationDialogMessageAndroid,
          'biometricAuthenticationDialogMessageAndroid');

  static LocalizedStringBuilder get biometricAuthenticationDialogTitleIOS =>
      _builder((_) => _.biometricAuthenticationDialogTitleIOS,
          'biometricAuthenticationDialogTitleIOS');

  static LocalizedStringBuilder get biometricAuthenticationDialogMessageIOS =>
      _builder((_) => _.biometricAuthenticationDialogMessageIOS,
          'biometricAuthenticationDialogMessageIOS');

  static LocalizedStringBuilder get biometricAuthenticationPromptTitle =>
      _builder((_) => _.biometricAuthenticationPromptTitle,
          'biometricAuthenticationPromptTitle');

  static LocalizedStringBuilder get biometricAuthenticationPromptMessage =>
      _builder((_) => _.biometricAuthenticationPromptMessage,
          'biometricAuthenticationPromptMessage');

  static LocalizedStringBuilder get biometricsGoToSettingsDescription =>
      _builder((_) => _.biometricsGoToSettingsDescription,
          'biometricsGoToSettingsDescription');

// ignore: lines_longer_than_80_chars

//endregion Biometric Authentication

//region Scanned Info Dialog

  static LocalizedStringBuilder get scannedInfoDialogTitle =>
      _builder((_) => _.scannedInfoDialogTitle, 'scannedInfoDialogTitle');

  static LocalizedStringBuilder get scannedInfoDialogErrorMessage => _builder(
      (_) => _.scannedInfoDialogErrorMessage, 'scannedInfoDialogErrorMessage');

  static LocalizedStringBuilder get scannedInfoDialogPositiveButton => _builder(
      (_) => _.scannedInfoDialogPositiveButton,
      'scannedInfoDialogPositiveButton');

  static LocalizedStringBuilder get scannedInfoDialogNegativeButton => _builder(
      (_) => _.scannedInfoDialogNegativeButton,
      'scannedInfoDialogNegativeButton');

  static LocalizedStringBuilder scannedInfoDialogEmailPositiveButton(
          String token) =>
      _builder((_) => _.scannedInfoDialogEmailPositiveButton(token),
          'scannedInfoDialogEmailPositiveButton($token)');

//endregion Scanned Info Dialog

//region conversion Rate

  static LocalizedStringBuilder conversionRate(
          String currencyCode, String amount) =>
      _builder((_) => _.conversionRate(currencyCode, amount),
          'conversionRate($currencyCode, $amount)');

  static LocalizedStringBuilder noTokensConversionRateText(String token) =>
      _builder((_) => _.noTokensConversionRateText(token),
          'noTokensConversionRateText($token)');

//endregion Wallet Conversion Rate

// region Personal Detail Page

  static LocalizedStringBuilder get personalDetailsFirstNameTitle => _builder(
      (_) => _.personalDetailsFirstNameTitle, 'personalDetailsFirstNameTitle');

  static LocalizedStringBuilder get personalDetailsLastNameTitle => _builder(
      (_) => _.personalDetailsLastNameTitle, 'personalDetailsLastNameTitle');

  static LocalizedStringBuilder get personalDetailsEmailTitle =>
      _builder((_) => _.personalDetailsEmailTitle, 'personalDetailsEmailTitle');

  static LocalizedStringBuilder get personalDetailsPhoneNumberTitle => _builder(
      (_) => _.personalDetailsPhoneNumberTitle,
      'personalDetailsPhoneNumberTitle');

  static LocalizedStringBuilder get personalDetailsCountryOfNationality =>
      _builder((_) => _.personalDetailsCountryOfNationality,
          'personalDetailsCountryOfNationality');

  static LocalizedStringBuilder get personalDetailsDeleteAccountButton =>
      _builder((_) => _.personalDetailsDeleteAccountButton,
          'personalDetailsDeleteAccountButton');

  static LocalizedStringBuilder get personalDetailsGenericError => _builder(
      (_) => _.personalDetailsGenericError, 'personalDetailsGenericError');

// endregion Personal Detail Page

//region Email Verification
  static LocalizedStringBuilder get emailVerificationTitle =>
      _builder((_) => _.emailVerificationTitle, 'emailVerificationTitle');

  static LocalizedStringBuilder get emailVerificationMessage1 =>
      _builder((_) => _.emailVerificationMessage1, 'emailVerificationMessage1');

  static LocalizedStringBuilder get emailVerificationMessage1Resent => _builder(
      (_) => _.emailVerificationMessage1Resent,
      'emailVerificationMessage1Resent');

  static LocalizedStringBuilder get emailVerificationMessage2 =>
      _builder((_) => _.emailVerificationMessage2, 'emailVerificationMessage2');

  static LocalizedStringBuilder get emailVerificationResetText => _builder(
      (_) => _.emailVerificationResetText, 'emailVerificationResetText');

  static LocalizedStringBuilder get registerWithAnotherAccountButton =>
      _builder((_) => _.registerWithAnotherAccountButton,
          'registerWithAnotherAccountButton');

  static LocalizedStringBuilder get emailVerificationButton =>
      _builder((_) => _.emailVerificationButton, 'emailVerificationButton');

  static LocalizedStringBuilder get emailVerificationExceededMaxAttemptsError =>
      _builder((_) => _.emailVerificationExceededMaxAttemptsError,
          'emailVerificationExceededMaxAttemptsError');

  static LocalizedStringBuilder emailVerificationLinkExpired(String email) =>
      _builder((_) => _.emailVerificationLinkExpired(email),
          'emailVerificationLinkExpired($email)');

//endregion Email Verification

//region Email Verification Success Page
  static LocalizedStringBuilder get emailVerificationSuccessTitle => _builder(
      (_) => _.emailVerificationSuccessTitle, 'emailVerificationSuccessTitle');

  static LocalizedStringBuilder get emailVerificationSuccessDetails => _builder(
      (_) => _.emailVerificationSuccessDetails,
      'emailVerificationSuccessDetails');

//endregion Email Verification Success Page

//region Previous Referrals

  static LocalizedStringBuilder get previousReferralsCardTypeRealEstate =>
      _builder((_) => _.previousReferralsCardTypeRealEstate,
          'previousReferralsCardTypeRealEstate');

  static LocalizedStringBuilder get previousReferralsCardTypeHospitality =>
      _builder((_) => _.previousReferralsCardTypeHospitality,
          'previousReferralsCardTypeHospitality');

  static LocalizedStringBuilder get previousReferralsCardTypeAppReferral =>
      _builder((_) => _.previousReferralsCardTypeAppReferral,
          'previousReferralsCardTypeAppReferral');

  static LocalizedStringBuilder get previousReferralsCardAward => _builder(
      (_) => _.previousReferralsCardAward, 'previousReferralsCardAward');

  static LocalizedStringBuilder get previousReferralsCardTimeLeftToAccept =>
      _builder((_) => _.previousReferralsCardTimeLeftToAccept,
          'previousReferralsCardTimeLeftToAccept');

  static LocalizedStringBuilder get previousReferralsCardRemaining => _builder(
      (_) => _.previousReferralsCardRemaining,
      'previousReferralsCardRemaining');

  static LocalizedStringBuilder get previousReferralsCardDontLose => _builder(
      (_) => _.previousReferralsCardDontLose, 'previousReferralsCardDontLose');

  static LocalizedStringBuilder previousReferralsCardContact(String person) =>
      _builder((_) => _.previousReferralsCardContact(person),
          'previousReferralsCardContact($person)');

  static LocalizedStringBuilder previousReferralsNameHolder(
          String firstName, String lastName) =>
      _builder((_) => _.previousReferralsNameHolder(firstName, lastName),
          'previousReferralsNameHolder($firstName, $lastName)');

//endregion Previous Referrals

//region Common Date

  static LocalizedStringBuilder get dateTimeToday =>
      _builder((_) => _.dateTimeToday, 'dateTimeToday');

  static LocalizedStringBuilder get dateTimeYesterday =>
      _builder((_) => _.dateTimeYesterday, 'dateTimeYesterday');

//endregion Common Date

//region Partners

  static LocalizedStringBuilder multiplePartnersTitle(
          String firstPartnerName, int numberOfPartner) =>
      _builder(
          (_) => _.multiplePartnersTitle(firstPartnerName, numberOfPartner),
          'multiplePartnersTitle($firstPartnerName, $numberOfPartner)');

  static LocalizedStringBuilder get viewPartnerDetailsButtonTitle => _builder(
      (_) => _.viewPartnerDetailsButtonTitle, 'viewPartnerDetailsButtonTitle');

  static LocalizedStringBuilder get partnerDetailsPageTitle =>
      _builder((_) => _.partnerDetailsPageTitle, 'partnerDetailsPageTitle');

//endregion Partners

//region App Upgrade

  static LocalizedStringBuilder get nonMandatoryAppUpgradeDialogTitle =>
      _builder((_) => _.nonMandatoryAppUpgradeDialogTitle,
          'nonMandatoryAppUpgradeDialogTitle');

  static LocalizedStringBuilder get nonMandatoryAppUpgradeDialogContent =>
      _builder((_) => _.nonMandatoryAppUpgradeDialogContent,
          'nonMandatoryAppUpgradeDialogContent');

  static LocalizedStringBuilder
      get nonMandatoryAppUpgradeDialogPositiveButton => _builder(
          (_) => _.nonMandatoryAppUpgradeDialogPositiveButton,
          'nonMandatoryAppUpgradeDialogPositiveButton');

  static LocalizedStringBuilder
      get nonMandatoryAppUpgradeDialogNegativeButton => _builder(
          (_) => _.nonMandatoryAppUpgradeDialogNegativeButton,
          'nonMandatoryAppUpgradeDialogNegativeButton');

  static LocalizedStringBuilder get mandatoryAppUpgradePageTitle => _builder(
      (_) => _.mandatoryAppUpgradePageTitle, 'mandatoryAppUpgradePageTitle');

  static LocalizedStringBuilder get mandatoryAppUpgradePageContent => _builder(
      (_) => _.mandatoryAppUpgradePageContent,
      'mandatoryAppUpgradePageContent');

  static LocalizedStringBuilder get mandatoryAppUpgradePageButton => _builder(
      (_) => _.mandatoryAppUpgradePageButton, 'mandatoryAppUpgradePageContent');

//endregion App Upgrade

//region Privacy policy and Terms of Use

  static LocalizedStringBuilder get termsOfUse =>
      _builder((_) => _.termsOfUse, 'termsOfUse');

  static LocalizedStringBuilder get privacyPolicy =>
      _builder((_) => _.privacyPolicy, 'privacyPolicy');

  static LocalizedStringBuilder get and => _builder((_) => _.and, 'and');

//endregion Privacy policy

//region Common texts

  static LocalizedStringBuilder get transferInProgress =>
      _builder((_) => _.transferInProgress, 'transferInProgress');

  static LocalizedStringBuilder get goToWallet =>
      _builder((_) => _.goToWallet, 'goToWallet');

  static LocalizedStringBuilder transferInProgressDetails(String token) =>
      _builder((_) => _.transferInProgressDetails(token),
          'transferInProgressDetails($token)');

//endregion Common texts

//region Service errors

  static LocalizedStringBuilder get customerBlockedError =>
      _builder((_) => _.customerBlockedError, 'customerBlockedError');

  static LocalizedStringBuilder get customerDoesNotExistError =>
      _builder((_) => _.customerDoesNotExistError, 'customerDoesNotExistError');

  static LocalizedStringBuilder get customerPhoneIsMissingError => _builder(
      (_) => _.customerPhoneIsMissingError, 'customerPhoneIsMissingError');

  static LocalizedStringBuilder get customerProfileDoesNotExistError =>
      _builder((_) => _.customerProfileDoesNotExistError,
          'customerProfileDoesNotExistError');

  static LocalizedStringBuilder get customerWalletBlockedError => _builder(
      (_) => _.customerWalletBlockedError, 'customerWalletBlockedError');

  static LocalizedStringBuilder get emailIsAlreadyVerifiedError => _builder(
      (_) => _.emailIsAlreadyVerifiedError, 'emailIsAlreadyVerifiedError');

  static LocalizedStringBuilder get invalidAmountError =>
      _builder((_) => _.invalidAmountError, 'invalidAmountError');

  static LocalizedStringBuilder get invalidCredentialsError =>
      _builder((_) => _.invalidCredentialsError, 'invalidCredentialsError');

  static LocalizedStringBuilder get invalidEmailFormatError =>
      _builder((_) => _.invalidEmailFormatError, 'invalidEmailFormatError');

  static LocalizedStringBuilder get invalidPasswordFormatError => _builder(
      (_) => _.invalidPasswordFormatError, 'invalidPasswordFormatError');

  static LocalizedStringBuilder get invalidPrivateAddressError => _builder(
      (_) => _.invalidPrivateAddressError, 'invalidPrivateAddressError');

  static LocalizedStringBuilder get invalidPublicAddressError =>
      _builder((_) => _.invalidPublicAddressError, 'invalidPublicAddressError');

  static LocalizedStringBuilder get invalidSignatureError =>
      _builder((_) => _.invalidSignatureError, 'invalidSignatureError');

  static LocalizedStringBuilder get invalidWalletLinkSignatureError => _builder(
      (_) => _.invalidWalletLinkSignatureError,
      'invalidWalletLinkSignatureError');

  static LocalizedStringBuilder get linkingRequestAlreadyApprovedError =>
      _builder((_) => _.linkingRequestAlreadyApprovedError,
          'linkingRequestAlreadyApprovedError');

  static LocalizedStringBuilder get linkingRequestAlreadyExistsError =>
      _builder((_) => _.linkingRequestAlreadyExistsError,
          'linkingRequestAlreadyExistsError');

  static LocalizedStringBuilder get linkingRequestDoesNotExistError => _builder(
      (_) => _.linkingRequestDoesNotExistError,
      'linkingRequestDoesNotExistError');

  static LocalizedStringBuilder get loginAlreadyInUseError =>
      _builder((_) => _.loginAlreadyInUseError, 'loginAlreadyInUseError');

  static LocalizedStringBuilder get noCustomerWithSuchEmailError => _builder(
      (_) => _.noCustomerWithSuchEmailError, 'noCustomerWithSuchEmailError');

  static LocalizedStringBuilder notEnoughTokensError(String token) => _builder(
      (_) => _.notEnoughTokensError(token), 'notEnoughTokensError($token)');

  static LocalizedStringBuilder get paymentDoesNotExistError =>
      _builder((_) => _.paymentDoesNotExistError, 'paymentDoesNotExistError');

  static LocalizedStringBuilder
      get paymentIsNotInACorrectStatusToBeUpdatedError => _builder(
          (_) => _.paymentIsNotInACorrectStatusToBeUpdatedError,
          'paymentIsNotInACorrectStatusToBeUpdatedError');

  static LocalizedStringBuilder get paymentRequestsIsForAnotherCustomerError =>
      _builder((_) => _.paymentRequestsIsForAnotherCustomerError,
          'paymentRequestsIsForAnotherCustomerError');

  static LocalizedStringBuilder get phoneAlreadyExistsError =>
      _builder((_) => _.phoneAlreadyExistsError, 'phoneAlreadyExistsError');

  static LocalizedStringBuilder get phoneIsAlreadyVerifiedError => _builder(
      (_) => _.phoneIsAlreadyVerifiedError, 'phoneIsAlreadyVerifiedError');

  static LocalizedStringBuilder get referralAlreadyConfirmedError => _builder(
      (_) => _.referralAlreadyConfirmedError, 'referralAlreadyConfirmedError');

  static LocalizedStringBuilder get referralAlreadyExistError =>
      _builder((_) => _.referralAlreadyExistError, 'referralAlreadyExistError');

  static LocalizedStringBuilder get referralNotFoundError =>
      _builder((_) => _.referralNotFoundError, 'referralNotFoundError');

  static LocalizedStringBuilder get referralsLimitExceededError => _builder(
      (_) => _.referralsLimitExceededError, 'referralsLimitExceededError');

  static LocalizedStringBuilder get senderCustomerNotFoundError => _builder(
      (_) => _.senderCustomerNotFoundError, 'senderCustomerNotFoundError');

  static LocalizedStringBuilder get targetCustomerNotFoundError => _builder(
      (_) => _.targetCustomerNotFoundError, 'targetCustomerNotFoundError');

  static LocalizedStringBuilder get tooManyLoginRequestError =>
      _builder((_) => _.tooManyLoginRequestError, 'tooManyLoginRequestError');

  static LocalizedStringBuilder
      get transferSourceAndTargetMustBeDifferentError => _builder(
          (_) => _.transferSourceAndTargetMustBeDifferentError,
          'transferSourceAndTargetMustBeDifferentError');

  static LocalizedStringBuilder get transferSourceCustomerWalletBlockedError =>
      _builder((_) => _.transferSourceCustomerWalletBlockedError,
          'transferSourceCustomerWalletBlockedError');

  static LocalizedStringBuilder get transferTargetCustomerWalletBlockedError =>
      _builder((_) => _.transferTargetCustomerWalletBlockedError,
          'transferTargetCustomerWalletBlockedError');

  static LocalizedStringBuilder get verificationCodeDoesNotExistError =>
      _builder((_) => _.verificationCodeDoesNotExistError,
          'verificationCodeDoesNotExistError');

  static LocalizedStringBuilder get verificationCodeExpiredError => _builder(
      (_) => _.verificationCodeExpiredError, 'verificationCodeExpiredError');

  static LocalizedStringBuilder get verificationCodeMismatchError => _builder(
      (_) => _.verificationCodeMismatchError, 'verificationCodeMismatchError');

//endregion Service errors

//region Friend Referral
  static LocalizedStringBuilder get inviteAFriend =>
      _builder((_) => _.inviteAFriend, 'networkErrorTiinviteAFriendtle');

  static LocalizedStringBuilder get inviteAFriendPageDetails =>
      _builder((_) => _.inviteAFriendPageDetails, 'inviteAFriendPageDetails');

  static LocalizedStringBuilder get friendReferralSuccessDetails => _builder(
      (_) => _.friendReferralSuccessDetails, 'friendReferralSuccessDetails');

//endregion Friend Referral

//region Vouchers

  static LocalizedStringBuilder get voucherListEmpty =>
      _builder((_) => _.voucherListEmpty, 'voucherListEmpty');

  static LocalizedStringBuilder get voucherCopied =>
      _builder((_) => _.voucherCopied, 'voucherCopied');

//endregion Vouchers

//region Notifications
  static LocalizedStringBuilder get notifications =>
      _builder((_) => _.notifications, 'notifications');

  static LocalizedStringBuilder get notificationListEmpty =>
      _builder((_) => _.notificationListEmpty, 'notificationListEmpty');

  static LocalizedStringBuilder minutesAgo(int minutes) =>
      _builder((_) => _.minutesAgo(minutes), 'minutesAgo');

  static LocalizedStringBuilder hoursAgo(int hours) =>
      _builder((_) => _.hoursAgo(hours), 'hoursAgo($hours)');

  static LocalizedStringBuilder daysAgo(int days) =>
      _builder((_) => _.daysAgo(days), 'daysAgo($days)');

  static LocalizedStringBuilder get notificationListMarkAllAsRead => _builder(
      (_) => _.notificationListMarkAllAsRead, 'notificationListMarkAllAsRead');

  static LocalizedStringBuilder get newHeader =>
      _builder((_) => _.newHeader, 'newHeader');

  static LocalizedStringBuilder get earlierHeader =>
      _builder((_) => _.earlierHeader, 'earlierHeader');

  static LocalizedStringBuilder
      get notificationListRequestGenericErrorSubtitle => _builder(
          (_) => _.notificationListRequestGenericErrorSubtitle,
          'notificationListRequestGenericErrorSubtitle');

//endregion Notifications

//region Email prefilling
  static LocalizedStringBuilder get emailSubject =>
      _builder((_) => _.emailSubject, 'emailSubject');

  static LocalizedStringBuilder get emailBody =>
      _builder((_) => _.emailBody, 'emailBody');

//endregion Email prefilling
}
