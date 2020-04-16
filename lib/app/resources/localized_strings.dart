import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

//region Guide
// !!! If you update this file, please run one of the
// 'update_english_localisations' scripts.
// Ground rules:
// 1. If the message doesn't have parameters, make it a getter('get' syntax)
// 2. The 'name' parameter passed to the Intl method is always the same as the
// methods/getters name
// 3. After you update this file, please run one of the
// 'update_english_localisations' scripts.
//
// Examples:
////////////////////////////////////////
// 1. Simple message, no parameters
// ---------------------
//  static String get simpleMessage =>
//    Intl.message('Some simple localised message',
//        name: 'simpleMessage',
//        desc: 'Additional description of the context in which this message '
//            'is going to be used');
//
// ---------------------
////////////////////////////////////////
// 2. Message with parameters
// ---------------------
//  static String greetingMessage(String name) =>
//    Intl.message('Hello $name!',
//      name: 'greetingMessage',
//      args: [name], // <- add all your method params here
//      desc: 'Greet the user as they first open the application',
//      examples: const {'name': 'Emily'});
//
// ---------------------
////////////////////////////////////////
// 3. Pluralized message
// ---------------------
//  static String remainingEmailsMessage(int howMany, String userName) =>
//    Intl.plural(howMany,
//        zero: 'There are no emails left for $userName.',
//        one: 'There is $howMany email left for $userName.',
//        other: 'There are $howMany emails left for $userName.',
//        name: 'remainingEmailsMessage',
//        args: [howMany, userName],
//        desc: 'How many emails remain after archiving.',
//        examples: const {'howMany': 42, 'userName': 'Fred'});
//
// ---------------------
////////////////////////////////////////
// 4. Genderised message
// ---------------------
//  static String notOnlineMessage(String userName, String userGender) =>
//    Intl.gender(userGender,
//        male: '$userName is unavailable because he is not online.',
//        female: '$userName is unavailable because she is not online.',
//        other: '$userName is unavailable because they are not online',
//        name: 'notOnlineMessage',
//        args: [userName, userGender],
//        desc: 'The user is not available to hangout.',
//        examples: const {'userGender': 'female', 'userName': 'Alice'});
//
// ---------------------
////////////////////////////////////////
//endregion
class LocalizedStrings {
  static Future<void> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
    });
  }

//region Common API errors
  static String get networkErrorTitle =>
      Intl.message('Let\'s sort this connection problem out',
          name: 'networkErrorTitle');

  static String get networkError => Intl.message(
      'It seems you\'re not connected to the internet. '
      'Please check your connection and try again.',
      name: 'networkError');

  static String genericError(String serviceNumber) => Intl.message(
        'Oops! It looks like something went wrong. Please try again. '
        'If the issue continues, contact our friendly '
        'customer service on $serviceNumber',
        args: [serviceNumber],
        name: 'genericError',
        examples: const {'serviceNumber': '+00 0000 000000'},
      );

  static String get defaultGenericError => Intl.message(
      'Oops! It looks like something went wrong. '
      'Please try again.',
      name: 'defaultGenericError');

  static String get genericErrorShort =>
      Intl.message('Please try again.', name: 'genericErrorShort');

  static String get somethingIsNotRightError =>
      Intl.message('Something is not right, give it another go!',
          name: 'somethingIsNotRightError');

  static String get couldNotLoadBalanceError => Intl.message(
      'We are unable to make transactions at this point as we '
      'could not load your balance',
      name: 'couldNotLoadBalanceError');

// endregion Common API errors

// region Customer API errors

  static String get referralLeadAlreadyExistError => Intl.message(
      'Looks like this lovely person is already in our system, '
      'try referring someone else',
      name: 'referralLeadAlreadyExistError');

  static String get referralLeadAlreadyConfirmedError => Intl.message(
      'This person has already been referred to Real Estate. '
      'Your referral cannot be submitted.',
      name: 'referralLeadAlreadyConfirmedError');

  static String get canNotReferYourselfError => Intl.message(
      'Self-referral is not possible. Your referral cannot be submitted.',
      name: 'canNotReferYourselfError');

  static String get cannotGetOffersError => Intl.message(
        'Sorry, we are unable to show any offers at this moment, '
        'please try again',
        name: 'cannotGetOffersError',
      );

  static String get noVouchersInStockError =>
      Intl.message('Sorry, there are no vouchers in stock',
          name: 'noVouchersInStockError');

// endregion Customer API errors
//region Common Form Elements

  static String feeLabel(String fee) => Intl.message(
        'Fee: $fee',
        name: 'feeLabel',
        args: [fee],
      );

  static String transferTokenAmountLabel(String token) => Intl.message(
        'Transfer amount ($token)',
        name: 'transferTokenAmountLabel',
        args: [token],
      );

  static String get emailRequiredLabel =>
      Intl.message('Email*', name: 'emailRequiredLabel');

  static String get emailAddressHint => Intl.message(
        'Enter email address',
        name: 'emailAddressHint',
      );

  static String get enterAmountHint => Intl.message(
        'Enter amount',
        name: 'enterAmountHint',
      );

  static String get firstNameRequiredLabel =>
      Intl.message('First name*', name: 'firstNameRequiredLabel');

  static String get firstNameNotRequiredLabel =>
      Intl.message('First name', name: 'firstNameNotRequiredLabel');

  static String get firstNameHint =>
      Intl.message('Enter first name', name: 'firstNameHint');

  static String get lastNameRequiredLabel =>
      Intl.message('Last name*', name: 'lastNameRequiredLabel');

  static String get lastNameNotRequiredLabel =>
      Intl.message('Last name', name: 'lastNameNotRequiredLabel');

  static String get lastNameHint =>
      Intl.message('Enter last name', name: 'lastNameHint');

  static String get passwordRequiredLabel =>
      Intl.message('Password*', name: 'passwordRequiredLabel');

  static String get passwordHint =>
      Intl.message('Enter password', name: 'passwordHint');

  static String get phoneNumberLabel =>
      Intl.message('Phone Number', name: 'phoneNumberLabel');

  static String get phoneNumberRequiredLabel =>
      Intl.message('Phone Number*', name: 'phoneNumberRequiredLabel');

  static String get phoneNumberHint =>
      Intl.message('Enter phone number', name: 'phoneNumberHint');

  static String get noteLabel => Intl.message('Notes', name: 'noteLabel');

  static String get noteHint =>
      Intl.message('Add additional notes', name: 'noteHint');

  static String get nationalityLabel =>
      Intl.message('Nationality', name: 'nationalityLabel');

  static String get nationalityOptionalLabel =>
      Intl.message('Nationality (optional)', name: 'nationalityOptionalLabel');

  static String get nationalityHint =>
      Intl.message('Enter nationality', name: 'nationalityHint');

//endregion Common Form Elements

// region Common client side validation errors

  static String get emptyEmailClientSideValidationError =>
      Intl.message('Email is required',
          name: 'emptyEmailClientSideValidationError');

  static String get invalidEmailClientSideValidationError =>
      Intl.message('Please enter a valid email',
          name: 'invalidEmailClientSideValidationError');

  static String get emptyNameClientSideValidationError =>
      Intl.message('Name is required',
          name: 'emptyNameClientSideValidationError');

  static String get emptyFirstNameClientSideValidationError =>
      Intl.message('First name is required',
          name: 'emptyFirstNameClientSideValidationError');

  static String get invalidFirstNameClientSideValidationError =>
      Intl.message('First name is invalid',
          name: 'invalidFirstNameClientSideValidationError');

  static String get emptyLastNameClientSideValidationError =>
      Intl.message('Last name is required',
          name: 'emptyLastNameClientSideValidationError');

  static String get emptyFullNameClientSideValidationError =>
      Intl.message('Name is required',
          name: 'emptyFullNameClientSideValidationError');

  static String get invalidLastNameClientSideValidationError =>
      Intl.message('Last name is invalid',
          name: 'invalidLastNameClientSideValidationError');

  static String get emptyCountryCodeClientSideValidationError =>
      Intl.message('Country code is required',
          name: 'emptyCountryCodeClientSideValidationError');

  static String get emptyPhoneNumberClientSideValidationError =>
      Intl.message('Phone number is required',
          name: 'emptyPhoneNumberClientSideValidationError');

  static String get invalidPhoneNumberClientSideValidationError =>
      Intl.message('Invalid phone number',
          name: 'invalidPhoneNumberClientSideValidationError');

  static String minLengthClientSideValidationError(int minLength) =>
      Intl.plural(
        minLength,
        one: 'Minimum length should be at least one character',
        other: 'Minimum length should be at least $minLength characters',
        name: 'minLengthClientSideValidationError',
        args: [minLength],
        examples: const {'minLegth': 2},
      );

  static String minPhoneNumberLengthClientSideValidationError(int minLength) =>
      Intl.message(
        'Phone number should be at least $minLength digits long',
        name: 'minPhoneNumberLengthClientSideValidationError',
        args: [minLength],
      );

  static String maxPhoneNumberLengthClientSideValidationError(int maxLength) =>
      Intl.message(
        'Phone number can only be a maximum of $maxLength digits long',
        name: 'maxPhoneNumberLengthClientSideValidationError',
        args: [maxLength],
      );

  static String get invalidCharactersClientSideValidationError =>
      Intl.message('Invalid characters',
          name: 'invalidCharactersClientSideValidationError');

  static String get emptyPasswordClientSideValidationError =>
      Intl.message('Password is required',
          name: 'emptyPasswordClientSideValidationError');

  static String get passwordsDoNotMatchClientSideValidationError =>
      Intl.message('Passwords do not match',
          name: 'passwordsDoNotMatchClientSideValidationError');

  static String get passwordInvalidCharactersClientSideValidationError =>
      Intl.message('Password contains invalid characters',
          name: 'passwordInvalidCharactersClientSideValidationError');

  static String passwordTooShortError(int count) =>
      Intl.message('Make sure your password is at least $count characters long',
          name: 'passwordTooShortError',
          args: [count],
          examples: const {'count': 8});

  static String passwordTooLongError(int count) =>
      Intl.message('Make sure your password is at most $count characters long',
          name: 'passwordTooLongError',
          args: [count],
          examples: const {'count': 100});

  static String passwordUpperCaseError(int count) => Intl.plural(count,
      one: 'Make sure your password contains at least one upper case character',
      other: 'Make sure your password contains at least $count upper case '
          'characters',
      name: 'passwordUpperCaseError',
      args: [count],
      examples: const {'count': 1});

  static String passwordLowerCaseError(int count) => Intl.plural(count,
      one: 'Make sure your password contains at least one lower case character',
      other: 'Make sure your password contains at least $count lower case '
          'characters',
      name: 'passwordLowerCaseError',
      args: [count],
      examples: const {'count': 1});

  static String passwordNumberError(int count) => Intl.plural(count,
      one: 'Make sure your password contains at least one numeric character',
      other: 'Make sure your password contains at least $count numeric '
          'characters',
      name: 'passwordNumberError',
      args: [count],
      examples: const {'count': 1});

  static String passwordSpecialCharactersError(
          int count, String specialCharacters) =>
      Intl.plural(count,
          one: 'Make sure your password contains '
              'at least one special character ($specialCharacters)',
          other: 'Make sure your password contains '
              'at least $count special characters ($specialCharacters)',
          name: 'passwordSpecialCharactersError',
          args: [count, specialCharacters],
          examples: const {'count': 1, 'specialCharacters': '!@#\$%&'});

  static String get requiredCountryOfResidenceClientSideValidationError =>
      Intl.message('Please select a country',
          name: 'requiredCountryOfResidenceClientSideValidationError');

  static String get requiredPhotoIdClientSideValidationError =>
      Intl.message('Photo ID is required',
          name: 'requiredPhotoIdClientSideValidationError');

  static String get requiredPhotoIdFrontSideClientSideValidationError =>
      Intl.message('Photo on the front side is required',
          name: 'requiredPhotoIdFrontSideClientSideValidationError');

  static String get requiredPhotoIdBackSideClientSideValidationError =>
      Intl.message('Photo on the back side is required',
          name: 'requiredPhotoIdBackSideClientSideValidationError');

  static String maximumDecimalPlacesError(int precision) =>
      Intl.message('Amount should not exceed $precision decimal places',
          name: 'maximumDecimalPlacesError',
          args: [precision],
          examples: const {'precision': 2});

// endregion Common client side validation errors

//region Password Validation

  static String get passwordInvalidError =>
      Intl.message('Make sure your password follows the rules below',
          name: 'passwordInvalidError');

  static String passwordValidationMinCharacters(int count) =>
      Intl.message('$count characters',
          name: 'passwordValidationMinCharacters',
          args: [count],
          desc: 'count of characters',
          examples: const {'count': 8});

  static String passwordValidationMinUpperCaseCharacters(int count) =>
      Intl.plural(count,
          one: 'One uppercase character',
          other: '$count uppercase characters',
          name: 'passwordValidationMinUpperCaseCharacters',
          args: [count],
          examples: const {'count': 1});

  static String passwordValidationMinLowerCaseCharacters(int count) =>
      Intl.plural(count,
          one: 'One lowercase character',
          other: '$count lowercase characters',
          name: 'passwordValidationMinLowerCaseCharacters',
          args: [count],
          examples: const {'count': 1});

  static String passwordValidationMinNumericCharacters(int count) =>
      Intl.plural(count,
          one: 'One number',
          other: '$count numbers',
          name: 'passwordValidationMinNumericCharacters',
          args: [count],
          examples: const {'count': 1});

  static String passwordValidationMinSpecialCharacters(
          int count, String specialCharacters) =>
      Intl.plural(count,
          one: 'One special character ($specialCharacters)',
          other: '$count special characters ($specialCharacters)',
          name: 'passwordValidationMinSpecialCharacters',
          args: [count, specialCharacters],
          examples: const {'count': 1, 'specialCharacters': '!@#\$%&'});

  static String get passwordValidationAllowSpaces =>
      Intl.message('Spaces are allowed', name: 'passwordValidationAllowSpaces');

  static String get passwordValidationDoNotAllowSpaces =>
      Intl.message('Spaces are not allowed',
          name: 'passwordValidationDoNotAllowSpaces');

//endregion Password Validation

// region Common Camera View
  static String get cameraViewGuide => Intl.message(
      '•	Place fully in the frame, not cut off\n'
      '•	Avoid glare so that all info is visible\n'
      '•	Hold steady to avoid a blurry scan',
      name: 'cameraViewGuide');

  static String get cameraPreviewTitle =>
      Intl.message('\nPleased with the result?', name: 'cameraPreviewTitle');

  static String get cameraPreviewRetakeButton =>
      Intl.message('Retake', name: 'cameraPreviewRetakeButton');

// endregion Common Camera View

//region Common button labels
  static String get submitButton =>
      Intl.message('Submit', name: 'submitButton');

  static String get nextPageButton =>
      Intl.message('Next', name: 'nextPageButton');

  static String get continueButton =>
      Intl.message('Continue', name: 'continueButton');

  static String get retryButton => Intl.message('Retry', name: 'retryButton');

  static String get backToWalletButton =>
      Intl.message('Back to Wallet', name: 'backToWalletButton');

  static String backToTokenWalletButton(String token) => Intl.message(
        'Back to $token Wallet',
        name: 'backToTokenWalletButton',
        args: [token],
      );

  static String sendTokensButton(String token) => Intl.message(
        'Transfer $token',
        name: 'sendTokensButton',
        args: [token],
      );

  static String get contactUsButton => Intl.message(
        'Contact us',
        name: 'contactUsButton',
      );

  static String get getStartedButton =>
      Intl.message('Get started', name: 'getStartedButton');

  static String get transferTokensButton =>
      Intl.message('Transfer tokens', name: 'transferTokensButton');

//endregion Common button labels

  //region Common Form elements

  static String stepOf(String step, String totalSteps) =>
      Intl.message('$step of $totalSteps',
          name: 'stepOf',
          args: [step, totalSteps],
          examples: const {'step': '1', 'totalSteps': '3'});

  //endregion Common Form elements

//region Onboarding Page
  static String onboardingPage1Title(String appName) => Intl.message(
        'Welcome to $appName',
        name: 'onboardingPage1Title',
        args: [appName],
      );

  static String onboardingPage2Title(String token) => Intl.message(
        'Start earning $token tokens',
        name: 'onboardingPage2Title',
        args: [token],
      );

  static String onboardingPage2Details(String token, String company) =>
      Intl.message(
        'Earn $token tokens by referring friends to $company properties, '
        'hotels, restaurants and much more',
        name: 'onboardingPage2Details',
        args: [token, company],
      );

  static String onboardingPage3Title(String token) => Intl.message(
        'Use $token tokens easily',
        name: 'onboardingPage3Title',
        args: [token],
      );

  static String onboardingPage3Details(String token, String company) =>
      Intl.message(
        'Use your $token tokens on $company property invoices, '
        'hotel stays, restaurants and much more',
        name: 'onboardingPage3Details',
        args: [token, company],
      );

  static String get onboardingSkipButton =>
      Intl.message('Skip', name: 'onboardingSkipButton');

//endregion Onboarding Page

//region Welcome Page
  static String welcomePageHeader(String appName) => Intl.message(
        'Welcome to $appName',
        name: 'welcomePageHeader',
        args: [appName],
      );

  static String welcomePageSubHeader(String token) => Intl.message(
        'Earn and use ${token}s across the world',
        name: 'welcomePageSubHeader',
        args: [token],
      );

  static String get welcomeSignInButtonText =>
      Intl.message('Sign in', name: 'welcomeSignInButtonText');

  static String get welcomeCreateAccountButtonText =>
      Intl.message('Create an account', name: 'welcomeCreateAccountButtonText');

  static String get socialOrContinueWith =>
      Intl.message('Or continue with', name: 'socialOrContinueWith');

//endregion

// region Login Page

  static String get loginPageHeader =>
      Intl.message('Sign-in', name: 'loginPageHeader');

  static String get loginPageEmailLabel =>
      Intl.message('Email', name: 'loginPageEmailLabel');

  static String get loginPagePasswordLabel =>
      Intl.message('Password', name: 'loginPagePasswordLabel');

  static String get loginPagePasswordHint =>
      Intl.message('Enter password', name: 'loginPagePasswordHint');

  static String get loginPageLoginSubmitButton =>
      Intl.message('Sign in', name: 'loginPageLoginSubmitButton');

  static String get loginPageForgottenPasswordButton =>
      Intl.message('Forgot password', name: 'loginPageForgottenPasswordButton');

  static String get loginPageInvalidCredentialsError =>
      Intl.message('Your login details are incorrect. Please try again.',
          name: 'loginPageInvalidCredentialsError');

  static String get loginPageUnauthorizedRedirectionMessage =>
      Intl.message('Your session has expired, please log in again',
          name: 'loginPageUnauthorizedRedirectionMessage');

  static String loginPageLoginAttemptWarningMessage(int attemptNumber) =>
      Intl.plural(attemptNumber,
          one: 'You have $attemptNumber more attempt to sign in, after that '
              'your account will be temporarily locked.',
          other: 'You have $attemptNumber more attempts to sign in, after that '
              'your account will be temporarily locked.',
          name: 'loginPageLoginAttemptWarningMessage',
          args: [
            attemptNumber
          ],
          examples: const {
            'attemptNumber': '1',
          });

  static String loginPageTooManyRequestMessage(int numberOfMinutes) =>
      Intl.plural(numberOfMinutes,
          one: 'Your account has been locked. Please try again in '
              '$numberOfMinutes minute.',
          other: 'Your account has been locked. Please try again in'
              ' $numberOfMinutes minutes.',
          name: 'loginPageTooManyRequestMessage',
          args: [
            numberOfMinutes
          ],
          examples: const {
            'numberOfMinutes': '1',
          });

// endregion Login Page

// region Register Page
  static String get personalDetailsHeader =>
      Intl.message('Personal Details', name: 'personalDetailsHeader');

  static String get createAPasswordHeader =>
      Intl.message('Create a password', name: 'createAPasswordHeader');

  static String get phoneNumberHeader =>
      Intl.message('Phone number', name: 'phoneNumberHeader');

  static String get addPhoneAndRefCodeHeader =>
      Intl.message('Phone and referral code', name: 'addPhoneAndRefCodeHeader');

  static String get registerPageHeader =>
      Intl.message('Register', name: 'registerPageHeader');

  static String get registerPageRegisterSubmitButton =>
      Intl.message('Register', name: 'registerPageRegisterSubmitButton');

  static String get registerPageBackendInvalidEmailError =>
      Intl.message('Invalid email',
          name: 'registerPageBackendInvalidEmailError');

  static String get registerPageBackendInvalidPasswordError =>
      Intl.message('Invalid password',
          name: 'registerPageBackendInvalidPasswordError');

  static String get registerPageLoginAlreadyInUseError =>
      Intl.message('Login already in use',
          name: 'registerPageLoginAlreadyInUseError');

  static String get registerPageAgreeTermsOfUse =>
      Intl.message('I agree with the ', name: 'registerPageAgreeTermsOfUse');

  static String get registerPageAgreeTermsOfUseError =>
      Intl.message('Please accept the Terms of Use and Privacy Policy below',
          name: 'registerPageAgreeTermsOfUseError');

// endregion Register Page

// region Set phone number page
  static String get setPhoneNumberPageTitle =>
      Intl.message('Add phone number', name: 'setPhoneNumberPageTitle');

  static String get setPhoneNumberVerifyButton =>
      Intl.message('Verify', name: 'setPhoneNumberVerifyButton');

// endregion Set phone number page

//region Phone Number Verification Page

  static String get phoneNumberVerificationPageTitle =>
      Intl.message('Enter code', name: 'phoneNumberVerificationPageTitle');

  static String phoneNumberVerificationDetails(String phoneNumber) =>
      Intl.message('We’ve sent a verification code  to $phoneNumber',
          args: [phoneNumber], name: 'phoneNumberVerificationDetails');

  static String get phoneNumberVerificationCodeResent =>
      Intl.message('Verification code was re-sent',
          name: 'phoneNumberVerificationCodeResent');

  static String get phoneNumberVerificationRequestNewCode =>
      Intl.message('Request a new verification code',
          name: 'phoneNumberVerificationRequestNewCode');

  static String phoneNumberVerificationResendCodeTimer(String timeLeft) =>
      Intl.message(
        'Resend code in $timeLeft if it doesn’t arrive or expires',
        name: 'phoneNumberVerificationResendCodeTimer',
        args: [timeLeft],
        examples: const {'timeLeft': '00:50'},
      );

  static String get phoneNumberVerificationCodeNotSentError =>
      Intl.message('Verification code was not sent, please retry',
          name: 'phoneNumberVerificationCodeNotSentError');

  static String get phoneNumberVerificationExpiredCodeError =>
      Intl.message('This code has expired, please request a new one',
          name: 'phoneNumberVerificationExpiredCodeError');

//
  static String get phoneNumberVerificationInvalidCodeError =>
      Intl.message('Incorrect code, please check it and try again',
          name: 'phoneNumberVerificationInvalidCodeError');

//endregion Phone Number Verification Page

// region Country Code list Page

  static String get countryCodeListPageTitle =>
      Intl.message('Select your country code',
          name: 'countryCodeListPageTitle');

  static String get countryCodeEmptyPrompt =>
      Intl.message('Code', name: 'countryCodeEmptyPrompt');

// endregion Country Code list Page

// region Country list Page

  static String get countryListPageTitle =>
      Intl.message('Select country', name: 'countryListPageTitle');

// endregion Country list Page

// region Nationality list Page

  static String get nationalityListPageTitle =>
      Intl.message('Select nationality', name: 'nationalityListPageTitle');

// endregion Nationality list Page

// region common country list text

  static String get countryListFilterHint =>
      Intl.message('Search for country name', name: 'countryListFilterHint');

// endregion common country list text

// region common list text

  static String get listNoResultsTitle =>
      Intl.message('No results found', name: 'listNoResultsTitle');

  static String get listNoResultsDetails =>
      Intl.message('We can’t find any item matching your search',
          name: 'listNoResultsDetails');

// endregion common list text

//region Home Page

  static String get search => Intl.message(
        'Search',
        name: 'search',
      );

  static String get yourOffers => Intl.message(
        'Your offers',
        name: 'yourOffers',
      );

  static String get monthlyChallenges => Intl.message(
        'Monthly challenges',
        name: 'monthlyChallenges',
      );

  static String get monthlyChallengesSubtitle => Intl.message(
        'Test yourself and earn tokens',
        name: 'monthlyChallengesSubtitle',
      );

  static String get homePageCountdownTitle =>
      Intl.message('Countdown!', name: 'homePageCountdownTitle');

  static String get homePageCountdownSubtitle =>
      Intl.message('are waiting for you, hurry up',
          name: 'homePageCountdownSubtitle');

  static String homePageCountdownViewAll(int count) =>
      Intl.message('View all ($count)',
          args: [count], name: 'homePageCountdownViewAll');

//endregion Home Page

//region Offers

  static String get offers => Intl.message('Offers', name: 'offers');

  static String get earn => Intl.message('Earn', name: 'earn');

  static String get redeem => Intl.message('Redeem', name: 'redeem');

//endregion Offers

// region Balance Box

  static String get balanceBoxErrorMessage =>
      Intl.message('Sorry, we are unable to process your balance',
          name: 'balanceBoxErrorMessage');

  static String get balanceBoxHeader =>
      Intl.message('Balance', name: 'balanceBoxHeader');

// endregion Balance Box

// region Wallet Page

  static String get walletPageMyTotalTokens => Intl.message(
        'My total tokens',
        name: 'walletPageMyTotalTokens',
      );

  static String get walletPageTitle => Intl.message(
        'Wallet',
        name: 'walletPageTitle',
      );

  static String get transfer => Intl.message(
        'Transfer',
        name: 'transfer',
      );

  static String get receive => Intl.message(
        'Receive',
        name: 'receive',
      );

  static String get requests => Intl.message(
        'Requests',
        name: 'requests',
      );

  static String from(String sender) => Intl.message(
        'From $sender',
        name: 'from',
        args: [sender],
      );

  static String to(String recipient) => Intl.message(
        'To $recipient',
        name: 'to',
        args: [recipient],
      );

  static String walletPageSendButtonSubtitle(String token) => Intl.message(
        'Transfer $token tokens to anyone',
        name: 'walletPageSendButtonSubtitle',
        args: [token],
      );

  static String walletPageReceiveButtonTitle(String token) => Intl.message(
        'Receive $token tokens',
        name: 'walletPageReceiveButtonTitle',
        args: [token],
      );

  static String walletPageReceiveButtonSubtitle(String token) => Intl.message(
        'Receive tokens from other $token users',
        name: 'walletPageReceiveButtonSubtitle',
        args: [token],
      );

  static String get walletPageTransferRequestsTitle =>
      Intl.message('Transfer requests',
          name: 'walletPageTransferRequestsTitle');

  static String get externalWalletTitle =>
      Intl.message('Your external wallet', name: 'externalWalletTitle');

  static String get externalWalletHint =>
      Intl.message('Link to your account', name: 'externalWalletHint');

  static String externalLinkWalletDescription(String token) => Intl.message(
        'Before sending and receiving ${token}s'
        ', you need to link an Ethereum wallet, here is how to link it',
        name: 'externalLinkWalletDescription',
        args: [token],
      );

  static String get linkSimpleWalletDescription => Intl.message(
      // ignore: lines_longer_than_80_chars
      'To link to a simple wallet, copy the linking url and paste in your external wallet',
      name: 'linkSimpleWalletDescription');

  static String walletPagePaymentRequestsSubtitle(int count) =>
      Intl.plural(count,
          zero: 'You have no pending transfers',
          one: 'You have $count pending transfer',
          other: 'You have $count pending transfers',
          name: 'walletPagePaymentRequestsSubtitle',
          args: [
            count
          ],
          examples: const {
            'count': 1,
          });

  static String get walletPageTransactionHistoryEmpty =>
      Intl.message('Once you have a few transactions you will see them here',
          name: 'walletPageTransactionHistoryEmpty');

  static String walletPageTransactionHistorySentType(String token) =>
      Intl.message(
        'Sent $token tokens',
        name: 'walletPageTransactionHistorySentType',
        args: [token],
      );

  static String walletPageTransactionHistoryReceivedType(String token) =>
      Intl.message(
        'Received $token tokens',
        name: 'walletPageTransactionHistoryReceivedType',
        args: [token],
      );

  static String get walletPageTransactionHistoryRewardType =>
      Intl.message('Award', name: 'walletPageTransactionHistoryRewardType');

  static String get walletPageTransactionHistoryRefundType =>
      Intl.message('Refund', name: 'walletPageTransactionHistoryRefundType');

  static String get walletPageTransactionHistoryPaymentType =>
      Intl.message('Property Purchase',
          name: 'walletPageTransactionHistoryPaymentType');

  static String get walletPageTransactionHistoryWalletLinkingType =>
      Intl.message('Wallet Linking Fee',
          name: 'walletPageTransactionHistoryWalletLinkingType');

  static String get walletPageTransactionHistoryTransferToExternalType =>
      Intl.message('Transfer to external wallet',
          name: 'walletPageTransactionHistoryTransferToExternalType');

  static String get walletPageTransactionHistoryTransferFromExternalType =>
      Intl.message('Transfer from external wallet',
          name: 'walletPageTransactionHistoryTransferFromExternalType');

  static String get walletPageTransactionHistoryTransferFeeType =>
      Intl.message('Transfer Fee',
          name: 'walletPageTransactionHistoryTransferFeeType');

  static String get walletPageTransactionHistoryVoucherPurchaseType =>
      Intl.message('Voucher purchase',
          name: 'walletPageTransactionHistoryVoucherPurchaseType');

  static String get walletPageTransactionHistoryTitle =>
      Intl.message('History', name: 'walletPageTransactionHistoryTitle');

  static String get walletPageTransactionHistoryInitialPageError =>
      Intl.message('Sorry, we are unable to load this section right now',
          name: 'walletPageTransactionHistoryInitialPageError');

  static String get walletPageTransactionHistoryPaginationError =>
      Intl.message('Sorry, we are unable to show more transactions right now',
          name: 'walletPageTransactionHistoryPaginationError');

  static String get walletPageWalletDisabledError =>
      Intl.message('Wallet disabled', name: 'walletPageWalletDisabledError');

  static String get walletPageWalletDisabledErrorMessage => Intl.message(
      'Sorry, your wallet has been disabled, '
      'please contact us to resolve the issue.',
      name: 'walletPageWalletDisabledErrorMessage');

// endregion Wallet Page

// region Lead Referral Page
  static String get leadReferralPageTitle =>
      Intl.message('Refer a friend', name: 'leadReferralPageTitle');

  static String get leadReferralFormPageCommunityOfInterestLabel =>
      Intl.message(
        'Community/Property of interest',
        name: 'leadReferralFormPageCommunityOfInterestLabel',
      );

// endregion Lead Referral Page

// region Lead Referral Success Page
  static String leadReferralSuccessPageDetails(
    String refereeFirstName,
    String refereeLastName,
  ) =>
      Intl.message(
        // ignore: lines_longer_than_80_chars
        'Great! You\'ve successfully referred $refereeFirstName $refereeLastName',
        args: [refereeFirstName, refereeLastName],
        name: 'leadReferralSuccessPageDetails',
      );

  static String leadReferralSuccessPageDetailsPartnerName(String partnerName) =>
      Intl.message(
        ' to $partnerName properties',
        args: [partnerName],
        name: 'leadReferralSuccessPageDetailsPartnerName',
      );

// endregion Lead Referral Success Page

//region Referral Success shared elements

  static String get referralSuccessPageTitle =>
      Intl.message('Referral submitted', name: 'referralSuccessPageTitle');

  static String get referralSuccessPageSubDetails => Intl.message(
        'You can track the progress in the referral section',
        name: 'referralSuccessPageSubDetails',
      );

  static String get referralSuccessGoToRefsButton => Intl.message(
        'Go to referrals',
        name: 'referralSuccessGoToRefsButton',
      );

//endregion Referral Success shared elements

//region LeadReferralAcceptedPage

  static String get leadReferralAcceptedSuccessBody => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Thanks for accepting the referral.',
      name: 'leadReferralAcceptedSuccessBody');

//endregion LeadReferralAcceptedPage

// region Hotel Referral Page
  static String get hotelReferralPageTitle =>
      Intl.message('Refer a hotel', name: 'hotelReferralPageTitle');

  static String get hotelReferralPageDescription =>
      Intl.message('Please enter your referral\'s email address',
          name: 'hotelReferralPageDescription');

  static String get hotelReferralPageButton =>
      Intl.message('Send invite', name: 'hotelReferralPageButton');

  static String hotelReferralPartnerInfo(String partnerName) => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Please enter the details for the person you would like to refer to $partnerName properties. ',
      args: [partnerName],
      name: 'hotelReferralPartnerInfo');

  static String get hotelReferralStakingInfo =>
      Intl.message('You are required to lock ',
          name: 'hotelReferralStakingInfo');

  static String get hotelReferralFullNameFieldLabel =>
      Intl.message('Full name*', name: 'hotelReferralFullNameFieldLabel');

  static String get hotelReferralFullNameFieldHint =>
      Intl.message('Enter full name', name: 'hotelReferralFullNameFieldHint');

// endregion Hotel Referral Page

// region Hotel Referral Success Page
  static String hotelReferralSuccessPageDetails(String refereeFullName) =>
      Intl.message(
        'Great! You\'ve successfully referred $refereeFullName',
        args: [refereeFullName],
        name: 'hotelReferralSuccessPageDetails',
      );

  static String hotelReferralSuccessPageDetailsPartnerName(
          String partnerName) =>
      Intl.message(
        ' to $partnerName',
        args: [partnerName],
        name: 'hotelReferralSuccessPageDetailsPartnerName',
      );

// endregion Hotel Referral Success Page

  // region Hotel Referral Accepted Page
  static String hotelReferralAcceptedSuccessBody(
          String token, String company) =>
      Intl.message(
        // ignore: lines_longer_than_80_chars
        'Thanks for accepting the referral, the next time you stay at $company hotel you will be awarded with $token tokens',
        name: 'hotelReferralAcceptedSuccessBody', args: [token, company],
      );

// endregion Hotel Referral Accepted Page

// region Hotel Referral Error Page
  static String get hotelReferralErrorTitle => Intl.message(
        'Invite unsuccessful',
        name: 'hotelReferralErrorTitle',
      );

  static String get hotelReferralErrorDetails => Intl.message(
        'We were unable submit your referral, please retry',
        name: 'hotelReferralErrorDetails',
      );

  static String get hotelReferralErrorLeadAlreadyExists =>
      Intl.message('This referral already exists.',
          name: 'hotelReferralErrorLeadAlreadyExists');

// endregion Hotel Referral Error Page

// region Referral list Page
  static String get referralListPageTitle =>
      Intl.message('Referrals', name: 'referralListPageTitle');

  static String get referralListPageDescription =>
      Intl.message('Track all your referrals here',
          name: 'referralListPageDescription');

  static String get referralListRequestGenericErrorSubtitle => Intl.message(
      'Sorry, we are unable to show your referrals, '
      'please try again.',
      name: 'referralListRequestGenericErrorSubtitle');

  static String get referralListRequestGenericErrorTitle =>
      Intl.message('Hmm… seems like something is not right',
          name: 'referralListRequestGenericErrorTitle');

  static String get pendingReferralListEmptyState =>
      Intl.message('You have no pending referrals at the moment',
          name: 'pendingReferralListEmptyState');

  static String get approvedReferralListEmptyState =>
      Intl.message('You have no approved referrals at the moment',
          name: 'approvedReferralListEmptyState');

  static String get expiredReferralListEmptyState =>
      Intl.message('You have no expired referrals at the moment',
          name: 'expiredReferralListEmptyState');

  static String get referralListOngoingTab =>
      Intl.message('Ongoing', name: 'referralListOngoingTab');

  static String get referralListCompletedTab =>
      Intl.message('Completed', name: 'referralListCompletedTab');

  static String get referralListExpiredTab =>
      Intl.message('Expired', name: 'referralListExpiredTab');

// endregion Referral list Page

//region Referral Shared Elements

  static String get referralAcceptedSuccessTitle =>
      Intl.message('Referral accepted', name: 'referralAcceptedSuccessTitle');

  static String get referralAcceptedTitle =>
      Intl.message('Referral', name: 'referralAcceptedTitle');

  static String get referralAcceptedNotFoundError =>
      Intl.message('Referral not found', name: 'referralAcceptedNotFoundError');

  static String get referralAcceptedInvalidCode =>
      Intl.message('Invalid Referral Code.',
          name: 'referralAcceptedInvalidCode');

//endregion Referral Shared Elements

//region P2P Transaction Page

  static String transactionFormPageTitle(String token) => Intl.message(
        'Transfer $token tokens',
        name: 'transactionFormPageTitle',
        args: [token],
      );

  static String transactionFormPageSubDetails(String token) => Intl.message(
        'Transfer $token tokens easily, scan the receivers QR'
        ' code or enter their email address',
        name: 'transactionFormPageSubDetails',
        args: [token],
      );

  static String transactionFormStakedAmount(String lockedAmount) =>
      Intl.message(
        '$lockedAmount are locked',
        args: [lockedAmount],
        name: 'transactionFormStakedAmount',
      );

  static String get transactionFormScanQRCode => Intl.message(
        'Scan QR Code',
        name: 'transactionFormScanQRCode',
      );

  static String get transactionFormOr => Intl.message(
        'or',
        name: 'transactionFormOr',
      );

  static String get transactionReceiverEmailAddressLabel => Intl.message(
        'Receiver email address',
        name: 'transactionReceiverEmailAddressLabel',
      );

  static String get transactionReceiverEmailAddressHint => Intl.message(
        'Enter receiver email address',
        name: 'transactionReceiverEmailAddressHint',
      );

  static String transactionAmountTokensLabel(String token) => Intl.message(
        'Amount ($token tokens)',
        args: [token],
        name: 'transactionAmountTokensLabel',
      );

  static String get transactionAmountOfTokensHint => Intl.message(
        'How many tokens are required?',
        name: 'transactionAmountOfTokensHint',
      );

  static String get transactionEmptyAddressError =>
      Intl.message('Wallet address is required',
          name: 'transactionEmptyAddressError');

  static String get transactionInvalidAddressError => Intl.message(
        'Are you sure that\'s your wallet address?',
        name: 'transactionInvalidAddressError',
      );

  static String get transactionAmountRequiredError => Intl.message(
        'Transaction amount is required',
        name: 'transactionAmountRequiredError',
      );

  static String get transactionAmountInvalidError => Intl.message(
        'Transaction amount is not valid',
        name: 'transactionAmountInvalidError',
      );

  static String get transactionAmountGreaterThanBalanceError => Intl.message(
        'Hey big spender, it looks  as though your balance '
        'is too low for this transaction. Please try again.',
        name: 'transactionAmountGreaterThanBalanceError',
      );

  static String get barcodeScanPermissionError => Intl.message(
        'Camera permission is required for QR code scanning.',
        name: 'barcodeScanPermissionError',
      );

  static String get barcodeScanError => Intl.message(
        'There was a problem scanning the QR code. Please try again.',
        name: 'barcodeScanError',
      );

  static String get copyEmail => Intl.message('Copy email', name: 'copyEmail');

//endregion P2P Transaction Page

//region Transaction Success Page

  static String get transactionSuccessTitle => Intl.message(
        'Transfer submitted',
        name: 'transactionSuccessTitle',
      );

  static String get transactionSuccessDetails => Intl.message(
        'Thanks for submitting your payment. '
        'We\'ll let you know once it\'s processed.',
        name: 'transactionSuccessDetails',
      );

//endregion Transaction Success Page

  //region Wallet linking

  static String get insufficientFunds => Intl.message(
        'You have unsufficient funds to link to an external wallet',
        name: 'insufficientFunds',
      );

  static String get linkYourWallet => Intl.message(
        'Link to your account',
        name: 'linkYourWallet',
      );

  static String get walletLinkingInProgress => Intl.message(
        'Wallet linking in progress',
        name: 'walletLinkingInProgress',
      );

  static String get linkSimpleWalletInstructionCopyUrl => Intl.message(
        'Copy this url',
        name: 'linkSimpleWalletInstructionCopyUrl',
      );

  static String get linkSimpleWalletInstructionSwitchToWallet => Intl.message(
        'Switch to the wallet app you want to link',
        name: 'linkSimpleWalletInstructionSwitchToWallet',
      );

  static String get linkSimpleWalletInstructionPasteAddress => Intl.message(
        'Paste it in the address field',
        name: 'linkSimpleWalletInstructionPasteAddress',
      );

  static String get linkSimpleWalletInstructionPasteLink => Intl.message(
        'Press link wallet',
        name: 'linkSimpleWalletInstructionPasteLink',
      );

  static String get linkWalletInstructionSelectWallet => Intl.message(
        'Select a wallet from the options below',
        name: 'linkWalletInstructionSelectWallet',
      );

  static String get linkWalletInstructionConfirmLinking => Intl.message(
        'Follow the instructions to confirm the linking',
        name: 'linkWalletInstructionConfirmLinking',
      );

  static String get linkWalletInstructionFees => Intl.message(
        'Linking wallet has associated fees',
        name: 'linkWalletInstructionFees',
      );

  static String get linkWalletChooseSupportedWallets => Intl.message(
        'Choose any supported wallet',
        name: 'linkWalletChooseSupportedWallets',
      );

  static String get linkWalletHeader => Intl.message(
        'Link an external wallet',
        name: 'linkWalletHeader',
      );

  static String get linkSimpleWalletHeader => Intl.message(
        'Link a simple wallet',
        name: 'linkSimpleWalletHeader',
      );

  static String get simpleWalletsTitle => Intl.message(
        'Simple wallets',
        name: 'simpleWalletsTitle',
      );

  static String get simpleWalletsDescription => Intl.message(
        'Metamask, Coinbase, Trust wallet, ...',
        name: 'simpleWalletsDescription',
      );

  static String get advancedWalletsTitle => Intl.message(
        'Advanced wallets',
        name: 'advancedWalletsTitle',
      );

  static String get advancedWalletsDescription => Intl.message(
        'My Crypto, My Ether Wallet, …',
        name: 'advancedWalletsDescription',
      );

  static String get dapBrowserHint => Intl.message(
        'You can also copy the linking url to open in a dApp Browser',
        name: 'dapBrowserHint',
      );

  static String get linkWalletInProgressHeader => Intl.message(
        'Linking in progress',
        name: 'linkWalletInProgressHeader',
      );

  static String get linkWalletInProgressTitle => Intl.message(
        'Your wallet is currently being linked',
        name: 'linkWalletInProgressTitle',
      );

  static String get linkWalletInProgressDescription => Intl.message(
        // ignore: lines_longer_than_80_chars
        'This may take a while, you can continue using the app we will let you know once it completed',
        name: 'linkWalletInProgressDescription',
      );

  static String get linkedWalletHeader => Intl.message(
        'Your external wallet',
        name: 'linkedWalletHeader',
      );

  static String get sendToExternalWalletButton => Intl.message(
        'Transfer to external wallet',
        name: 'sendToExternalWalletButton',
      );

  static String sendToExternalWalletButtonSubtitle(String token) =>
      Intl.message(
        'From $token wallet to external wallet',
        name: 'sendToExternalWalletButtonSubtitle',
        args: [token],
      );

  static String get receiveExternalWalletButton => Intl.message(
        'Receive from external wallet',
        name: 'receiveExternalWalletButton',
      );

  static String receiveExternalWalletButtonSubtitle(String token) =>
      Intl.message(
        'From external wallet to $token wallet',
        name: 'receiveExternalWalletButtonSubtitle',
        args: [token],
      );

  static String get unlinkExternalWalletButton => Intl.message(
        'Unlink external wallet',
        name: 'unlinkExternalWalletButton',
      );

  static String get unlinkExternalWalletButtonSubtitle => Intl.message(
        'Remove external wallet from your account',
        name: 'unlinkExternalWalletButtonSubtitle',
      );

  static String get linkAdvancedWalletHeader => Intl.message(
        'Link an advanced wallet',
        name: 'linkAdvancedWalletHeader',
      );

  static String get linkAdvancedWalletDescription => Intl.message(
        // ignore: lines_longer_than_80_chars
        'To link to an advanced wallet, you must be using an app that supports signatures',
        name: 'linkAdvancedWalletDescription',
      );

  static String get linkAdvancedWalletInstructionCopyCode => Intl.message(
        'Copy this code',
        name: 'linkAdvancedWalletInstructionCopyCode',
      );

  static String get linkAdvancedWalletInstructionSwitchApp => Intl.message(
        'Switch to the wallet app you want to link',
        name: 'linkAdvancedWalletInstructionSwitchApp',
      );

  static String get linkAdvancedWalletInstructionSignMessage => Intl.message(
        'Sign a message with this code',
        name: 'linkAdvancedWalletInstructionSignMessage',
      );

  static String get linkAdvancedWalletInstructionCopySignature => Intl.message(
        'Copy the signature',
        name: 'linkAdvancedWalletInstructionCopySignature',
      );

  static String get linkAdvancedWalletInstructionPasteSignature => Intl.message(
        'Paste it in the field below',
        name: 'linkAdvancedWalletInstructionPasteSignature',
      );

  static String get linkAdvancedWalletInstructionPublicAddress => Intl.message(
        'Enter your public address and tap ‘Link wallet’',
        name: 'linkAdvancedWalletInstructionPublicAddress',
      );

  static String get linkAdvancedWalletButton => Intl.message(
        'Link wallet',
        name: 'linkAdvancedWalletButton',
      );

  static String get linkAdvancedWalletTextFieldCodeSignatureTitle =>
      Intl.message(
        'Linking code signature',
        name: 'linkAdvancedWalletTextFieldCodeSignatureTitle',
      );

  static String get linkAdvancedWalletTextFieldCodeSignatureHint =>
      Intl.message(
        'Paste signature here',
        name: 'linkAdvancedWalletTextFieldCodeSignatureHint',
      );

  static String get emptyLinkAdvancedWalletTextFieldCodeSignatureError =>
      Intl.message(
        'Linking code signature is required',
        name: 'emptyLinkAdvancedWalletTextFieldCodeSignatureError',
      );

  static String get linkAdvancedWalletTextFieldPublicAddressTitle =>
      Intl.message(
        'Public account address',
        name: 'linkAdvancedWalletTextFieldPublicAddressTitle',
      );

  static String get linkAdvancedWalletTextFieldPublicAddressHint =>
      Intl.message(
        'Enter public account address',
        name: 'linkAdvancedWalletTextFieldPublicAddressHint',
      );

  static String get emptyLinkAdvancedWalletTextFieldPublicAddressError =>
      Intl.message(
        'Public account address is required',
        name: 'emptyLinkAdvancedWalletTextFieldPublicAddressError',
      );

  static String linkWalletReceiveTitle(String token) => Intl.message(
        'Receive $token tokens from external wallet',
        name: 'linkWalletReceiveTitle',
        args: [token],
      );

  static String linkWalletReceiveHint(String token) => Intl.message(
        'Transfer from your linked external wallet to your $token wallet',
        name: 'linkWalletReceiveHint',
        args: [token],
      );

  static String get linkWalletReceiveCopyAddress => Intl.message(
        'Copy address',
        name: 'linkWalletReceiveCopyAddress',
      );

  static String get linkWalletReceiveNote => Intl.message(
        'Note: Funds will be lost if you use a wallet other '
        'than your linked external wallet',
        name: 'linkWalletReceiveNote',
      );

  static String get linkWalletTransferFailedTitle => Intl.message(
        'Transfer failed',
        name: 'linkWalletTransferFailedTitle',
      );

  static String get linkWalletTransferFailedDetails => Intl.message(
        'We were unable to complete your transfer, please try again.',
        name: 'linkWalletTransferFailedDetails',
      );

  static String get linkWalletTransferFailedSubDetails => Intl.message(
        'Your transaction failed due to public blockchain error.',
        name: 'linkWalletTransferFailedSubDetails',
      );

  static String linkedWalletSendTitle(String token) => Intl.message(
        'Transfer $token tokens to external wallet',
        name: 'linkedWalletSendTitle',
        args: [token],
      );

  static String linkedWalletSendHint(String token) => Intl.message(
        'Transfer from your $token wallet to your linked external wallet',
        name: 'linkedWalletSendHint',
        args: [token],
      );

  static String get linkingWalletDisabled =>
      Intl.message('Currently disabled', name: 'linkingWalletDisabled');

//endregion Wallet linking

  //region Wallet Unlinking

  static String get unlinkWalletInProgressHeader => Intl.message(
        'Unlinking in progress',
        name: 'unlinkWalletInProgressHeader',
      );

  static String get unlinkWalletInProgressTitle => Intl.message(
        'Your wallet is currently being unlinked',
        name: 'unlinkWalletInProgressTitle',
      );

  //endregion Wallet Unlinking

  //region Social Page
  static String get socialPageTitle => Intl.message(
        'Social',
        name: 'socialPageTitle',
      );

  static String get socialPageComingSoon => Intl.message(
        'Coming Soon',
        name: 'socialPageComingSoon',
      );

//region Spend Page

  static String get spendPageTitle => Intl.message(
        'Redeem',
        name: 'spendPageTitle',
      );

  static String get spendRulePageEmpty =>
      Intl.message('Sorry, it appears there are no redeem offers right now',
          name: 'spendRulePageEmpty');

  static String get doneButton => Intl.message('Done', name: 'doneButton');

  static String get offerDetailGenericError => Intl.message(
      'We are unable to load offer details at the moment. Please try again.',
      name: 'offerDetailGenericError');

  static String voucherStockCount(int stockCount) => Intl.plural(stockCount,
      zero: 'Out of stock',
      other: '$stockCount left',
      name: 'voucherStockCount',
      args: [stockCount],
      examples: const {'stockCount': 11});

  static String voucherSoldCountInfo(int soldCount) =>
      Intl.message('$soldCount used this offer',
          name: 'voucherSoldCountInfo',
          args: [soldCount],
          examples: const {'soldCount': '2'});

  static String get voucherDetailsAmount =>
      Intl.message('Amount', name: 'voucherDetailsAmount');

  static String get voucherDetailsAvailableBalance => Intl.message(
        'Available balance',
        name: 'voucherDetailsAvailableBalance',
      );

  static String get tokensLocked =>
      Intl.message('are locked', name: 'tokensLocked');

  static String get redeemVoucherButton =>
      Intl.message('Redeem voucher', name: 'redeemVoucherButton');

  static String get redeemVoucherInsufficientFunds => Intl.message(
      'You can’t complete this action, you have insufficient funds',
      name: 'redeemVoucherInsufficientFunds');

  static String get outOfStockDescription =>
      Intl.message('The vouchers in this offer are currently out of stock.',
          name: 'outOfStockDescription');

//endregion Spend Page

//region Real Estate Payment

  static String get realEstateListChooseAProperty =>
      Intl.message('Choose a property', name: 'realEstateListChooseAProperty');

  static String get realEstateListNoPurchases =>
      Intl.message('You have no ongoing purchases at the moment',
          name: 'realEstateListNoPurchases');

  static String get instalmentListChooseAnInstalment =>
      Intl.message('Choose an instalment',
          name: 'instalmentListChooseAnInstalment');

  static String get installmentOverdue =>
      Intl.message('Overdue', name: 'installmentOverdue');

//endregion Real Estate Payment

// region Property Payment Page
  static String get propertyPaymentPageTitle => Intl.message(
        'Pay your instalment',
        name: 'propertyPaymentPageTitle',
      );

  static String get propertyPaymentPageSubDetails => Intl.message(
        'Your can pay your instalment in full or partially',
        name: 'propertyPaymentPageSubDetails',
      );

  static String get propertyPaymentFull => Intl.message(
        'Full',
        name: 'propertyPaymentFull',
      );

  static String get propertyPaymentPartial => Intl.message(
        'Partial',
        name: 'propertyPaymentPartial',
      );

  static String get propertyPaymentProperty => Intl.message(
        'Property',
        name: 'propertyPaymentProperty',
      );

  static String get propertyPaymentAvailableBalanceLabel => Intl.message(
        'Available balance',
        name: 'propertyPaymentAvailableBalanceLabel',
      );

  static String propertyPaymentConversionHolder(
          String amount, String currencyName) =>
      Intl.message(
        'Equals to: $amount $currencyName',
        args: [amount, currencyName],
        name: 'propertyPaymentConversionHolder',
      );

  static String get propertyPaymentAmountExceedsInstalment => Intl.message(
        'Amount can\'t exceed the total of the instalment',
        name: 'propertyPaymentAmountExceedsInstalment',
      );

  static String currencyConversionLabel(String amountInToken, String token,
          String amountInCurrency, String currency) =>
      Intl.message(
        '$amountInToken $token = $amountInCurrency $currency',
        name: 'currencyConversionLabel',
        args: [amountInToken, token, amountInCurrency, currency],
      );

  static String get paymentAmountRequiredError => Intl.message(
        'Transfer amount is required',
        name: 'paymentAmountRequiredError',
      );

  static String get paymentAmountInvalidError => Intl.message(
        'Transfer amount is not valid',
        name: 'paymentAmountInvalidError',
      );

  static String get emptyPaymentInvoiceError =>
      Intl.message('Invoice number is required',
          name: 'emptyPaymentInvoiceError');

  static String get insufficientBalanceError => Intl.message(
      'We are unable to make transactions at this point as we '
      'could not load your balance',
      name: 'insufficientBalanceError');

  static String get paymentSuccessDetails => Intl.message(
        'Great! Your transfer has been submitted. '
        'We\'ll notify you as soon as it\'s approved',
        name: 'paymentSuccessDetails',
      );

// endregion Property Payment Page

//region Redemption Success Page

  static String get redemptionSuccessTitle =>
      Intl.message('Redemption successful', name: 'redemptionSuccessTitle');

  static String get redemptionSuccessCopyTitle =>
      Intl.message('Your voucher code is', name: 'redemptionSuccessCopyTitle');

  static String get redemptionSuccessDetailsText => Intl.message(
      'If you want to view this code later, you can find it under ',
      name: 'redemptionSuccessDetailsText');

  static String get redemptionSuccessDetailsLink =>
      Intl.message('my account', name: 'redemptionSuccessDetailsLink');

  static String get redemptionSuccessOpenVoucherAppButton =>
      Intl.message('Open Voucher App',
          name: 'redemptionSuccessOpenVoucherAppButton');

  static String get redemptionSuccessToastMessage =>
      Intl.message('Voucher copied to clipboard',
          name: 'redemptionSuccessToastMessage');

//endregion Redemption Success Page

  //region Account Deactivated Page

  static String get accountDeactivatedPageTitle => Intl.message(
        'It\'s sad to see you leave, but we hope to see you again soon',
        name: 'accountDeactivatedPageTitle',
      );

  static String get accountDeactivatedPageMessagePart1 => Intl.message(
        'You\'ll be missed',
        name: 'accountDeactivatedPageMessagePart1',
      );

  static String accountDeactivatedPageMessagePart2(String token) =>
      Intl.message(
        'We don’t want to see you go, deactivating your '
        'account permanently locks you out of all your $token benefits.',
        name: 'accountDeactivatedPageMessagePart2',
        args: [token],
      );

  static String accountDeactivatedPageMessagePart3(String contactNumber) =>
      Intl.message(
          'For further details, please contact our '
          'Customer Support Team on $contactNumber.',
          name: 'accountDeactivatedPageMessagePart3',
          args: [contactNumber],
          examples: const {'contactNumber': '+00 0000 000000'});

  static String get accountDeactivatedPageMessageClosePart1 => Intl.message(
        'Kind regards,',
        name: 'accountDeactivatedPageMessageClosePart1',
      );

  static String accountDeactivatedPageMessageClosePart2(String token) =>
      Intl.message(
        'The $token Team',
        name: 'accountDeactivatedPageMessageClosePart2',
        args: [token],
      );

  static String get accountDeactivatedPageContactButton => Intl.message(
        'Contact our support team',
        name: 'accountDeactivatedPageContactButton',
      );

  static String get accountDeactivatedLaunchContactNumberError => Intl.message(
        'Your phone app failed to launch',
        name: 'accountDeactivatedLaunchContactNumberError',
      );

//endregion Account Deactivated Page

//region Warning Dialog

  static String get warningDialogLeavingPageTitle => Intl.message(
        'Confirm action',
        name: 'warningDialogLeavingPageTitle',
      );

  static String get warningDialogLeavingPageDetails => Intl.message(
        'Are you sure you want to go back? '
        'We don’t want you to lose your progress',
        name: 'warningDialogLeavingPageDetails',
      );

  static String get warningDialogYesButton => Intl.message(
        'Yes',
        name: 'warningDialogYesButton',
      );

  static String get warningDialogNoButton => Intl.message(
        'No',
        name: 'warningDialogNoButton',
      );

  static String get warningDialogNoThanksButton => Intl.message(
        'No, thanks',
        name: 'warningDialogNoThanksButton',
      );

  static String get warningDialogGoToSettings => Intl.message(
        'Go to settings',
        name: 'warningDialogGoToSettings',
      );

//endregion Warning Dialog

//region Account Page
  static String get accountPageLogOutConfirmTitle => Intl.message(
        'Please confirm',
        name: 'accountPageLogOutConfirmTitle',
      );

  static String get accountPageLogOutConfirmContent => Intl.message(
        'Are you sure you want to log out?',
        name: 'accountPageLogOutConfirmContent',
      );

  static String get accountPageTitle => Intl.message(
        'My account',
        name: 'accountPageTitle',
      );

  static String get accountPagePersonalDetailsOption => Intl.message(
        'Personal details',
        name: 'accountPagePersonalDetailsOption',
      );

  static String get referralTrackingPersonalDetailsOption => Intl.message(
        'Referral tracking',
        name: 'referralTrackingPersonalDetailsOption',
      );

  static String get vouchersOption => Intl.message(
        'Vouchers',
        name: 'vouchersOption',
      );

  static String get accountPageChangePasswordOption => Intl.message(
        'Change password',
        name: 'accountPageChangePasswordOption',
      );

  static String get accountPageLogoutOption => Intl.message(
        'Log out',
        name: 'accountPageLogoutOption',
      );

  static String accountAppVersion(String appVersion) =>
      Intl.message('App version: $appVersion',
          name: 'accountAppVersion',
          args: [appVersion],
          examples: const {'appVersion': '0.0.7'});

  static String get accountPageBiometricsSignInOptionAndroid => Intl.message(
        'Sign-in with your fingerprint',
        name: 'accountPageBiometricsSignInOptionAndroid',
      );

  static String get accountPageBiometricsSignInOptionIOS => Intl.message(
        'Sign-in with Touch ID/Face ID',
        name: 'accountPageBiometricsSignInOptionIOS',
      );

  static String get contactUsPageDetail =>
      Intl.message('Feel free to get in touch with us for any help and support',
          name: 'contactUsPageDetail');

  static String get contactUsPhoneNumber =>
      Intl.message('Phone Number', name: 'contactUsPhoneNumber');

  static String get contactUsEmail =>
      Intl.message('Email', name: 'contactUsEmail');

  static String get contactUsWhatsApp =>
      Intl.message('Whatsapp', name: 'contactUsWhatsApp');

  static String get contactUsWhatsAppStartingMessage =>
      Intl.message('Hello', name: 'contactUsWhatsAppStartingMessage');

  static String get contactUsLaunchContactNumberError => Intl.message(
        'There was a problem launching your phone app.',
        name: 'contactUsLaunchContactNumberError',
      );

  static String get contactUsLaunchContactEmailError => Intl.message(
        'There was a problem launching your email app.',
        name: 'contactUsLaunchContactEmailError',
      );

  static String get contactUsGenericErrorSubtitle => Intl.message(
      'Sorry, we are unable to show contact information '
      'please try again.',
      name: 'contactUsGenericErrorSubtitle');

//endregion Account Page

//region Delete Account Dialog

  static String get deleteAccountDialogTitle => Intl.message(
        'Delete account',
        name: 'deleteAccountDialogTitle',
      );

  static String get deleteAccountDialogDetails => Intl.message(
        'Are you sure you want to delete your account?',
        name: 'deleteAccountDialogDetails',
      );

  static String get deleteAccountDialogDeleteButton => Intl.message(
        'Delete',
        name: 'deleteAccountDialogDeleteButton',
      );

  static String get deleteAccountDialogCancelButton => Intl.message(
        'Cancel',
        name: 'deleteAccountDialogCancelButton',
      );

//endregion Delete Account Dialog

//region Change password

  static String get changePasswordPagePrompt => Intl.message(
        'Please create a new password ',
        name: 'changePasswordPagePrompt',
      );

  static String get changePasswordPagePasswordLabel =>
      Intl.message('New password*', name: 'changePasswordPagePasswordLabel');

  static String get changePasswordPageConfirmPasswordHint =>
      Intl.message('Confirm new password',
          name: 'changePasswordPageConfirmPasswordHint');

  static String get changePasswordPagePasswordHint =>
      Intl.message('Enter new password',
          name: 'changePasswordPagePasswordHint');

//endregion Change password
//region Change password success
  static String get changePasswordSuccessTitle =>
      Intl.message('Password updated', name: 'changePasswordSuccessTitle');

  static String get changePasswordSuccessDetails =>
      Intl.message('Great! Your password has been changed.',
          name: 'changePasswordSuccessDetails');

  static String get changePasswordSuccessBackToAccountButton =>
      Intl.message('Back to account',
          name: 'changePasswordSuccessBackToAccountButton');

//endregion Change password success

//region Common Password elements

  static String get confirmPasswordLabel =>
      Intl.message('Confirm password*', name: 'confirmPasswordLabel');

  static String get passwordGuide => Intl.message(
      'We care about your security, '
      'please make sure your password has at least:',
      name: 'passwordGuide');

  static String get changePassword => Intl.message(
        'Change password',
        name: 'changePassword',
      );

//endregion Common Password elements

  //region Reset Password elements

  static String get resetPasswordTitle =>
      Intl.message('Enter email address', name: 'resetPasswordTitle');

  static String get resetPasswordSendLinkHint =>
      Intl.message('We’ll send you link to reset your password',
          name: 'resetPasswordSendLinkHint');

  static String get resetPasswordSentEmailHint => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Link has been sent, please check your email, if you didn’t receive it try to request it again',
      name: 'resetPasswordSentEmailHint');

  static String get resetPassword => Intl.message(
        'Reset password',
        name: 'resetPassword',
      );

  static String get resetPasswordPrompt => Intl.message(
        'Please create a new password and sign in again',
        name: 'resetPasswordPrompt',
      );

  static String get setPasswordSuccessTitle =>
      Intl.message('Password reset successfully',
          name: 'setPasswordSuccessTitle');

  static String get setPasswordSuccessDetails => Intl.message(
      'Your password has been reset please login with your new details',
      name: 'setPasswordSuccessDetails');

  static String get setPasswordSuccessBackToAccountButton =>
      Intl.message('Back to sign-in',
          name: 'setPasswordSuccessBackToAccountButton');

//endregion Reset Password elements

//region Pin elements
  static String get pinCreatedSuccessTitle =>
      Intl.message('PIN created', name: 'pinCreatedSuccessTitle');

  static String get pinCreatedSuccessDetails =>
      Intl.message('Great! your PIN has been created successfully',
          name: 'pinCreatedSuccessDetails');

  static String get pinErrorDoesNotMatch =>
      Intl.message('PIN does not match', name: 'pinErrorDoesNotMatch');

  static String pinErrorRemainingAttempts(int count) => Intl.message(
        // ignore: lines_longer_than_80_chars
        'You have $count attempts remaining after which you will need to sign-in with your email and password',
        name: 'pinErrorRemainingAttempts',
        args: [count],
      );

  static String get pinErrorIncorrectPassCode =>
      Intl.message('Incorect passcode, please retry',
          name: 'pinErrorIncorrectPassCode');

  static String get pinShow => Intl.message('Show PIN', name: 'pinShow');

  static String get pinHide => Intl.message('Hide PIN', name: 'pinHide');

  static String get pinConfirmHeading =>
      Intl.message('Confirm PIN', name: 'pinConfirmHeading');

  static String get pinConfirmDescription =>
      Intl.message('Please confirm your PIN', name: 'pinConfirmDescription');

  static String get pinCreateHeading =>
      Intl.message('Create a PIN', name: 'pinCreateHeading');

  static String pinCreateDescription(String appName) => Intl.message(
        'Create a PIN to quickly sign in to your $appName account next time',
        name: 'pinCreateDescription',
        args: [appName],
      );

  static String get pinSignInHeading =>
      Intl.message('Enter your PIN', name: 'pinSignInHeading');

  static String get pinSignInDescription =>
      Intl.message('Please enter your PIN to sign-in',
          name: 'pinSignInDescription');

  static String get pinVerificationDescription =>
      Intl.message('Please re-enter your PIN',
          name: 'pinVerificationDescription');

  static String get pinForgotButton =>
      Intl.message('Forgot?', name: 'pinForgotButton');

  static String get useFaceIDButton =>
      Intl.message('or use Face ID', name: 'useFaceIDButton');

  static String get useBiometricButton =>
      Intl.message('or use biometric', name: 'useBiometricButton');

  static String get useFingerprintButton =>
      Intl.message('or use fingerprint', name: 'useFingerprintButton');

  static String get pinForgotPageTitle =>
      Intl.message('Forgot your PIN?', name: 'pinForgotPageTitle');

  static String get pinForgotPageDescription => Intl.message(
      'Please sign in with your email and password after which you can set a '
      'new PIN.',
      name: 'pinForgotPageDescription');

  static String get pinForgotPageButton =>
      Intl.message('Proceed', name: 'pinForgotPageButton');

  //endregion Pin elements

//region P2P Transaction Page

  static String receiveTokenPageTitle(String token) => Intl.message(
        'Receive $token tokens',
        name: 'receiveTokenPageTitle',
        args: [token],
      );

  static String get receiveTokenPageSubDetails => Intl.message(
        'Share this code with the sender, you\'ll '
        'receive tokens quicker than you thought',
        name: 'receiveTokenPageSubDetails',
      );

  static String get receiveTokenPageGenericErrorTitle =>
      Intl.message('This doesn’t seem right',
          name: 'receiveTokenPageGenericErrorTitle');

  static String get receiveTokenPageGenericErrorSubtitle => Intl.message(
      'Oh no! We\'re unable to display the QR code. Please try again.',
      name: 'receiveTokenPageGenericErrorSubtitle');

//endregion P2P Transaction Page

//region Earn Page

  static String get referAHotelSectionTitle => Intl.message(
        'Refer a hotel',
        name: 'referAHotelSectionTitle',
      );

  static String get inviteFriendSectionTitle => Intl.message(
        'Invite a friend',
        name: 'inviteFriendSectionTitle',
      );

  static String get inviteFriendEarnUpToPart1 => Intl.message(
        'Earn up to ',
        name: 'inviteFriendEarnUpToPart1',
      );

  static String get inviteFriendEarnUpToPart2 => Intl.message(
        ' for every friend you invite to the app',
        name: 'inviteFriendEarnUpToPart2',
      );

  static String get earnRulePageInitialPageError =>
      Intl.message('Sorry, we are unable to load earn offers right now',
          name: 'earnRulePageInitialPageError');

  static String get earnRulePagePaginationError =>
      Intl.message('Sorry, we are unable to show more earn offers right now',
          name: 'earnRulePagePaginationError');

  static String get earnRulePageEmpty =>
      Intl.message('Sorry, it appears there are no earn offers right now',
          name: 'earnRulePageEmpty');

//endregion Earn Page

//region Earn Detail Page

  static String get earnDetailPageGenericErrorSubTitle => Intl.message(
      'Sorry, we are unable to show task details '
      'please try again.',
      name: 'earnDetailPageGenericErrorSubTitle');

  static String earnRuleValidDate(String fromDate, String toDate) =>
      Intl.message(
        'Valid : from $fromDate to $toDate',
        name: 'earnRuleValidDate',
        args: [fromDate, toDate],
      );

  static String get earnRuleUnlimitedParticipationInfo =>
      Intl.message('You can participate in this offer unlimited times',
          name: 'earnRuleUnlimitedParticipationInfo');

  static String get earnRuleOnlyOnceParticipationInfo =>
      Intl.message('You can participate in this only once',
          name: 'earnRuleOnlyOnceParticipationInfo');

  static String earnRuleLimitedParticipationInfo(int number) => Intl.message(
        'You can participate in this offer $number times',
        name: 'earnRuleLimitedParticipationInfo',
        args: [number],
      );

  static String earnRuleLimitedCompletionInfo(int number, int total) =>
      Intl.message(
        '$number / $total completed',
        name: 'earnRuleLimitedCompletionInfo',
        args: [number, total],
      );

  static String earnRuleUnlimitedCompletionInfo(int number) => Intl.message(
        '$number completed',
        name: 'earnRuleUnlimitedCompletionInfo',
        args: [number],
      );

  static String get earnRuleRewardBoxTitle =>
      Intl.message('Offer Award', name: 'earnRuleRewardBoxTitle');

  static String earnRuleRewardBoxSubTitle(String token) => Intl.message(
        'Earn $token tokens every time you complete the offer',
        name: 'earnRuleRewardBoxSubTitle',
        args: [token],
      );

  static String get earnRuleCampaignMissionTitle =>
      Intl.message('Offer mission', name: 'earnRuleCampaignMissionTitle');

  static String get earnRuleCampaignMissionSubtitle =>
      Intl.message('Finish the tasks below and earn the offer award',
          name: 'earnRuleCampaignMissionSubtitle');

  static String get earnRuleConditionCompleted =>
      Intl.message('Completed', name: 'earnRuleConditionCompleted');

  static String get earnRuleConditionGetStarted =>
      Intl.message('Get started', name: 'earnRuleConditionGetStarted');

  static String earnRuleCompletionMessage(String token) => Intl.message(
        'Congratulations! You have completed this offer! '
        'Have a look at other offers to continue earning ${token}s',
        name: 'earnRuleCompletionMessage',
        args: [token],
      );

  static String get earnRuleViewOtherOffers =>
      Intl.message('View other offers', name: 'earnRuleViewOtherOffers');

  static String get earnRuleDetailsHowItWorks => Intl.message(
        'How it works',
        name: 'earnRuleDetailsHowItWorks',
      );

  static String get earnRuleDetailsEarnUponCompletion => Intl.message(
        'Each time you complete this offer, you could earn ',
        name: 'earnRuleDetailsEarnUponCompletion',
      );

  static String get earnRuleDetailsEarnUponCompletionConversionRate =>
      Intl.message(
        ' (* indicative amount based on average night stay).',
        name: 'earnRuleDetailsEarnUponCompletionConversionRate',
      );

  static String get earnRuleDetailsStakingAmountPart1 => Intl.message(
        'This offer requires you to lock ',
        name: 'earnRuleDetailsStakingAmountPart1',
      );

  static String get earnRuleDetailsStakingAmountPart2 => Intl.message(
        ' to participate',
        name: 'earnRuleDetailsStakingAmountPart2',
      );

  static String get earnRuleDetailsParticipationLimit => Intl.message(
        'You can participate ',
        name: 'earnRuleDetailsParticipationLimit',
      );

  static String earnRuleDetailsParticipationCount(int participationCount) =>
      Intl.plural(
        participationCount,
        one: 'one time',
        other: '$participationCount times',
        args: [participationCount],
        name: 'earnRuleDetailsParticipationCount',
      );

  static String get earnRuleDetailsUnlimitedParticipation => Intl.message(
        'You can participate unlimited times.',
        name: 'earnRuleDetailsUnlimitedParticipation',
      );

  static String get earnRuleDetailsPreviousParticipationPart1 => Intl.message(
        'You have participated ',
        name: 'earnRuleDetailsPreviousParticipationPart1',
      );

  static String get earnRuleDetailsPreviousParticipationPart2 => Intl.message(
        ' and earned ',
        name: 'earnRuleDetailsPreviousParticipationPart2',
      );

  static String get earnRuleDetailsPreviousParticipationPart3 => Intl.message(
        ' so far',
        name: 'earnRuleDetailsPreviousParticipationPart3',
      );

  static String get earnRuleDetailsReadMoreButton => Intl.message(
        'Read more',
        name: 'earnRuleDetailsReadMoreButton',
      );

  static String get earnRuleDetailsOfferUnavailableTitle =>
      Intl.message('Offer unavailable',
          name: 'earnRuleDetailsOfferUnavailableTitle');

  static String get earnRuleDetailsViewOffersButton =>
      Intl.message('View other offers',
          name: 'earnRuleDetailsViewOffersButton');

  static String get earnRuleDetailsLowBalanceErrorPart1 =>
      Intl.message('You need ', name: 'earnRuleDetailsLowBalanceErrorPart1');

  static String get earnRuleDetailsLowBalanceErrorPart2 =>
      Intl.message(' in order to be eligible to participate in this offer.',
          name: 'earnRuleDetailsLowBalanceErrorPart2');

  static String get earnRuleDetailsParticipationLimitError => Intl.message(
      'You’ve reached the limit of times to participate in this offer.',
      name: 'earnRuleDetailsParticipationLimitError');

  //region How it works page

  static String get earnRuleIndicativeAmountInfoHospitality => Intl.message(
        '* This is an indicative amount based on average night stay.',
        name: 'earnRuleIndicativeAmountInfoHospitality',
      );

  static String get earnRuleIndicativeAmountInfoRealEstate => Intl.message(
        '* It will depend on the property price.',
        name: 'earnRuleIndicativeAmountInfoRealEstate',
      );

  static String get earnRuleIndicativeAmountInfoGeneric => Intl.message(
        '* This is an indicative amount.',
        name: 'earnRuleIndicativeAmountInfoGeneric',
      );

  static String get stakingDetailsPart1 => Intl.message(
        // ignore: lines_longer_than_80_chars
        'In order to be eligible to participate in this offer you need to lock ',
        name: 'stakingDetailsPart1',
      );

  static String get stakingDetailsRealEstatePart5 => Intl.message(
        // ignore: lines_longer_than_80_chars
        'You’ll be awarded upon completion of the different milestones during the purchase process.',
        name: 'stakingDetailsRealEstatePart5',
      );

  static String get stakingDetailsRealEstateStakingRulePart1 => Intl.message(
        'If your friend makes a purchase we will return ',
        name: 'stakingDetailsRealEstateStakingRulePart1',
      );

  static String get stakingDetailsRealEstateStakingRulePart2_100percent =>
      Intl.message(
        ' of the staking amount.',
        name: 'stakingDetailsRealEstateStakingRulePart2_100percent',
      );

  static String stakingDetailsRealEstateBurningRulePart1(String time) =>
      Intl.message(
        'If your friend doesn\'t accept the invite within $time you will lose ',
        args: [time],
        name: 'stakingDetailsRealEstateBurningRulePart1',
      );

  static String get stakingDetailsRealEstateBurningRulePart2 => Intl.message(
        ' of the staking amount.',
        name: 'stakingDetailsRealEstateBurningRulePart2',
      );

  static String get stakingDetailsLockedAmount => Intl.message(
        'Locked amount',
        name: 'stakingDetailsLockedAmount',
      );

  static String get stakingDetailsReward => Intl.message(
        'Award',
        name: 'stakingDetailsReward',
      );

  //endregion How it works page

//endregion Earn Detail Page

//region Common texts

  static String get copiedToClipboard => Intl.message(
        'Copied to Clipboard',
        name: 'copiedToClipboard',
      );

  static String amountTokens(int amount, String token) =>
      Intl.message(' $amount $token tokens ',
          name: 'amountTokens',
          args: [amount, token],
          desc: 'Amount of tokens',
          examples: const {'amount': 100, 'token': 'ABC'});

//endregion Common texts

//region Bottom bar texts

  static String get bottomBarExplore => Intl.message(
        'Explore',
        name: 'bottomBarExplore',
      );

  static String get bottomBarOffers => Intl.message(
        'Offers',
        name: 'bottomBarOffers',
      );

  static String get bottomBarWallet => Intl.message(
        'Wallet',
        name: 'bottomBarWallet',
      );

  static String get bottomBarSocial => Intl.message(
        'Social',
        name: 'bottomBarSocial',
      );

//endregion Bottom bar texts

//region Maintenance
  static String get maintenanceTitle => Intl.message(
        'Ongoing maintenance',
        name: 'maintenanceTitle',
      );

  static String maintenanceDescription(String period) => Intl.message(
        'We are undergoing some routine maintenance '
        'and will be up and running in the next $period',
        args: [period],
        name: 'maintenanceDescription',
      );

  static String get maintenanceErrorMessage => Intl.message(
        'The server is under maintenance. Please try again later.',
        name: 'maintenanceErrorMessage',
      );

  static String get maintenanceErrorCoupleOfHours => Intl.message(
        'couple of hours',
        name: 'maintenanceErrorCoupleOfHours',
      );

  static String hours(int hours) => Intl.plural(
        hours,
        one: '$hours hour',
        other: '$hours hours',
        args: [hours],
        name: 'hours',
      );

//endregion Maintenance

//region Payment Request Page

  static String get transferRequestTitle => Intl.message(
        'Transfer request',
        name: 'transferRequestTitle',
      );

  static String transferRequestIdHolder(String id) => Intl.message('ID : $id',
      name: 'transferRequestIdHolder',
      args: [id],
      desc: 'ID of the transfer request',
      examples: const {'id': '123456ABC'});

  static String transferRequestInfoHolder(String transferRequestOrganization) =>
      Intl.message(
          'You received a transfer request from $transferRequestOrganization. '
          'Please review and confirm it.',
          name: 'transferRequestInfoHolder',
          args: [transferRequestOrganization],
          desc: 'The entity that sends the transfer request',
          examples: const {'transferRequestOrganization': 'Rove Hotel'});

  static String get transferRequestTotalBillLabel => Intl.message(
        'Total Bill',
        name: 'transferRequestTotalBillLabel',
      );

  static String transferRequestTotalBillHolder(
    String amountTokens,
    String token,
    String amountCurrency,
    String currencyCode,
  ) =>
      Intl.message('$amountTokens $token ($amountCurrency $currencyCode)',
          name: 'transferRequestTotalBillHolder',
          args: [amountTokens, token, amountCurrency, currencyCode],
          desc: 'Placeholder for amount plus converted total amount',
          examples: const {
            'amountTokens': '741.66',
            'token': 'ABC',
            'amountCurrency': '1345.56',
            'currencyCode': 'AED'
          });

  static String get transferRequestWalletBalanceLabel => Intl.message(
        'Your wallet balance',
        name: 'transferRequestWalletBalanceLabel',
      );

  static String amountTokensHolder(String amount, String token) =>
      Intl.message('$amount $token tokens ',
          name: 'amountTokensHolder',
          args: [amount, token],
          desc: 'Amount of tokens',
          examples: const {'amount': '100.45', 'token': 'ABC'});

  static String get transferRequestRecipientLabel => Intl.message(
        'Recipient',
        name: 'transferRequestRecipientLabel',
      );

  static String get transferRequestRemainingTimeLabel => Intl.message(
        'Time remaining',
        name: 'transferRequestRemainingTimeLabel',
      );

  static String expirationFormatDays(int days) => Intl.plural(days,
      one: '$days day',
      other: '$days days',
      name: 'expirationFormatDays',
      args: [days]);

  static String transferRequestSendingAmountLabel(String token) => Intl.message(
        'Sending Amount ($token)',
        name: 'transferRequestSendingAmountLabel',
        args: [token],
      );

  static String transferRequestAmountExceedsRequestedError(
          String requestedAmount) =>
      Intl.message(
        'You cannot pay more than $requestedAmount',
        args: [requestedAmount],
        name: 'transferRequestAmountExceedsRequestedError',
      );

  static String get transferRequestGenericError => Intl.message(
        'We were unable to complete the transfer, please try again',
        name: 'transferRequestGenericError',
      );

  static String get transferRequestAmountIsZeroError =>
      Intl.message('Amount must be bigger than zero',
          name: 'transferRequestAmountIsZeroError');

  static String get transferRequestNotEnoughTokensError => Intl.message(
      'Sorry, you do not have enough tokens to complete this transaction.',
      name: 'transferRequestNotEnoughTokensError');

  static String get transferRequestInvalidStateError => Intl.message(
      'Something\'s wrong… '
      'The request seems to be already completed or cancelled.',
      name: 'transferRequestInvalidStateError');

  static String get transferRequestRejectButton => Intl.message(
        'Reject',
        name: 'transferRequestRejectButton',
      );

  static String get transferRequestRejectDialogText => Intl.message(
        'Are you sure you want to reject this transfer?',
        name: 'transferRequestRejectDialogText',
      );

  static String get transferRequestSuccessTitle => Intl.message(
        'Transfer submitted',
        name: 'transferRequestSuccessTitle',
      );

  static String get transferRequestSuccessDetails => Intl.message(
        'Great! Your transfer has been submitted',
        name: 'transferRequestSuccessDetails',
      );

//endregion Payment Request Page

//region Transfer Request Expired Page

  static String get transferRequestExpiredTitle => Intl.message(
        'Request expired',
        name: 'transferRequestExpiredTitle',
      );

  static String get transferRequestExpiredDetails => Intl.message(
        'This transfer request has expired, '
        'please ask the reception desk to send a new request ',
        name: 'transferRequestExpiredDetails',
      );

//endregion Transfer Request Expired Page

//region Payment Request List Page
  static String get transferRequestListPageTitle => Intl.message(
        'Transfer requests',
        name: 'transferRequestListPageTitle',
      );

  static String get transferRequestListGenericError => Intl.message(
        'Sorry, we are unable to show more transfer requests right now',
        name: 'transferRequestListGenericError',
      );

//endregion Payment Request List Page

//region PaymentRequestStatusCard

  static String get transferRequestStatusCardRecipientLabel => Intl.message(
        'Recipient',
        name: 'transferRequestStatusCardRecipientLabel',
      );

  static String get transferRequestStatusCardSendingAmountLabel => Intl.message(
        'Sending Amount',
        name: 'transferRequestStatusCardSendingAmountLabel',
      );

  static String get transferRequestStatusCardTotalBillLabel => Intl.message(
        'Total Bill',
        name: 'transferRequestStatusCardTotalBillLabel',
      );

  static String transferRequestStatusCardRecipientIdLabel(String recipientId) =>
      Intl.message(
        'ID: $recipientId',
        name: 'transferRequestStatusCardRecipientIdLabel',
        args: [recipientId],
        examples: const {'recipientId': '12345678'},
      );

  static String get transferRequestStatusCardStatusCancelled => Intl.message(
        'Cancelled',
        name: 'transferRequestStatusCardStatusCancelled',
      );

  static String get transferRequestStatusCardStatusCompleted => Intl.message(
        'Completed',
        name: 'transferRequestStatusCardStatusCompleted',
      );

  static String get transferRequestStatusCardStatusExpired => Intl.message(
        'Expired',
        name: 'transferRequestStatusCardStatusExpired',
      );

  static String get transferRequestStatusCardStatusFailed => Intl.message(
        'Failed',
        name: 'transferRequestStatusCardStatusFailed',
      );

  static String get transferRequestStatusCardStatusPending => Intl.message(
        'Pending',
        name: 'transferRequestStatusCardStatusPending',
      );

  static String get transferRequestStatusCardStatusConfirmed => Intl.message(
        'Confirmed',
        name: 'transferRequestStatusCardStatusConfirmed',
      );

  static String get transferRequestOngoingTab => Intl.message(
        'Ongoing',
        name: 'transferRequestOngoingTab',
      );

  static String get transferRequestCompletedTab => Intl.message(
        'Completed',
        name: 'transferRequestCompletedTab',
      );

  static String get transferRequestUnsuccessfulTab => Intl.message(
        'Unsuccessful',
        name: 'transferRequestUnsuccessfulTab',
      );

  static String get transferRequestEmptyOngoing => Intl.message(
        'You have no ongoing requests at the moment',
        name: 'transferRequestEmptyOngoing',
      );

  static String get transferRequestEmptyCompleted => Intl.message(
        'You have no completed requests at the moment',
        name: 'transferRequestEmptyCompleted',
      );

  static String get transferRequestEmptyUnsuccessful => Intl.message(
        'You have no unsuccessful requests at the moment',
        name: 'transferRequestEmptyUnsuccessful',
      );

//endregion PaymentRequestStatusCard

//region Hotel Pre Checkout Dialog

  static String get hotelPreCheckoutDialogHeading => Intl.message(
        'Thanks for staying with us',
        name: 'hotelPreCheckoutDialogHeading',
      );

  static String get hotelPreCheckoutDialogViewInvoiceButton => Intl.message(
        'View Invoice',
        name: 'hotelPreCheckoutDialogViewInvoiceButton',
      );

//endregion Hotel Pre Checkout Dialog

//region Biometric Authentication
  static String get biometricAuthenticationDialogTitleAndroid => Intl.message(
        'Do you want to enable fingerprint security?',
        name: 'biometricAuthenticationDialogTitleAndroid',
      );

  static String get biometricAuthenticationDialogMessageAndroid => Intl.message(
        'Next time, sign-in using your fingerprint. '
        'It\'s fast, easy and secure.',
        name: 'biometricAuthenticationDialogMessageAndroid',
      );

  static String get biometricAuthenticationDialogTitleIOS => Intl.message(
        'Do you want to enable Touch ID/Face ID?',
        name: 'biometricAuthenticationDialogTitleIOS',
      );

  static String get biometricAuthenticationDialogMessageIOS => Intl.message(
        'Next time, sign-in using Touch ID/Face ID. It\'s fast, easy and secure.',
        name: 'biometricAuthenticationDialogMessageIOS',
      );

  static String get biometricAuthenticationPromptTitle => Intl.message(
        'Hello',
        name: 'biometricAuthenticationPromptTitle',
      );

  static String get biometricAuthenticationPromptMessage => Intl.message(
        'Sign-in with your fingerprint',
        name: 'biometricAuthenticationPromptMessage',
      );

  static String get biometricsGoToSettingsDescription => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Biometric authentication is not set up on your device. Please enable either Touch ID or Face ID on your phone.',
      name: 'biometricsGoToSettingsDescription');

//endregion Biometric Authentication

//region Scanned Info Dialog

  static String get scannedInfoDialogTitle =>
      Intl.message('Scanned Info', name: 'scannedInfoDialogTitle');

  static String get scannedInfoDialogErrorMessage =>
      Intl.message('This QR code is currently unsupported',
          name: 'scannedInfoDialogErrorMessage');

  static String get scannedInfoDialogPositiveButton =>
      Intl.message('Open in browser', name: 'scannedInfoDialogPositiveButton');

  static String get scannedInfoDialogNegativeButton =>
      Intl.message('Cancel', name: 'scannedInfoDialogNegativeButton');

  static String scannedInfoDialogEmailPositiveButton(String token) =>
      Intl.message(
        'Transfer $token',
        args: [token],
        name: 'scannedInfoDialogEmailPositiveButton',
      );

//endregion Scanned Info Dialog

//region conversion Rate

  static String conversionRate(
    String currencyCode,
    String amount,
  ) =>
      Intl.message(
        '$amount $currencyCode',
        name: 'conversionRate',
        args: [currencyCode, amount],
        examples: const {
          'currencyCode': 'USD',
          'amount': '1345.56',
        },
      );

  static String noTokensConversionRateText(String token) => Intl.message(
        'Start earning $token now!',
        name: 'noTokensConversionRateText',
        args: [token],
      );

//endregion Wallet Conversion Rate

// region Personal Detail Page

  static String get personalDetailsFirstNameTitle => Intl.message(
        'First Name',
        name: 'personalDetailsFirstNameTitle',
      );

  static String get personalDetailsLastNameTitle => Intl.message(
        'Last Name',
        name: 'personalDetailsLastNameTitle',
      );

  static String get personalDetailsEmailTitle => Intl.message(
        'Email Address',
        name: 'personalDetailsEmailTitle',
      );

  static String get personalDetailsPhoneNumberTitle => Intl.message(
        'Phone Number',
        name: 'personalDetailsPhoneNumberTitle',
      );

  static String get personalDetailsCountryOfNationality =>
      Intl.message('Country of nationality',
          name: 'personalDetailsCountryOfNationality');

  static String get personalDetailsDeleteAccountButton =>
      Intl.message('Delete your account',
          name: 'personalDetailsDeleteAccountButton');

  static String get personalDetailsGenericError => Intl.message(
      'We are unable to get your personal details right now.'
      'Please try again.',
      name: 'personalDetailsGenericError');

// endregion Personal Detail Page

//region Email Verification
  static String get emailVerificationTitle =>
      Intl.message('Confirm email address', name: 'emailVerificationTitle');

  static String get emailVerificationMessage1 =>
      Intl.message('We’ve sent a confirmation to: ',
          name: 'emailVerificationMessage1');

  static String get emailVerificationMessage1Resent =>
      Intl.message('We’ve resent a confirmation to: ',
          name: 'emailVerificationMessage1Resent');

  static String get emailVerificationMessage2 => Intl.message(
      'Check your email and click on the confirmation link to continue',
      name: 'emailVerificationMessage2');

  static String get emailVerificationResetText =>
      Intl.message('Didn’t receive an email? resend the link',
          name: 'emailVerificationResetText');

  static String get registerWithAnotherAccountButton =>
      Intl.message('Register with another account',
          name: 'registerWithAnotherAccountButton');

  static String get emailVerificationButton =>
      Intl.message('Resend link', name: 'emailVerificationButton');

  static String get emailVerificationExceededMaxAttemptsError =>
      Intl.message('Too many attempts, please try again later',
          name: 'emailVerificationExceededMaxAttemptsError');

  static String emailVerificationLinkExpired(String email) => Intl.message(
        'This link has expired, we’ve sent a new one to $email, '
        'please check your email and use the new link',
        name: 'emailVerificationLinkExpired',
        args: [email],
        examples: const {'email': 'samplemail@gmail.com'},
      );

//endregion Email Verification

//region Email Verification Success Page
  static String get emailVerificationSuccessTitle =>
      Intl.message('Email confirmed', name: 'emailVerificationSuccessTitle');

  static String get emailVerificationSuccessDetails =>
      Intl.message('Thanks! your email address has been confirmed',
          name: 'emailVerificationSuccessDetails');

//endregion Email Verification Success Page

//region Previous Referrals

  static String get previousReferralsCardTypeRealEstate =>
      Intl.message('Real estate', name: 'previousReferralsCardTypeRealEstate');

  static String get previousReferralsCardTypeHospitality =>
      Intl.message('Hospitality', name: 'previousReferralsCardTypeHospitality');

  static String get previousReferralsCardTypeAppReferral =>
      Intl.message('App referral',
          name: 'previousReferralsCardTypeAppReferral');

  static String get previousReferralsCardAward =>
      Intl.message('award', name: 'previousReferralsCardAward');

  static String get previousReferralsCardTimeLeftToAccept =>
      Intl.message('Time left to accept',
          name: 'previousReferralsCardTimeLeftToAccept');

  static String get previousReferralsCardRemaining =>
      Intl.message('Remaining to earn', name: 'previousReferralsCardRemaining');

  static String get previousReferralsCardDontLose =>
      Intl.message('Don\'t lose your', name: 'previousReferralsCardDontLose');

  static String previousReferralsCardContact(String person) =>
      Intl.message('Contact $person',
          args: [person], name: 'previousReferralsCardContact');

  static String previousReferralsNameHolder(
          String firstName, String lastName) =>
      Intl.message('$firstName $lastName',
          args: [firstName, lastName], name: 'previousReferralsNameHolder');

//endregion Previous Referrals

//region Common Date

  static String get dateTimeToday =>
      Intl.message('Today', name: 'dateTimeToday');

  static String get dateTimeYesterday =>
      Intl.message('Yesterday', name: 'dateTimeYesterday');

//endregion Common Date

//region Partners

  static String multiplePartnersTitle(
          String firstPartnerName, int numberOfPartner) =>
      Intl.plural(numberOfPartner,
          one: '$firstPartnerName & $numberOfPartner other',
          other: '$firstPartnerName & $numberOfPartner others',
          name: 'multiplePartnersTitle',
          args: [firstPartnerName, numberOfPartner]);

  static String get viewPartnerDetailsButtonTitle =>
      Intl.message('View partner details',
          name: 'viewPartnerDetailsButtonTitle');

  static String get partnerDetailsPageTitle =>
      Intl.message('Partner Details', name: 'partnerDetailsPageTitle');

//endregion Partners

//region App Upgrade

  static String get nonMandatoryAppUpgradeDialogTitle =>
      Intl.message('New version available',
          name: 'nonMandatoryAppUpgradeDialogTitle');

  static String get nonMandatoryAppUpgradeDialogContent => Intl.message(
      'There is a new version of the app available to download. '
      'Please update so you can see the latest changes.',
      name: 'nonMandatoryAppUpgradeDialogContent');

  static String get nonMandatoryAppUpgradeDialogPositiveButton =>
      Intl.message('Update',
          name: 'nonMandatoryAppUpgradeDialogPositiveButton');

  static String get nonMandatoryAppUpgradeDialogNegativeButton =>
      Intl.message('No, thanks',
          name: 'nonMandatoryAppUpgradeDialogNegativeButton');

  static String get mandatoryAppUpgradePageTitle =>
      Intl.message('Update required', name: 'mandatoryAppUpgradePageTitle');

  static String get mandatoryAppUpgradePageContent => Intl.message(
      'There is a new version of the app available to download. '
      'Please update in order to continue.',
      name: 'mandatoryAppUpgradePageContent');

  static String get mandatoryAppUpgradePageButton =>
      Intl.message('Update', name: 'mandatoryAppUpgradePageButton');

//endregion App Upgrade

//region Privacy policy and Terms of Use

  static String get termsOfUse => Intl.message(
        'Terms of Use',
        name: 'termsOfUse',
      );

  static String get privacyPolicy =>
      Intl.message('Privacy policy', name: 'privacyPolicy');

  static String get and => Intl.message(' and ', name: 'and');

//endregion Privacy policy

//region Common texts

  static String get transferInProgress => Intl.message(
        'Transfer in progress',
        name: 'transferInProgress',
      );

  static String get goToWallet => Intl.message(
        'Go to Wallet',
        name: 'goToWallet',
      );

  static String transferInProgressDetails(String token) => Intl.message(
        'Your ${token}s'
        ' have been transferred. '
        'We’ll notify you when the operation is completed.',
        name: 'transferInProgressDetails',
        args: [token],
      );

//endregion Common texts

//region Service errors

  static String get customerBlockedError => Intl.message(
        'This account is currently blocked',
        name: 'customerBlockedError',
      );

  static String get customerDoesNotExistError => Intl.message(
        'Sorry, the customer could not be found',
        name: 'customerDoesNotExistError',
      );

  static String get customerPhoneIsMissingError => Intl.message(
        'Error. User\'s phone number could not be retrieved',
        name: 'customerPhoneIsMissingError',
      );

  static String get customerProfileDoesNotExistError => Intl.message(
        'Error. User could not be found',
        name: 'customerProfileDoesNotExistError',
      );

  static String get customerWalletBlockedError => Intl.message(
        'Sorry, your wallet is currently blocked '
        'and cannot process transactions',
        name: 'customerWalletBlockedError',
      );

  static String get emailIsAlreadyVerifiedError => Intl.message(
        'An account with this email already exists',
        name: 'emailIsAlreadyVerifiedError',
      );

  static String get invalidAmountError => Intl.message(
        'Oops… That\'s an invalid amount. '
        'Please enter a valid amount and retry.',
        name: 'invalidAmountError',
      );

  static String get invalidCredentialsError => Intl.message(
        'Error. Invalid credentials',
        name: 'invalidCredentialsError',
      );

  static String get invalidEmailFormatError => Intl.message(
        'Invalid email format',
        name: 'invalidEmailFormatError',
      );

  static String get invalidPasswordFormatError => Intl.message(
        'Please ensure the password adheres to the password policy',
        name: 'invalidPasswordFormatError',
      );

  static String get invalidPrivateAddressError => Intl.message(
        'This is not a valid wallet address. Please amend and retry',
        name: 'invalidPrivateAddressError',
      );

  static String get invalidPublicAddressError => Intl.message(
        'This is not a valid wallet address. Please amend and retry',
        name: 'invalidPublicAddressError',
      );

  static String get invalidSignatureError => Intl.message(
        'This is not a valid signature. Please amend and retry',
        name: 'invalidSignatureError',
      );

  static String get invalidWalletLinkSignatureError => Intl.message(
        'This is not a valid signature. Please amend and retry',
        name: 'invalidWalletLinkSignatureError',
      );

  static String get linkingRequestAlreadyApprovedError => Intl.message(
        'Error. This linking request has already been approved',
        name: 'linkingRequestAlreadyApprovedError',
      );

  static String get linkingRequestAlreadyExistsError => Intl.message(
        'Error. This linking request has already been submitted',
        name: 'linkingRequestAlreadyExistsError',
      );

  static String get linkingRequestDoesNotExistError => Intl.message(
        'Error. This linking request can not be found. Please retry.',
        name: 'linkingRequestDoesNotExistError',
      );

  static String get loginAlreadyInUseError => Intl.message(
        'An account with this email already exists',
        name: 'loginAlreadyInUseError',
      );

  static String get noCustomerWithSuchEmailError => Intl.message(
        'This customer does not exist',
        name: 'noCustomerWithSuchEmailError',
      );

  static String notEnoughTokensError(String token) => Intl.message(
        'Sorry, you do not have sufficient $token tokens for this operation',
        name: 'notEnoughTokensError',
        args: [token],
      );

  static String get paymentDoesNotExistError => Intl.message(
        'Sorry, we couldn\'t find this transfer request',
        name: 'paymentDoesNotExistError',
      );

  static String get paymentIsNotInACorrectStatusToBeUpdatedError =>
      Intl.message(
        'Something\'s wrong… '
        'The request seems to be already completed or cancelled.',
        name: 'paymentIsNotInACorrectStatusToBeUpdatedError',
      );

  static String get paymentRequestsIsForAnotherCustomerError => Intl.message(
        'Sorry, we couldn\'t find this transfer request',
        name: 'paymentRequestsIsForAnotherCustomerError',
      );

  static String get phoneAlreadyExistsError => Intl.message(
        'This phone is already verified',
        name: 'phoneAlreadyExistsError',
      );

  static String get phoneIsAlreadyVerifiedError => Intl.message(
        'An account with this phone number is already verified',
        name: 'phoneIsAlreadyVerifiedError',
      );

  static String get referralAlreadyConfirmedError => Intl.message(
        'You snooze, you lose… It appears this '
        'person has already been referred by another '
        'user. Please refer someone else.',
        name: 'referralAlreadyConfirmedError',
      );

  static String get referralAlreadyExistError => Intl.message(
        'Error. This user has already been referred',
        name: 'referralAlreadyExistError',
      );

  static String get referralNotFoundError => Intl.message(
        'Sorry, we couldn\'t find the referral. Please try again',
        name: 'referralNotFoundError',
      );

  static String get referralsLimitExceededError => Intl.message(
        'Wow! You\'re a superstar, you\'ve reached the referral limit',
        name: 'referralsLimitExceededError',
      );

  static String get senderCustomerNotFoundError => Intl.message(
        'Sorry, we couldn\'t find this account. Transfer cancelled',
        name: 'senderCustomerNotFoundError',
      );

  static String get targetCustomerNotFoundError => Intl.message(
        'Sorry, we couldn\'t find this account. Transfer cancelled',
        name: 'targetCustomerNotFoundError',
      );

  static String get tooManyLoginRequestError => Intl.message(
        'You\'ve exceeded your login attempts. Please contact support.',
        name: 'tooManyLoginRequestError',
      );

  static String get transferSourceAndTargetMustBeDifferentError => Intl.message(
        'The source and target wallets cannot be the same',
        name: 'transferSourceAndTargetMustBeDifferentError',
      );

  static String get transferSourceCustomerWalletBlockedError => Intl.message(
        'Sorry, your wallet is currently blocked and '
        'cannot accept this transaction',
        name: 'transferSourceCustomerWalletBlockedError',
      );

  static String get transferTargetCustomerWalletBlockedError => Intl.message(
        'Sorry, the target wallet is currently blocked and '
        'cannot accept this transaction',
        name: 'transferTargetCustomerWalletBlockedError',
      );

  static String get verificationCodeDoesNotExistError => Intl.message(
        'Error. The verification code is invalid',
        name: 'verificationCodeDoesNotExistError',
      );

  static String get verificationCodeExpiredError => Intl.message(
        'Error. The verification code has expired',
        name: 'verificationCodeExpiredError',
      );

  static String get verificationCodeMismatchError => Intl.message(
        'Error. The verification code is invalid',
        name: 'verificationCodeMismatchError',
      );

//endregion Service errors

//region Friend Referral
  static String get inviteAFriend => Intl.message(
        'Invite a Friend',
        name: 'inviteAFriend',
      );

  static String get inviteAFriendPageDetails => Intl.message(
        'Enter the details of a friend you would like to invite to the app',
        name: 'inviteAFriendPageDetails',
      );

  static String get friendReferralSuccessDetails => Intl.message(
        // ignore: lines_longer_than_80_chars
        'Great! Your referral has been submitted, we will notify you when the tokens are added to your wallet.',
        name: 'friendReferralSuccessDetails',
      );

//endregion Friend Referral

//region Vouchers

  static String get voucherListEmpty => Intl.message(
        'There are no vouchers available at the moment',
        name: 'voucherListEmpty',
      );

  static String get voucherCopied => Intl.message(
        'Voucher copied to clipboard',
        name: 'voucherCopied',
      );

//endregion Vouchers

//region Notifications
  static String get notifications => Intl.message(
        'Notifications',
        name: 'notifications',
      );

  static String get notificationListEmpty => Intl.message(
        'You have no notifications yet',
        name: 'notificationListEmpty',
      );

  static String minutesAgo(int minutes) => Intl.plural(minutes,
      one: '$minutes minute ago',
      other: '$minutes minutes ago',
      name: 'minutesAgo',
      args: [minutes]);

  static String hoursAgo(int hours) => Intl.plural(hours,
      one: '$hours hour ago',
      other: '$hours hours ago',
      name: 'hoursAgo',
      args: [hours]);

  static String daysAgo(int days) => Intl.plural(days,
      one: '$days day ago',
      other: '$days days ago',
      name: 'daysAgo',
      args: [days]);

  static String get notificationListMarkAllAsRead => Intl.message(
        'Mark all as read',
        name: 'notificationListMarkAllAsRead',
      );

  static String get newHeader => Intl.message(
        'New',
        name: 'newHeader',
      );

  static String get earlierHeader => Intl.message(
        'Earlier',
        name: 'earlierHeader',
      );

  static String get notificationListRequestGenericErrorSubtitle => Intl.message(
      'Sorry, we are unable to show your notifications, please try again.',
      name: 'notificationListRequestGenericErrorSubtitle');

//endregion Notifications

//region Email prefilling
  static String get emailSubject => Intl.message(
        'Subject',
        name: 'emailSubject',
      );

  static String get emailBody => Intl.message(
        'Body',
        name: 'emailBody',
      );

//endregion Email prefilling
}
