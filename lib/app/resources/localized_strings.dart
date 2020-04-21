import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
//  String get simpleMessage =>
//    Intl.message('Some simple localised message',
//        name: 'simpleMessage',
//        desc: 'Additional description of the context in which this message '
//            'is going to be used');
//
// ---------------------
////////////////////////////////////////
// 2. Message with parameters
// ---------------------
//  String greetingMessage(String name) =>
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
//  String remainingEmailsMessage(int howMany, String userName) =>
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
//  String notOnlineMessage(String userName, String userGender) =>
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

/// Can be used only from [HookWidget.build] method
LocalizedStrings useLocalizedStrings() => LocalizedStrings.of(useContext());

class LocalizedStrings {
  static Future<LocalizedStrings> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return LocalizedStrings();
    });
  }

  static LocalizedStrings of(BuildContext context) =>
      Localizations.of<LocalizedStrings>(context, LocalizedStrings);

//region Common API errors
  String get networkErrorTitle =>
      Intl.message('Internet connection problem', name: 'networkErrorTitle');

  String get networkError => Intl.message(
      'It seems you\'re not connected to the internet. '
      'Please check your connection and try again.',
      name: 'networkError');

  String genericError(String serviceNumber) => Intl.message(
        'Oops! It looks like something went wrong. Please try again. '
        'If the issue continues, contact our friendly '
        'customer service on $serviceNumber',
        args: [serviceNumber],
        name: 'genericError',
        examples: const {'serviceNumber': '+00 0000 000000'},
      );

  String get defaultGenericError => Intl.message(
      'Oops! It looks like something went wrong. '
      'Please try again.',
      name: 'defaultGenericError');

  String get genericErrorShort =>
      Intl.message('Please try again.', name: 'genericErrorShort');

  String get somethingIsNotRightError =>
      Intl.message('Something is not right, give it another go!',
          name: 'somethingIsNotRightError');

  String get couldNotLoadBalanceError => Intl.message(
      // ignore: lines_longer_than_80_chars
      'We are unable to make transactions at this point as we could not retrieve your balance. Please try again.',
      name: 'couldNotLoadBalanceError');

// endregion Common API errors

// region Customer API errors

  String get referralLeadAlreadyExistError => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Looks like this lovely person is already in our system, try referring someone else!',
      name: 'referralLeadAlreadyExistError');

  String get referralLeadAlreadyConfirmedError => Intl.message(
      'This person has already been referred to Real Estate. '
      'Your referral cannot be submitted.',
      name: 'referralLeadAlreadyConfirmedError');

  String get canNotReferYourselfError => Intl.message(
      'Self-referral is not possible. Your referral cannot be submitted.',
      name: 'canNotReferYourselfError');

  String get cannotGetOffersError => Intl.message(
        'Sorry, we are unable to show any offers at this moment, '
        'please try again',
        name: 'cannotGetOffersError',
      );

  String get noVouchersInStockError =>
      Intl.message('Sorry, all vouchers are sold out',
          name: 'noVouchersInStockError');

// endregion Customer API errors
//region Common Form Elements

  String feeLabel(String fee) => Intl.message(
        'Fee: $fee',
        name: 'feeLabel',
        args: [fee],
      );

  String transferTokenAmountLabel(String token) => Intl.message(
        'Transfer amount ($token)',
        name: 'transferTokenAmountLabel',
        args: [token],
      );

  String get emailRequiredLabel =>
      Intl.message('Email*', name: 'emailRequiredLabel');

  String get emailAddressHint => Intl.message(
        'Enter email address',
        name: 'emailAddressHint',
      );

  String get enterAmountHint => Intl.message(
        'Enter amount',
        name: 'enterAmountHint',
      );

  String get firstNameRequiredLabel =>
      Intl.message('First name*', name: 'firstNameRequiredLabel');

  String get firstNameNotRequiredLabel =>
      Intl.message('First name', name: 'firstNameNotRequiredLabel');

  String get firstNameHint =>
      Intl.message('Enter first name', name: 'firstNameHint');

  String get lastNameRequiredLabel =>
      Intl.message('Last name*', name: 'lastNameRequiredLabel');

  String get lastNameNotRequiredLabel =>
      Intl.message('Last name', name: 'lastNameNotRequiredLabel');

  String get lastNameHint =>
      Intl.message('Enter last name', name: 'lastNameHint');

  String get passwordRequiredLabel =>
      Intl.message('Password*', name: 'passwordRequiredLabel');

  String get passwordHint =>
      Intl.message('Enter password', name: 'passwordHint');

  String get phoneNumberLabel =>
      Intl.message('Phone Number', name: 'phoneNumberLabel');

  String get phoneNumberRequiredLabel =>
      Intl.message('Phone Number*', name: 'phoneNumberRequiredLabel');

  String get phoneNumberHint =>
      Intl.message('Enter phone number', name: 'phoneNumberHint');

  String get noteLabel => Intl.message('Notes', name: 'noteLabel');

  String get noteHint => Intl.message('Add additional notes', name: 'noteHint');

  String get nationalityLabel =>
      Intl.message('Nationality', name: 'nationalityLabel');

  String get nationalityOptionalLabel =>
      Intl.message('Nationality (optional)', name: 'nationalityOptionalLabel');

  String get nationalityHint =>
      Intl.message('Enter nationality', name: 'nationalityHint');

//endregion Common Form Elements

// region Common client side validation errors

  String get emptyEmailClientSideValidationError =>
      Intl.message('Email is required',
          name: 'emptyEmailClientSideValidationError');

  String get invalidEmailClientSideValidationError =>
      Intl.message('Please enter a valid email',
          name: 'invalidEmailClientSideValidationError');

  String get emptyNameClientSideValidationError =>
      Intl.message('Name is required',
          name: 'emptyNameClientSideValidationError');

  String get emptyFirstNameClientSideValidationError =>
      Intl.message('First name is required',
          name: 'emptyFirstNameClientSideValidationError');

  String get invalidFirstNameClientSideValidationError =>
      Intl.message('First name is invalid',
          name: 'invalidFirstNameClientSideValidationError');

  String get emptyLastNameClientSideValidationError =>
      Intl.message('Last name is required',
          name: 'emptyLastNameClientSideValidationError');

  String get emptyFullNameClientSideValidationError =>
      Intl.message('Name is required',
          name: 'emptyFullNameClientSideValidationError');

  String get invalidLastNameClientSideValidationError =>
      Intl.message('Last name is invalid',
          name: 'invalidLastNameClientSideValidationError');

  String get emptyCountryCodeClientSideValidationError =>
      Intl.message('Country code is required',
          name: 'emptyCountryCodeClientSideValidationError');

  String get emptyPhoneNumberClientSideValidationError =>
      Intl.message('Phone number is required',
          name: 'emptyPhoneNumberClientSideValidationError');

  String get invalidPhoneNumberClientSideValidationError =>
      Intl.message('Invalid phone number',
          name: 'invalidPhoneNumberClientSideValidationError');

  String minLengthClientSideValidationError(int minLength) => Intl.plural(
        minLength,
        one: 'Minimum length should be at least one character',
        other: 'Minimum length should be at least $minLength characters',
        name: 'minLengthClientSideValidationError',
        args: [minLength],
        examples: const {'minLegth': 2},
      );

  String minPhoneNumberLengthClientSideValidationError(int minLength) =>
      Intl.message(
        'Phone number should be at least $minLength digits long',
        name: 'minPhoneNumberLengthClientSideValidationError',
        args: [minLength],
      );

  String maxPhoneNumberLengthClientSideValidationError(int maxLength) =>
      Intl.message(
        'Phone number can only be a maximum of $maxLength digits long',
        name: 'maxPhoneNumberLengthClientSideValidationError',
        args: [maxLength],
      );

  String get invalidCharactersClientSideValidationError =>
      Intl.message('Invalid characters',
          name: 'invalidCharactersClientSideValidationError');

  String get emptyPasswordClientSideValidationError =>
      Intl.message('Password is required',
          name: 'emptyPasswordClientSideValidationError');

  String get passwordsDoNotMatchClientSideValidationError =>
      Intl.message('Passwords do not match',
          name: 'passwordsDoNotMatchClientSideValidationError');

  String get passwordInvalidCharactersClientSideValidationError =>
      Intl.message('Password contains invalid characters',
          name: 'passwordInvalidCharactersClientSideValidationError');

  String passwordTooShortError(int count) =>
      Intl.message('Make sure your password is at least $count characters long',
          name: 'passwordTooShortError',
          args: [count],
          examples: const {'count': 8});

  String passwordTooLongError(int count) =>
      Intl.message('Make sure your password is at most $count characters long',
          name: 'passwordTooLongError',
          args: [count],
          examples: const {'count': 100});

  String passwordUpperCaseError(int count) => Intl.plural(count,
      one: 'Make sure your password contains at least one upper case character',
      other: 'Make sure your password contains at least $count upper case '
          'characters',
      name: 'passwordUpperCaseError',
      args: [count],
      examples: const {'count': 1});

  String passwordLowerCaseError(int count) => Intl.plural(count,
      one: 'Make sure your password contains at least one lower case character',
      other: 'Make sure your password contains at least $count lower case '
          'characters',
      name: 'passwordLowerCaseError',
      args: [count],
      examples: const {'count': 1});

  String passwordNumberError(int count) => Intl.plural(count,
      one: 'Make sure your password contains at least one numeric character',
      other: 'Make sure your password contains at least $count numeric '
          'characters',
      name: 'passwordNumberError',
      args: [count],
      examples: const {'count': 1});

  String passwordSpecialCharactersError(int count, String specialCharacters) =>
      Intl.plural(count,
          one: 'Make sure your password contains '
              'at least one special character ($specialCharacters)',
          other: 'Make sure your password contains '
              'at least $count special characters ($specialCharacters)',
          name: 'passwordSpecialCharactersError',
          args: [count, specialCharacters],
          examples: const {'count': 1, 'specialCharacters': '!@#\$%&'});

  String get requiredCountryOfResidenceClientSideValidationError =>
      Intl.message('Please select a country',
          name: 'requiredCountryOfResidenceClientSideValidationError');

  String get requiredPhotoIdClientSideValidationError =>
      Intl.message('Photo ID is required',
          name: 'requiredPhotoIdClientSideValidationError');

  String get requiredPhotoIdFrontSideClientSideValidationError =>
      Intl.message('Photo on the front side is required',
          name: 'requiredPhotoIdFrontSideClientSideValidationError');

  String get requiredPhotoIdBackSideClientSideValidationError =>
      Intl.message('Photo on the back side is required',
          name: 'requiredPhotoIdBackSideClientSideValidationError');

  String maximumDecimalPlacesError(int precision) =>
      Intl.message('Amount should not exceed $precision decimal places',
          name: 'maximumDecimalPlacesError',
          args: [precision],
          examples: const {'precision': 2});

// endregion Common client side validation errors

//region Password Validation

  String get passwordInvalidError =>
      Intl.message('Make sure your password follows the rules below',
          name: 'passwordInvalidError');

  String passwordValidationMinCharacters(int count) =>
      Intl.message('$count characters',
          name: 'passwordValidationMinCharacters',
          args: [count],
          desc: 'count of characters',
          examples: const {'count': 8});

  String passwordValidationMinUpperCaseCharacters(int count) =>
      Intl.plural(count,
          one: 'One uppercase character',
          other: '$count uppercase characters',
          name: 'passwordValidationMinUpperCaseCharacters',
          args: [count],
          examples: const {'count': 1});

  String passwordValidationMinLowerCaseCharacters(int count) =>
      Intl.plural(count,
          one: 'One lowercase character',
          other: '$count lowercase characters',
          name: 'passwordValidationMinLowerCaseCharacters',
          args: [count],
          examples: const {'count': 1});

  String passwordValidationMinNumericCharacters(int count) => Intl.plural(count,
      one: 'One number',
      other: '$count numbers',
      name: 'passwordValidationMinNumericCharacters',
      args: [count],
      examples: const {'count': 1});

  String passwordValidationMinSpecialCharacters(
          int count, String specialCharacters) =>
      Intl.plural(count,
          one: 'One special character ($specialCharacters)',
          other: '$count special characters ($specialCharacters)',
          name: 'passwordValidationMinSpecialCharacters',
          args: [count, specialCharacters],
          examples: const {'count': 1, 'specialCharacters': '!@#\$%&'});

  String get passwordValidationAllowSpaces =>
      Intl.message('Spaces are allowed', name: 'passwordValidationAllowSpaces');

  String get passwordValidationDoNotAllowSpaces =>
      Intl.message('Spaces are not allowed',
          name: 'passwordValidationDoNotAllowSpaces');

//endregion Password Validation

// region Common Camera View
  String get cameraViewGuide => Intl.message(
      '•	Place fully in the frame, not cut off\n'
      '•	Avoid glare so that all info is visible\n'
      '•	Hold steady to avoid a blurry scan',
      name: 'cameraViewGuide');

  String get cameraPreviewTitle =>
      Intl.message('\nPleased with the result?', name: 'cameraPreviewTitle');

  String get cameraPreviewRetakeButton =>
      Intl.message('Retake', name: 'cameraPreviewRetakeButton');

// endregion Common Camera View

//region Common button labels
  String get submitButton => Intl.message('Submit', name: 'submitButton');

  String get nextPageButton => Intl.message('Next', name: 'nextPageButton');

  String get continueButton => Intl.message('Continue', name: 'continueButton');

  String get retryButton => Intl.message('Retry', name: 'retryButton');

  String get backToWalletButton =>
      Intl.message('Back to Wallet', name: 'backToWalletButton');

  String backToTokenWalletButton(String token) => Intl.message(
        'Back to $token Wallet',
        name: 'backToTokenWalletButton',
        args: [token],
      );

  String sendTokensButton(String token) => Intl.message(
        'Transfer $token',
        name: 'sendTokensButton',
        args: [token],
      );

  String get contactUsButton => Intl.message(
        'Contact us',
        name: 'contactUsButton',
      );

  String get getStartedButton =>
      Intl.message('Get started', name: 'getStartedButton');

  String get transferTokensButton =>
      Intl.message('Send points', name: 'transferTokensButton');

//endregion Common button labels

  //region Common Form elements

  String stepOf(String step, String totalSteps) =>
      Intl.message('$step of $totalSteps',
          name: 'stepOf',
          args: [step, totalSteps],
          examples: const {'step': '1', 'totalSteps': '3'});

  //endregion Common Form elements

//region Onboarding Page
  String onboardingPage1Title(String appName) => Intl.message(
        'Welcome to $appName',
        name: 'onboardingPage1Title',
        args: [appName],
      );

  String onboardingPage2Title(String token) => Intl.message(
        'Start earning $token points',
        name: 'onboardingPage2Title',
        args: [token],
      );

  String onboardingPage2Details(String token, String company) => Intl.message(
        'Earn $token points by referring friends to $company and much more',
        name: 'onboardingPage2Details',
        args: [token, company],
      );

  String onboardingPage3Title(String token) => Intl.message(
        'Use $token points easily',
        name: 'onboardingPage3Title',
        args: [token],
      );

  String onboardingPage3Details(String token, String company) => Intl.message(
        // ignore: lines_longer_than_80_chars
        'Use your $token points on $company for invoices, hotel stays, restaurants and much more',
        name: 'onboardingPage3Details',
        args: [token, company],
      );

  String get onboardingSkipButton =>
      Intl.message('Skip', name: 'onboardingSkipButton');

//endregion Onboarding Page

//region Welcome Page
  String welcomePageHeader(String appName) => Intl.message(
        'Welcome to $appName',
        name: 'welcomePageHeader',
        args: [appName],
      );

  String welcomePageSubHeader(String token) => Intl.message(
        'Earn and use ${token}s across the world',
        name: 'welcomePageSubHeader',
        args: [token],
      );

  String get welcomeSignInButtonText =>
      Intl.message('Sign in', name: 'welcomeSignInButtonText');

  String get welcomeCreateAccountButtonText =>
      Intl.message('Create an account', name: 'welcomeCreateAccountButtonText');

  String get socialOrContinueWith =>
      Intl.message('Or continue with', name: 'socialOrContinueWith');

//endregion

// region Login Page

  String get loginPageHeader =>
      Intl.message('Sign-in', name: 'loginPageHeader');

  String get loginPageEmailLabel =>
      Intl.message('Email', name: 'loginPageEmailLabel');

  String get loginPagePasswordLabel =>
      Intl.message('Password', name: 'loginPagePasswordLabel');

  String get loginPagePasswordHint =>
      Intl.message('Enter password', name: 'loginPagePasswordHint');

  String get loginPageLoginSubmitButton =>
      Intl.message('Sign in', name: 'loginPageLoginSubmitButton');

  String get loginPageForgottenPasswordButton =>
      Intl.message('Forgot password', name: 'loginPageForgottenPasswordButton');

  String get loginPageInvalidCredentialsError =>
      Intl.message('Your login details are incorrect. Please try again.',
          name: 'loginPageInvalidCredentialsError');

  String get loginPageUnauthorizedRedirectionMessage =>
      Intl.message('Your session has expired, please log in again',
          name: 'loginPageUnauthorizedRedirectionMessage');

  String loginPageLoginAttemptWarningMessage(int attemptNumber) =>
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

  String loginPageTooManyRequestMessage(int numberOfMinutes) =>
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
  String get personalDetailsHeader =>
      Intl.message('Personal Details', name: 'personalDetailsHeader');

  String get createAPasswordHeader =>
      Intl.message('Create a password', name: 'createAPasswordHeader');

  String get phoneNumberHeader =>
      Intl.message('Phone number', name: 'phoneNumberHeader');

  String get addPhoneAndRefCodeHeader =>
      Intl.message('Phone and referral code', name: 'addPhoneAndRefCodeHeader');

  String get registerPageHeader =>
      Intl.message('Register', name: 'registerPageHeader');

  String get registerPageRegisterSubmitButton =>
      Intl.message('Register', name: 'registerPageRegisterSubmitButton');

  String get registerPageBackendInvalidEmailError =>
      Intl.message('Invalid email',
          name: 'registerPageBackendInvalidEmailError');

  String get registerPageBackendInvalidPasswordError =>
      Intl.message('Invalid password',
          name: 'registerPageBackendInvalidPasswordError');

  String get registerPageLoginAlreadyInUseError =>
      Intl.message('Login already in use',
          name: 'registerPageLoginAlreadyInUseError');

  String get registerPageAgreeTermsOfUse =>
      Intl.message('I agree with the ', name: 'registerPageAgreeTermsOfUse');

  String get registerPageAgreeTermsOfUseError =>
      Intl.message('Please accept the Terms of Use and Privacy Policy below',
          name: 'registerPageAgreeTermsOfUseError');

// endregion Register Page

// region Set phone number page
  String get setPhoneNumberPageTitle =>
      Intl.message('Add phone number', name: 'setPhoneNumberPageTitle');

  String get setPhoneNumberVerifyButton =>
      Intl.message('Verify', name: 'setPhoneNumberVerifyButton');

// endregion Set phone number page

//region Phone Number Verification Page

  String get phoneNumberVerificationPageTitle =>
      Intl.message('Enter code', name: 'phoneNumberVerificationPageTitle');

  String phoneNumberVerificationDetails(String phoneNumber) =>
      Intl.message('We’ve sent a verification code  to $phoneNumber',
          args: [phoneNumber], name: 'phoneNumberVerificationDetails');

  String get phoneNumberVerificationCodeResent =>
      Intl.message('Verification code was re-sent',
          name: 'phoneNumberVerificationCodeResent');

  String get phoneNumberVerificationRequestNewCode =>
      Intl.message('Request a new verification code',
          name: 'phoneNumberVerificationRequestNewCode');

  String phoneNumberVerificationResendCodeTimer(String timeLeft) =>
      Intl.message(
        'Resend code in $timeLeft',
        name: 'phoneNumberVerificationResendCodeTimer',
        args: [timeLeft],
        examples: const {'timeLeft': '00:50'},
      );

  String get phoneNumberVerificationCodeNotSentError =>
      Intl.message('Verification code was not sent, please retry',
          name: 'phoneNumberVerificationCodeNotSentError');

  String get phoneNumberVerificationExpiredCodeError =>
      Intl.message('This code has expired, please request a new one',
          name: 'phoneNumberVerificationExpiredCodeError');

//
  String get phoneNumberVerificationInvalidCodeError =>
      Intl.message('Incorrect code, please check it and try again',
          name: 'phoneNumberVerificationInvalidCodeError');

//endregion Phone Number Verification Page

// region Country Code list Page

  String get countryCodeListPageTitle =>
      Intl.message('Select your country code',
          name: 'countryCodeListPageTitle');

  String get countryCodeEmptyPrompt =>
      Intl.message('Code', name: 'countryCodeEmptyPrompt');

// endregion Country Code list Page

// region Country list Page

  String get countryListPageTitle =>
      Intl.message('Select country', name: 'countryListPageTitle');

// endregion Country list Page

// region Nationality list Page

  String get nationalityListPageTitle =>
      Intl.message('Select nationality', name: 'nationalityListPageTitle');

// endregion Nationality list Page

// region common country list text

  String get countryListFilterHint =>
      Intl.message('Search for country name', name: 'countryListFilterHint');

// endregion common country list text

// region common list text

  String get listNoResultsTitle =>
      Intl.message('No results found', name: 'listNoResultsTitle');

  String get listNoResultsDetails =>
      Intl.message('We can’t find any item matching your search',
          name: 'listNoResultsDetails');

// endregion common list text

//region Home Page

  String get search => Intl.message(
        'Search',
        name: 'search',
      );

  String get yourOffers => Intl.message(
        'Your offers',
        name: 'yourOffers',
      );

  String get monthlyChallenges => Intl.message(
        'Monthly challenges',
        name: 'monthlyChallenges',
      );

  String get monthlyChallengesSubtitle => Intl.message(
        'Test yourself and earn points',
        name: 'monthlyChallengesSubtitle',
      );

  String get homePageCountdownTitle =>
      Intl.message('Countdown!', name: 'homePageCountdownTitle');

  String get homePageCountdownSubtitle =>
      Intl.message('are waiting for you, hurry up',
          name: 'homePageCountdownSubtitle');

  String homePageCountdownViewAll(int count) =>
      Intl.message('View all ($count)',
          args: [count], name: 'homePageCountdownViewAll');

//endregion Home Page

//region Offers

  String get offers => Intl.message('Offers', name: 'offers');

  String get earn => Intl.message('Earn', name: 'earn');

  String get redeem => Intl.message('Redeem', name: 'redeem');

//endregion Offers

// region Balance Box

  String get balanceBoxErrorMessage =>
      Intl.message('Sorry, we are unable to process your balance',
          name: 'balanceBoxErrorMessage');

  String get balanceBoxHeader =>
      Intl.message('Balance', name: 'balanceBoxHeader');

// endregion Balance Box

// region Wallet Page

  String get walletPageMyTotalTokens => Intl.message(
        'My total points',
        name: 'walletPageMyTotalTokens',
      );

  String get walletPageTitle => Intl.message(
        'Wallet',
        name: 'walletPageTitle',
      );

  String get transfer => Intl.message(
        'Transfer',
        name: 'transfer',
      );

  String get receive => Intl.message(
        'Receive',
        name: 'receive',
      );

  String get requests => Intl.message(
        'Requests',
        name: 'requests',
      );

  String from(String sender) => Intl.message(
        'From $sender',
        name: 'from',
        args: [sender],
      );

  String to(String recipient) => Intl.message(
        'To $recipient',
        name: 'to',
        args: [recipient],
      );

  String walletPageSendButtonSubtitle(String token) => Intl.message(
        'Send $token points to anyone',
        name: 'walletPageSendButtonSubtitle',
        args: [token],
      );

  String walletPageReceiveButtonTitle(String token) => Intl.message(
        'Receive $token points',
        name: 'walletPageReceiveButtonTitle',
        args: [token],
      );

  String walletPageReceiveButtonSubtitle(String token) => Intl.message(
        'Receive points from other $token users',
        name: 'walletPageReceiveButtonSubtitle',
        args: [token],
      );

  String get walletPageTransferRequestsTitle =>
      Intl.message('Transfer requests',
          name: 'walletPageTransferRequestsTitle');

  String get externalWalletTitle =>
      Intl.message('Your external wallet', name: 'externalWalletTitle');

  String get externalWalletHint =>
      Intl.message('Link to your account', name: 'externalWalletHint');

  String externalLinkWalletDescription(String token) => Intl.message(
        'Before sending and receiving ${token}s'
        ', you need to link an Ethereum wallet, here is how to link it',
        name: 'externalLinkWalletDescription',
        args: [token],
      );

  String get linkSimpleWalletDescription => Intl.message(
      // ignore: lines_longer_than_80_chars
      'To link to a simple wallet, copy the linking url and paste in your external wallet',
      name: 'linkSimpleWalletDescription');

  String walletPagePaymentRequestsSubtitle(int count) => Intl.plural(count,
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

  String get walletPageTransactionHistoryEmpty =>
      Intl.message('Once you have a few transactions you will see them here',
          name: 'walletPageTransactionHistoryEmpty');

  String walletPageTransactionHistorySentType(String token) => Intl.message(
        'Sent $token points',
        name: 'walletPageTransactionHistorySentType',
        args: [token],
      );

  String walletPageTransactionHistoryReceivedType(String token) => Intl.message(
        'Received $token points',
        name: 'walletPageTransactionHistoryReceivedType',
        args: [token],
      );

  String get walletPageTransactionHistoryRewardType =>
      Intl.message('Award', name: 'walletPageTransactionHistoryRewardType');

  String get walletPageTransactionHistoryRefundType =>
      Intl.message('Refund', name: 'walletPageTransactionHistoryRefundType');

  String get walletPageTransactionHistoryPaymentType =>
      Intl.message('Property Purchase',
          name: 'walletPageTransactionHistoryPaymentType');

  String get walletPageTransactionHistoryWalletLinkingType =>
      Intl.message('Wallet Linking Fee',
          name: 'walletPageTransactionHistoryWalletLinkingType');

  String get walletPageTransactionHistoryTransferToExternalType =>
      Intl.message('Transfer to external wallet',
          name: 'walletPageTransactionHistoryTransferToExternalType');

  String get walletPageTransactionHistoryTransferFromExternalType =>
      Intl.message('Transfer from external wallet',
          name: 'walletPageTransactionHistoryTransferFromExternalType');

  String get walletPageTransactionHistoryTransferFeeType =>
      Intl.message('Transfer Fee',
          name: 'walletPageTransactionHistoryTransferFeeType');

  String get walletPageTransactionHistoryVoucherPurchaseType =>
      Intl.message('Voucher purchase',
          name: 'walletPageTransactionHistoryVoucherPurchaseType');

  String get walletPageTransactionHistoryTitle =>
      Intl.message('History', name: 'walletPageTransactionHistoryTitle');

  String get walletPageTransactionHistoryInitialPageError =>
      Intl.message('Sorry, we are unable to load this section right now',
          name: 'walletPageTransactionHistoryInitialPageError');

  String get walletPageTransactionHistoryPaginationError =>
      Intl.message('Sorry, we are unable to show more transactions right now',
          name: 'walletPageTransactionHistoryPaginationError');

  String get walletPageWalletDisabledError =>
      Intl.message('Wallet disabled', name: 'walletPageWalletDisabledError');

  String get walletPageWalletDisabledErrorMessage => Intl.message(
      'Sorry, your wallet has been disabled, '
      'please contact us to resolve the issue.',
      name: 'walletPageWalletDisabledErrorMessage');

// endregion Wallet Page

// region Lead Referral Page
  String get leadReferralPageTitle =>
      Intl.message('Refer a friend', name: 'leadReferralPageTitle');

  String get leadReferralFormPageCommunityOfInterestLabel => Intl.message(
        'Community/Property of interest',
        name: 'leadReferralFormPageCommunityOfInterestLabel',
      );

// endregion Lead Referral Page

// region Lead Referral Success Page
  String leadReferralSuccessPageDetails(
    String refereeFirstName,
    String refereeLastName,
  ) =>
      Intl.message(
        // ignore: lines_longer_than_80_chars
        'Great! You\'ve successfully referred $refereeFirstName $refereeLastName',
        args: [refereeFirstName, refereeLastName],
        name: 'leadReferralSuccessPageDetails',
      );

  String leadReferralSuccessPageDetailsPartnerName(String partnerName) =>
      Intl.message(
        ' to $partnerName properties',
        args: [partnerName],
        name: 'leadReferralSuccessPageDetailsPartnerName',
      );

// endregion Lead Referral Success Page

//region Referral Success shared elements

  String get referralSuccessPageTitle =>
      Intl.message('Referral submitted', name: 'referralSuccessPageTitle');

  String get referralSuccessPageSubDetails => Intl.message(
        'You can track the progress in the referral section',
        name: 'referralSuccessPageSubDetails',
      );

  String get referralSuccessGoToRefsButton => Intl.message(
        'Go to referrals',
        name: 'referralSuccessGoToRefsButton',
      );

//endregion Referral Success shared elements

//region LeadReferralAcceptedPage

  String get leadReferralAcceptedSuccessBody => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Thanks for accepting the referral.',
      name: 'leadReferralAcceptedSuccessBody');

//endregion LeadReferralAcceptedPage

// region Hotel Referral Page
  String get hotelReferralPageTitle =>
      Intl.message('Refer a hotel', name: 'hotelReferralPageTitle');

  String get hotelReferralPageDescription =>
      Intl.message('Please enter your referral\'s email address',
          name: 'hotelReferralPageDescription');

  String get hotelReferralPageButton =>
      Intl.message('Send invite', name: 'hotelReferralPageButton');

  String hotelReferralPartnerInfo(String partnerName) => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Please enter the details for the person you would like to refer to $partnerName properties. ',
      args: [partnerName],
      name: 'hotelReferralPartnerInfo');

  String get hotelReferralStakingInfo =>
      Intl.message('You are required to lock ',
          name: 'hotelReferralStakingInfo');

  String get hotelReferralFullNameFieldLabel =>
      Intl.message('Full name*', name: 'hotelReferralFullNameFieldLabel');

  String get hotelReferralFullNameFieldHint =>
      Intl.message('Enter full name', name: 'hotelReferralFullNameFieldHint');

// endregion Hotel Referral Page

// region Hotel Referral Success Page
  String hotelReferralSuccessPageDetails(String refereeFullName) =>
      Intl.message(
        'Great! You\'ve successfully referred $refereeFullName',
        args: [refereeFullName],
        name: 'hotelReferralSuccessPageDetails',
      );

  String hotelReferralSuccessPageDetailsPartnerName(String partnerName) =>
      Intl.message(
        ' to $partnerName',
        args: [partnerName],
        name: 'hotelReferralSuccessPageDetailsPartnerName',
      );

// endregion Hotel Referral Success Page

  // region Hotel Referral Accepted Page
  String hotelReferralAcceptedSuccessBody(String token, String company) =>
      Intl.message(
        // ignore: lines_longer_than_80_chars
        'Thanks for accepting the referral, the next time you stay at $company hotel you will be awarded with $token points',
        name: 'hotelReferralAcceptedSuccessBody', args: [token, company],
      );

// endregion Hotel Referral Accepted Page

// region Hotel Referral Error Page
  String get hotelReferralErrorTitle => Intl.message(
        'Invite unsuccessful',
        name: 'hotelReferralErrorTitle',
      );

  String get hotelReferralErrorDetails => Intl.message(
        'We were unable submit your referral, please retry',
        name: 'hotelReferralErrorDetails',
      );

  String get hotelReferralErrorLeadAlreadyExists =>
      Intl.message('This referral already exists.',
          name: 'hotelReferralErrorLeadAlreadyExists');

// endregion Hotel Referral Error Page

// region Referral list Page
  String get referralListPageTitle =>
      Intl.message('Referrals', name: 'referralListPageTitle');

  String get referralListPageDescription =>
      Intl.message('Track all your referrals here',
          name: 'referralListPageDescription');

  String get referralListRequestGenericErrorSubtitle => Intl.message(
      'Sorry, we are unable to show your referrals, '
      'please try again.',
      name: 'referralListRequestGenericErrorSubtitle');

  String get referralListRequestGenericErrorTitle =>
      Intl.message('Hmm… seems like something is not right',
          name: 'referralListRequestGenericErrorTitle');

  String get pendingReferralListEmptyState =>
      Intl.message('You have no pending referrals at the moment',
          name: 'pendingReferralListEmptyState');

  String get approvedReferralListEmptyState =>
      Intl.message('You have no approved referrals at the moment',
          name: 'approvedReferralListEmptyState');

  String get expiredReferralListEmptyState =>
      Intl.message('You have no expired referrals at the moment',
          name: 'expiredReferralListEmptyState');

  String get referralListOngoingTab =>
      Intl.message('Ongoing', name: 'referralListOngoingTab');

  String get referralListCompletedTab =>
      Intl.message('Completed', name: 'referralListCompletedTab');

  String get referralListExpiredTab =>
      Intl.message('Expired', name: 'referralListExpiredTab');

// endregion Referral list Page

//region Referral Shared Elements

  String get referralAcceptedSuccessTitle =>
      Intl.message('Referral accepted', name: 'referralAcceptedSuccessTitle');

  String get referralAcceptedTitle =>
      Intl.message('Referral', name: 'referralAcceptedTitle');

  String get referralAcceptedNotFoundError =>
      Intl.message('Referral not found', name: 'referralAcceptedNotFoundError');

  String get referralAcceptedInvalidCode =>
      Intl.message('Invalid Referral Code.',
          name: 'referralAcceptedInvalidCode');

//endregion Referral Shared Elements

//region P2P Transaction Page

  String transactionFormPageTitle(String token) => Intl.message(
        'Transfer $token points',
        name: 'transactionFormPageTitle',
        args: [token],
      );

  String transactionFormPageSubDetails(String token) => Intl.message(
        'Transfer $token points easily, scan the receivers QR'
        ' code or enter their email address',
        name: 'transactionFormPageSubDetails',
        args: [token],
      );

  String transactionFormStakedAmount(String lockedAmount) => Intl.message(
        '$lockedAmount are locked',
        args: [lockedAmount],
        name: 'transactionFormStakedAmount',
      );

  String get transactionFormScanQRCode => Intl.message(
        'Scan QR Code',
        name: 'transactionFormScanQRCode',
      );

  String get transactionFormOr => Intl.message(
        'or',
        name: 'transactionFormOr',
      );

  String get transactionReceiverEmailAddressLabel => Intl.message(
        'Receiver email address',
        name: 'transactionReceiverEmailAddressLabel',
      );

  String get transactionReceiverEmailAddressHint => Intl.message(
        'Enter receiver email address',
        name: 'transactionReceiverEmailAddressHint',
      );

  String transactionAmountTokensLabel(String token) => Intl.message(
        'Amount ($token points)',
        args: [token],
        name: 'transactionAmountTokensLabel',
      );

  String get transactionAmountOfTokensHint => Intl.message(
        'How many points are required?',
        name: 'transactionAmountOfTokensHint',
      );

  String get transactionEmptyAddressError =>
      Intl.message('Wallet address is required',
          name: 'transactionEmptyAddressError');

  String get transactionInvalidAddressError => Intl.message(
        'Are you sure that\'s your wallet address?',
        name: 'transactionInvalidAddressError',
      );

  String get transactionAmountRequiredError => Intl.message(
        'Transaction amount is required',
        name: 'transactionAmountRequiredError',
      );

  String get transactionAmountInvalidError => Intl.message(
        'Transaction amount is not valid',
        name: 'transactionAmountInvalidError',
      );

  String get transactionAmountGreaterThanBalanceError => Intl.message(
        'Your balance is too low for this transaction.',
        name: 'transactionAmountGreaterThanBalanceError',
      );

  String get barcodeScanPermissionError => Intl.message(
        'Camera permission is required for QR code scanning.',
        name: 'barcodeScanPermissionError',
      );

  String get barcodeScanError => Intl.message(
        'There was a problem scanning the QR code. Please try again.',
        name: 'barcodeScanError',
      );

  String get copyEmail => Intl.message('Copy email', name: 'copyEmail');

//endregion P2P Transaction Page

//region Transaction Success Page

  String get transactionSuccessTitle => Intl.message(
        'Transfer submitted',
        name: 'transactionSuccessTitle',
      );

  String get transactionSuccessDetails => Intl.message(
        'Thanks for submitting your payment. '
        'We\'ll let you know once it\'s processed.',
        name: 'transactionSuccessDetails',
      );

//endregion Transaction Success Page

  //region Wallet linking

  String get insufficientFunds => Intl.message(
        'You have insufficient funds to link to an external wallet',
        name: 'insufficientFunds',
      );

  String get linkYourWallet => Intl.message(
        'Link to your account',
        name: 'linkYourWallet',
      );

  String get walletLinkingInProgress => Intl.message(
        'Wallet linking in progress',
        name: 'walletLinkingInProgress',
      );

  String get linkSimpleWalletInstructionCopyUrl => Intl.message(
        'Copy this url',
        name: 'linkSimpleWalletInstructionCopyUrl',
      );

  String get linkSimpleWalletInstructionSwitchToWallet => Intl.message(
        'Switch to the wallet app you want to link',
        name: 'linkSimpleWalletInstructionSwitchToWallet',
      );

  String get linkSimpleWalletInstructionPasteAddress => Intl.message(
        'Paste it in the address field',
        name: 'linkSimpleWalletInstructionPasteAddress',
      );

  String get linkSimpleWalletInstructionPasteLink => Intl.message(
        'Press "link wallet"',
        name: 'linkSimpleWalletInstructionPasteLink',
      );

  String get linkWalletInstructionSelectWallet => Intl.message(
        'Select a wallet from the options below',
        name: 'linkWalletInstructionSelectWallet',
      );

  String get linkWalletInstructionConfirmLinking => Intl.message(
        'Follow the instructions to confirm the linking',
        name: 'linkWalletInstructionConfirmLinking',
      );

  String get linkWalletInstructionFees => Intl.message(
        'Linking external wallets has associated fees',
        name: 'linkWalletInstructionFees',
      );

  String get linkWalletChooseSupportedWallets => Intl.message(
        'Choose any supported wallet',
        name: 'linkWalletChooseSupportedWallets',
      );

  String get linkWalletHeader => Intl.message(
        'Link an external wallet',
        name: 'linkWalletHeader',
      );

  String get linkSimpleWalletHeader => Intl.message(
        'Link a simple wallet',
        name: 'linkSimpleWalletHeader',
      );

  String get simpleWalletsTitle => Intl.message(
        'Simple wallets',
        name: 'simpleWalletsTitle',
      );

  String get simpleWalletsDescription => Intl.message(
        'Metamask, Coinbase, Trust wallet, ...',
        name: 'simpleWalletsDescription',
      );

  String get advancedWalletsTitle => Intl.message(
        'Advanced wallets',
        name: 'advancedWalletsTitle',
      );

  String get advancedWalletsDescription => Intl.message(
        'My Crypto, My Ether Wallet, …',
        name: 'advancedWalletsDescription',
      );

  String get dapBrowserHint => Intl.message(
        'You can also copy the linking url to open in a dApp Browser',
        name: 'dapBrowserHint',
      );

  String get linkWalletInProgressHeader => Intl.message(
        'Linking in progress',
        name: 'linkWalletInProgressHeader',
      );

  String get linkWalletInProgressTitle => Intl.message(
        'Your wallet is currently being linked',
        name: 'linkWalletInProgressTitle',
      );

  String get linkWalletInProgressDescription => Intl.message(
        // ignore: lines_longer_than_80_chars
        'This may take a while, you can continue using the app we will let you know once it completed',
        name: 'linkWalletInProgressDescription',
      );

  String get linkedWalletHeader => Intl.message(
        'Your external wallet',
        name: 'linkedWalletHeader',
      );

  String get sendToExternalWalletButton => Intl.message(
        'Transfer to external wallet',
        name: 'sendToExternalWalletButton',
      );

  String sendToExternalWalletButtonSubtitle(String token) => Intl.message(
        'From $token wallet to external wallet',
        name: 'sendToExternalWalletButtonSubtitle',
        args: [token],
      );

  String get receiveExternalWalletButton => Intl.message(
        'Receive from external wallet',
        name: 'receiveExternalWalletButton',
      );

  String receiveExternalWalletButtonSubtitle(String token) => Intl.message(
        'From external wallet to $token wallet',
        name: 'receiveExternalWalletButtonSubtitle',
        args: [token],
      );

  String get unlinkExternalWalletButton => Intl.message(
        'Unlink external wallet',
        name: 'unlinkExternalWalletButton',
      );

  String get unlinkExternalWalletButtonSubtitle => Intl.message(
        'Remove external wallet from your account',
        name: 'unlinkExternalWalletButtonSubtitle',
      );

  String get linkAdvancedWalletHeader => Intl.message(
        'Link an advanced wallet',
        name: 'linkAdvancedWalletHeader',
      );

  String get linkAdvancedWalletDescription => Intl.message(
        // ignore: lines_longer_than_80_chars
        'To link to an advanced wallet, you must be using an app that supports signatures',
        name: 'linkAdvancedWalletDescription',
      );

  String get linkAdvancedWalletInstructionCopyCode => Intl.message(
        'Copy this code',
        name: 'linkAdvancedWalletInstructionCopyCode',
      );

  String get linkAdvancedWalletInstructionSwitchApp => Intl.message(
        'Switch to the wallet app you want to link',
        name: 'linkAdvancedWalletInstructionSwitchApp',
      );

  String get linkAdvancedWalletInstructionSignMessage => Intl.message(
        'Sign a message with this code',
        name: 'linkAdvancedWalletInstructionSignMessage',
      );

  String get linkAdvancedWalletInstructionCopySignature => Intl.message(
        'Copy the signature',
        name: 'linkAdvancedWalletInstructionCopySignature',
      );

  String get linkAdvancedWalletInstructionPasteSignature => Intl.message(
        'Paste it in the field below',
        name: 'linkAdvancedWalletInstructionPasteSignature',
      );

  String get linkAdvancedWalletInstructionPublicAddress => Intl.message(
        'Enter your public address and tap ‘Link wallet’',
        name: 'linkAdvancedWalletInstructionPublicAddress',
      );

  String get linkAdvancedWalletButton => Intl.message(
        'Link wallet',
        name: 'linkAdvancedWalletButton',
      );

  String get linkAdvancedWalletTextFieldCodeSignatureTitle => Intl.message(
        'Linking code signature',
        name: 'linkAdvancedWalletTextFieldCodeSignatureTitle',
      );

  String get linkAdvancedWalletTextFieldCodeSignatureHint => Intl.message(
        'Paste signature here',
        name: 'linkAdvancedWalletTextFieldCodeSignatureHint',
      );

  String get emptyLinkAdvancedWalletTextFieldCodeSignatureError => Intl.message(
        'Linking code signature is required',
        name: 'emptyLinkAdvancedWalletTextFieldCodeSignatureError',
      );

  String get linkAdvancedWalletTextFieldPublicAddressTitle => Intl.message(
        'Public account address',
        name: 'linkAdvancedWalletTextFieldPublicAddressTitle',
      );

  String get linkAdvancedWalletTextFieldPublicAddressHint => Intl.message(
        'Enter public account address',
        name: 'linkAdvancedWalletTextFieldPublicAddressHint',
      );

  String get emptyLinkAdvancedWalletTextFieldPublicAddressError => Intl.message(
        'Public account address is required',
        name: 'emptyLinkAdvancedWalletTextFieldPublicAddressError',
      );

  String linkWalletReceiveTitle(String token) => Intl.message(
        'Receive $token points from external wallet',
        name: 'linkWalletReceiveTitle',
        args: [token],
      );

  String linkWalletReceiveHint(String token) => Intl.message(
        // ignore: lines_longer_than_80_chars
        'Transfer balance from your linked external wallet to your $token wallet',
        name: 'linkWalletReceiveHint',
        args: [token],
      );

  String get linkWalletReceiveCopyAddress => Intl.message(
        'Copy address',
        name: 'linkWalletReceiveCopyAddress',
      );

  String get linkWalletReceiveNote => Intl.message(
        'Note: Funds will be lost if you use a wallet other '
        'than your linked external wallet',
        name: 'linkWalletReceiveNote',
      );

  String get linkWalletTransferFailedTitle => Intl.message(
        'Transfer failed',
        name: 'linkWalletTransferFailedTitle',
      );

  String get linkWalletTransferFailedDetails => Intl.message(
        'We were unable to complete your transfer, please try again.',
        name: 'linkWalletTransferFailedDetails',
      );

  String get linkWalletTransferFailedSubDetails => Intl.message(
        'Your transaction failed due to public blockchain error.',
        name: 'linkWalletTransferFailedSubDetails',
      );

  String linkedWalletSendTitle(String token) => Intl.message(
        'Transfer $token points to external wallet',
        name: 'linkedWalletSendTitle',
        args: [token],
      );

  String linkedWalletSendHint(String token) => Intl.message(
        'Transfer from your $token wallet to your linked external wallet',
        name: 'linkedWalletSendHint',
        args: [token],
      );

  String get linkingWalletDisabled =>
      Intl.message('Currently disabled', name: 'linkingWalletDisabled');

//endregion Wallet linking

  //region Wallet Unlinking

  String get unlinkWalletInProgressHeader => Intl.message(
        'Unlinking in progress',
        name: 'unlinkWalletInProgressHeader',
      );

  String get unlinkWalletInProgressTitle => Intl.message(
        'Your wallet is currently being unlinked',
        name: 'unlinkWalletInProgressTitle',
      );

  //endregion Wallet Unlinking

  //region Social Page
  String get socialPageTitle => Intl.message(
        'Community',
        name: 'socialPageTitle',
      );

  String get socialPageComingSoon => Intl.message(
        'Coming Soon',
        name: 'socialPageComingSoon',
      );

//region Spend Page

  String get spendPageTitle => Intl.message(
        'Redeem',
        name: 'spendPageTitle',
      );

  String get spendRulePageEmpty =>
      Intl.message('Sorry, it appears there are no redeem offers right now',
          name: 'spendRulePageEmpty');

  String get doneButton => Intl.message('Done', name: 'doneButton');

  String get offerDetailGenericError => Intl.message(
      'We are unable to load offer details at the moment. Please try again.',
      name: 'offerDetailGenericError');

  String voucherStockCount(int stockCount) => Intl.plural(stockCount,
      zero: 'Out of stock',
      other: '$stockCount left',
      name: 'voucherStockCount',
      args: [stockCount],
      examples: const {'stockCount': 11});

  String voucherSoldCountInfo(int soldCount) =>
      Intl.message('$soldCount used this offer',
          name: 'voucherSoldCountInfo',
          args: [soldCount],
          examples: const {'soldCount': '2'});

  String get voucherDetailsAmount =>
      Intl.message('Amount', name: 'voucherDetailsAmount');

  String get voucherDetailsAvailableBalance => Intl.message(
        'Available balance',
        name: 'voucherDetailsAvailableBalance',
      );

  String get tokensLocked => Intl.message('are locked', name: 'tokensLocked');

  String get redeemVoucherButton =>
      Intl.message('Redeem voucher', name: 'redeemVoucherButton');

  String get redeemVoucherInsufficientFunds => Intl.message(
      'You can’t complete this action, you have insufficient funds',
      name: 'redeemVoucherInsufficientFunds');

  String get outOfStockDescription =>
      Intl.message('The vouchers in this offer are currently sold out.',
          name: 'outOfStockDescription');

//endregion Spend Page

//region Real Estate Payment

  String get realEstateListChooseAProperty =>
      Intl.message('Choose a property', name: 'realEstateListChooseAProperty');

  String get realEstateListNoPurchases =>
      Intl.message('You have no ongoing purchases at the moment',
          name: 'realEstateListNoPurchases');

  String get instalmentListChooseAnInstalment =>
      Intl.message('Choose an installment',
          name: 'instalmentListChooseAnInstalment');

  String get installmentOverdue =>
      Intl.message('Overdue', name: 'installmentOverdue');

//endregion Real Estate Payment

// region Property Payment Page
  String get propertyPaymentPageTitle => Intl.message(
        'Pay your installment',
        name: 'propertyPaymentPageTitle',
      );

  String get propertyPaymentPageSubDetails => Intl.message(
        'Your can pay your installment in full or partially',
        name: 'propertyPaymentPageSubDetails',
      );

  String get propertyPaymentFull => Intl.message(
        'Full',
        name: 'propertyPaymentFull',
      );

  String get propertyPaymentPartial => Intl.message(
        'Partial',
        name: 'propertyPaymentPartial',
      );

  String get propertyPaymentProperty => Intl.message(
        'Property',
        name: 'propertyPaymentProperty',
      );

  String get propertyPaymentAvailableBalanceLabel => Intl.message(
        'Available balance',
        name: 'propertyPaymentAvailableBalanceLabel',
      );

  String propertyPaymentConversionHolder(String amount, String currencyName) =>
      Intl.message(
        'Equals to: $amount $currencyName',
        args: [amount, currencyName],
        name: 'propertyPaymentConversionHolder',
      );

  String get propertyPaymentAmountExceedsInstalment => Intl.message(
        'Amount can\'t exceed the total of the installment',
        name: 'propertyPaymentAmountExceedsInstalment',
      );

  String currencyConversionLabel(String amountInToken, String token,
          String amountInCurrency, String currency) =>
      Intl.message(
        '$amountInToken $token = $amountInCurrency $currency',
        name: 'currencyConversionLabel',
        args: [amountInToken, token, amountInCurrency, currency],
      );

  String get paymentAmountRequiredError => Intl.message(
        'Amount is required',
        name: 'paymentAmountRequiredError',
      );

  String get paymentAmountInvalidError => Intl.message(
        'Amount is not valid',
        name: 'paymentAmountInvalidError',
      );

  String get emptyPaymentInvoiceError =>
      Intl.message('Invoice number is required',
          name: 'emptyPaymentInvoiceError');

  String get insufficientBalanceError => Intl.message(
      'We are unable to make transactions at this point as we '
      'could not load your balance',
      name: 'insufficientBalanceError');

  String get paymentSuccessDetails => Intl.message(
        'Great! Your transfer has been submitted. '
        'We\'ll notify you as soon as it\'s approved',
        name: 'paymentSuccessDetails',
      );

// endregion Property Payment Page

//region Redemption Success Page

  String get redemptionSuccessTitle =>
      Intl.message('Redemption successful', name: 'redemptionSuccessTitle');

  String get redemptionSuccessCopyTitle =>
      Intl.message('Your voucher code is', name: 'redemptionSuccessCopyTitle');

  String get redemptionSuccessDetailsText => Intl.message(
      'If you want to view this code later, you can find it under ',
      name: 'redemptionSuccessDetailsText');

  String get redemptionSuccessDetailsLink =>
      Intl.message('my account', name: 'redemptionSuccessDetailsLink');

  String get redemptionSuccessOpenVoucherAppButton =>
      Intl.message('Open Voucher App',
          name: 'redemptionSuccessOpenVoucherAppButton');

  String get redemptionSuccessToastMessage =>
      Intl.message('Voucher copied to clipboard',
          name: 'redemptionSuccessToastMessage');

//endregion Redemption Success Page

  //region Account Deactivated Page

  String get accountDeactivatedPageTitle => Intl.message(
        'It\'s sad to see you leave, but we hope to see you again soon',
        name: 'accountDeactivatedPageTitle',
      );

  String get accountDeactivatedPageMessagePart1 => Intl.message(
        'You\'ll be missed',
        name: 'accountDeactivatedPageMessagePart1',
      );

  String accountDeactivatedPageMessagePart2(String token) => Intl.message(
        'We don’t want to see you go, deactivating your '
        'account permanently locks you out of all your $token benefits.',
        name: 'accountDeactivatedPageMessagePart2',
        args: [token],
      );

  String accountDeactivatedPageMessagePart3(String contactNumber) =>
      Intl.message(
          'For further details, please contact our '
          'Customer Support Team on $contactNumber.',
          name: 'accountDeactivatedPageMessagePart3',
          args: [contactNumber],
          examples: const {'contactNumber': '+00 0000 000000'});

  String get accountDeactivatedPageMessageClosePart1 => Intl.message(
        'Kind regards,',
        name: 'accountDeactivatedPageMessageClosePart1',
      );

  String accountDeactivatedPageMessageClosePart2(String token) => Intl.message(
        'The $token Team',
        name: 'accountDeactivatedPageMessageClosePart2',
        args: [token],
      );

  String get accountDeactivatedPageContactButton => Intl.message(
        'Contact our support team',
        name: 'accountDeactivatedPageContactButton',
      );

  String get accountDeactivatedLaunchContactNumberError => Intl.message(
        'Your phone app failed to launch',
        name: 'accountDeactivatedLaunchContactNumberError',
      );

//endregion Account Deactivated Page

//region Warning Dialog

  String get warningDialogLeavingPageTitle => Intl.message(
        'Confirm',
        name: 'warningDialogLeavingPageTitle',
      );

  String get warningDialogLeavingPageDetails => Intl.message(
        'Are you sure you want to go back? '
        'We don’t want you to lose your progress',
        name: 'warningDialogLeavingPageDetails',
      );

  String get warningDialogYesButton => Intl.message(
        'Yes',
        name: 'warningDialogYesButton',
      );

  String get warningDialogNoButton => Intl.message(
        'No',
        name: 'warningDialogNoButton',
      );

  String get warningDialogNoThanksButton => Intl.message(
        'No, thanks',
        name: 'warningDialogNoThanksButton',
      );

  String get warningDialogGoToSettings => Intl.message(
        'Go to settings',
        name: 'warningDialogGoToSettings',
      );

//endregion Warning Dialog

//region Account Page
  String get accountPageLogOutConfirmTitle => Intl.message(
        'Please confirm',
        name: 'accountPageLogOutConfirmTitle',
      );

  String get accountPageLogOutConfirmContent => Intl.message(
        'Are you sure you want to log out?',
        name: 'accountPageLogOutConfirmContent',
      );

  String get accountPageTitle => Intl.message(
        'My account',
        name: 'accountPageTitle',
      );

  String get accountPagePersonalDetailsOption => Intl.message(
        'Personal details',
        name: 'accountPagePersonalDetailsOption',
      );

  String get referralTrackingPersonalDetailsOption => Intl.message(
        'Referral tracking',
        name: 'referralTrackingPersonalDetailsOption',
      );

  String get vouchersOption => Intl.message(
        'Vouchers',
        name: 'vouchersOption',
      );

  String get accountPageChangePasswordOption => Intl.message(
        'Change password',
        name: 'accountPageChangePasswordOption',
      );

  String get accountPageLogoutOption => Intl.message(
        'Log out',
        name: 'accountPageLogoutOption',
      );

  String accountAppVersion(String appVersion) =>
      Intl.message('App version: $appVersion',
          name: 'accountAppVersion',
          args: [appVersion],
          examples: const {'appVersion': '0.0.7'});

  String get accountPageBiometricsSignInOptionAndroid => Intl.message(
        'Sign-in with your fingerprint',
        name: 'accountPageBiometricsSignInOptionAndroid',
      );

  String get accountPageBiometricsSignInOptionIOS => Intl.message(
        'Sign-in with Touch ID/Face ID',
        name: 'accountPageBiometricsSignInOptionIOS',
      );

  String get contactUsPageDetail =>
      Intl.message('Feel free to get in touch with us for any help and support',
          name: 'contactUsPageDetail');

  String get contactUsPhoneNumber =>
      Intl.message('Phone Number', name: 'contactUsPhoneNumber');

  String get contactUsEmail => Intl.message('Email', name: 'contactUsEmail');

  String get contactUsWhatsApp =>
      Intl.message('Whatsapp', name: 'contactUsWhatsApp');

  String get contactUsWhatsAppStartingMessage =>
      Intl.message('Hello', name: 'contactUsWhatsAppStartingMessage');

  String get contactUsLaunchContactNumberError => Intl.message(
        'There was a problem launching your phone app.',
        name: 'contactUsLaunchContactNumberError',
      );

  String get contactUsLaunchContactEmailError => Intl.message(
        'There was a problem launching your email app.',
        name: 'contactUsLaunchContactEmailError',
      );

  String get contactUsGenericErrorSubtitle => Intl.message(
      'Sorry, we are unable to show contact information '
      'please try again.',
      name: 'contactUsGenericErrorSubtitle');

//endregion Account Page

//region Delete Account Dialog

  String get deleteAccountDialogTitle => Intl.message(
        'Delete account',
        name: 'deleteAccountDialogTitle',
      );

  String get deleteAccountDialogDetails => Intl.message(
        'Are you sure you want to delete your account?',
        name: 'deleteAccountDialogDetails',
      );

  String get deleteAccountDialogDeleteButton => Intl.message(
        'Delete',
        name: 'deleteAccountDialogDeleteButton',
      );

  String get deleteAccountDialogCancelButton => Intl.message(
        'Cancel',
        name: 'deleteAccountDialogCancelButton',
      );

//endregion Delete Account Dialog

//region Change password

  String get changePasswordPagePrompt => Intl.message(
        'Please create a new password ',
        name: 'changePasswordPagePrompt',
      );

  String get changePasswordPagePasswordLabel =>
      Intl.message('New password*', name: 'changePasswordPagePasswordLabel');

  String get changePasswordPageConfirmPasswordHint =>
      Intl.message('Please confirm new password',
          name: 'changePasswordPageConfirmPasswordHint');

  String get changePasswordPagePasswordHint =>
      Intl.message('Please enter new password',
          name: 'changePasswordPagePasswordHint');

//endregion Change password
//region Change password success
  String get changePasswordSuccessTitle =>
      Intl.message('Password updated', name: 'changePasswordSuccessTitle');

  String get changePasswordSuccessDetails =>
      Intl.message('Great! Your password has been changed.',
          name: 'changePasswordSuccessDetails');

  String get changePasswordSuccessBackToAccountButton =>
      Intl.message('Back to account',
          name: 'changePasswordSuccessBackToAccountButton');

//endregion Change password success

//region Common Password elements

  String get confirmPasswordLabel =>
      Intl.message('Confirm password*', name: 'confirmPasswordLabel');

  String get passwordGuide => Intl.message(
      'We care about your security, '
      'please make sure your password has at least:',
      name: 'passwordGuide');

  String get changePassword => Intl.message(
        'Change password',
        name: 'changePassword',
      );

//endregion Common Password elements

  //region Reset Password elements

  String get resetPasswordTitle =>
      Intl.message('Enter email address', name: 'resetPasswordTitle');

  String get resetPasswordSendLinkHint =>
      Intl.message('We’ll send you a link to reset your password',
          name: 'resetPasswordSendLinkHint');

  String get resetPasswordSentEmailHint => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Link has been sent, please check your email, if you didn’t receive it try to request it again or check your spam folder',
      name: 'resetPasswordSentEmailHint');

  String get resetPassword => Intl.message(
        'Reset password',
        name: 'resetPassword',
      );

  String get resetPasswordPrompt => Intl.message(
        'Please create a new password and sign in again',
        name: 'resetPasswordPrompt',
      );

  String get setPasswordSuccessTitle =>
      Intl.message('Password reset successfully',
          name: 'setPasswordSuccessTitle');

  String get setPasswordSuccessDetails => Intl.message(
      'Your password has been reset please login with your new details',
      name: 'setPasswordSuccessDetails');

  String get setPasswordSuccessBackToAccountButton =>
      Intl.message('Back to sign-in',
          name: 'setPasswordSuccessBackToAccountButton');

//endregion Reset Password elements

//region Pin elements
  String get pinCreatedSuccessTitle =>
      Intl.message('PIN created', name: 'pinCreatedSuccessTitle');

  String get pinCreatedSuccessDetails =>
      Intl.message('Great! your PIN has been created successfully',
          name: 'pinCreatedSuccessDetails');

  String get pinErrorDoesNotMatch =>
      Intl.message('PIN does not match', name: 'pinErrorDoesNotMatch');

  String pinErrorRemainingAttempts(int count) => Intl.message(
        // ignore: lines_longer_than_80_chars
        'You have $count attempts remaining after which you will need to sign-in with your email and password',
        name: 'pinErrorRemainingAttempts',
        args: [count],
      );

  String get pinErrorIncorrectPassCode =>
      Intl.message('Incorrect passcode, please retry',
          name: 'pinErrorIncorrectPassCode');

  String get pinShow => Intl.message('Show PIN', name: 'pinShow');

  String get pinHide => Intl.message('Hide PIN', name: 'pinHide');

  String get pinConfirmHeading =>
      Intl.message('Confirm PIN', name: 'pinConfirmHeading');

  String get pinConfirmDescription =>
      Intl.message('Please confirm your PIN', name: 'pinConfirmDescription');

  String get pinCreateHeading =>
      Intl.message('Create a PIN', name: 'pinCreateHeading');

  String pinCreateDescription(String appName) => Intl.message(
        'Create a PIN to quickly sign in to your $appName account next time',
        name: 'pinCreateDescription',
        args: [appName],
      );

  String get pinSignInHeading =>
      Intl.message('Enter your PIN', name: 'pinSignInHeading');

  String get pinSignInDescription =>
      Intl.message('Please enter your PIN to sign-in',
          name: 'pinSignInDescription');

  String get pinVerificationDescription =>
      Intl.message('Please re-enter your PIN',
          name: 'pinVerificationDescription');

  String get pinForgotButton =>
      Intl.message('Forgot?', name: 'pinForgotButton');

  String get useFaceIDButton =>
      Intl.message('or use Face ID', name: 'useFaceIDButton');

  String get useBiometricButton =>
      Intl.message('or use biometric', name: 'useBiometricButton');

  String get useFingerprintButton =>
      Intl.message('or use fingerprint', name: 'useFingerprintButton');

  String get pinForgotPageTitle =>
      Intl.message('Forgot your PIN?', name: 'pinForgotPageTitle');

  String get pinForgotPageDescription => Intl.message(
      'Please sign in with your email and password after which you can set a '
      'new PIN.',
      name: 'pinForgotPageDescription');

  String get pinForgotPageButton =>
      Intl.message('Proceed', name: 'pinForgotPageButton');

  //endregion Pin elements

//region P2P Transaction Page

  String receiveTokenPageTitle(String token) => Intl.message(
        'Receive $token points',
        name: 'receiveTokenPageTitle',
        args: [token],
      );

  String get receiveTokenPageSubDetails => Intl.message(
        'Share this code with the sender, you\'ll '
        'receive points quicker than you thought',
        name: 'receiveTokenPageSubDetails',
      );

  String get receiveTokenPageGenericErrorTitle =>
      Intl.message('This doesn’t seem right',
          name: 'receiveTokenPageGenericErrorTitle');

  String get receiveTokenPageGenericErrorSubtitle => Intl.message(
      'Oh no! We\'re unable to display the QR code. Please try again.',
      name: 'receiveTokenPageGenericErrorSubtitle');

//endregion P2P Transaction Page

//region Earn Page

  String get referAHotelSectionTitle => Intl.message(
        'Refer a hotel',
        name: 'referAHotelSectionTitle',
      );

  String get inviteFriendSectionTitle => Intl.message(
        'Invite a friend',
        name: 'inviteFriendSectionTitle',
      );

  String get inviteFriendEarnUpToPart1 => Intl.message(
        'Earn up to ',
        name: 'inviteFriendEarnUpToPart1',
      );

  String get inviteFriendEarnUpToPart2 => Intl.message(
        ' for every friend you invite to the app',
        name: 'inviteFriendEarnUpToPart2',
      );

  String get earnRulePageInitialPageError =>
      Intl.message('Sorry, we are unable to load earn offers right now',
          name: 'earnRulePageInitialPageError');

  String get earnRulePagePaginationError =>
      Intl.message('Sorry, we are unable to show more earn offers right now',
          name: 'earnRulePagePaginationError');

  String get earnRulePageEmpty =>
      Intl.message('Sorry, it appears there are no earn offers right now',
          name: 'earnRulePageEmpty');

//endregion Earn Page

//region Earn Detail Page

  String get earnDetailPageGenericErrorSubTitle => Intl.message(
      'Sorry, we are unable to show task details '
      'please try again.',
      name: 'earnDetailPageGenericErrorSubTitle');

  String earnRuleValidDate(String fromDate, String toDate) => Intl.message(
        'Valid : from $fromDate to $toDate',
        name: 'earnRuleValidDate',
        args: [fromDate, toDate],
      );

  String get earnRuleUnlimitedParticipationInfo =>
      Intl.message('You can participate in this offer unlimited times',
          name: 'earnRuleUnlimitedParticipationInfo');

  String get earnRuleOnlyOnceParticipationInfo =>
      Intl.message('You can participate in this only once',
          name: 'earnRuleOnlyOnceParticipationInfo');

  String earnRuleLimitedParticipationInfo(int number) => Intl.message(
        'You can participate in this offer $number times',
        name: 'earnRuleLimitedParticipationInfo',
        args: [number],
      );

  String earnRuleLimitedCompletionInfo(int number, int total) => Intl.message(
        '$number / $total completed',
        name: 'earnRuleLimitedCompletionInfo',
        args: [number, total],
      );

  String earnRuleUnlimitedCompletionInfo(int number) => Intl.message(
        '$number completed',
        name: 'earnRuleUnlimitedCompletionInfo',
        args: [number],
      );

  String get earnRuleRewardBoxTitle =>
      Intl.message('Offer Award', name: 'earnRuleRewardBoxTitle');

  String earnRuleRewardBoxSubTitle(String token) => Intl.message(
        'Earn $token points every time you complete the offer',
        name: 'earnRuleRewardBoxSubTitle',
        args: [token],
      );

  String get earnRuleCampaignMissionTitle =>
      Intl.message('Task mission', name: 'earnRuleCampaignMissionTitle');

  String get earnRuleCampaignMissionSubtitle =>
      Intl.message('Finish the tasks below and earn the offer award!',
          name: 'earnRuleCampaignMissionSubtitle');

  String get earnRuleConditionCompleted =>
      Intl.message('Completed', name: 'earnRuleConditionCompleted');

  String get earnRuleConditionGetStarted =>
      Intl.message('Get started', name: 'earnRuleConditionGetStarted');

  String earnRuleCompletionMessage(String token) => Intl.message(
        // ignore: lines_longer_than_80_chars
        'Congratulations! You have completed this task! Have a look at other offers to continue earning ${token}s',
        name: 'earnRuleCompletionMessage',
        args: [token],
      );

  String get earnRuleViewOtherOffers =>
      Intl.message('View other offers', name: 'earnRuleViewOtherOffers');

  String get earnRuleDetailsHowItWorks => Intl.message(
        'How it works',
        name: 'earnRuleDetailsHowItWorks',
      );

  String get earnRuleDetailsEarnUponCompletion => Intl.message(
        'Each time you complete this task, you could earn ',
        name: 'earnRuleDetailsEarnUponCompletion',
      );

  String get earnRuleDetailsEarnUponCompletionConversionRate => Intl.message(
        ' (* indicative amount based on average night stay).',
        name: 'earnRuleDetailsEarnUponCompletionConversionRate',
      );

  String get earnRuleDetailsStakingAmountPart1 => Intl.message(
        'This offer requires you to lock ',
        name: 'earnRuleDetailsStakingAmountPart1',
      );

  String get earnRuleDetailsStakingAmountPart2 => Intl.message(
        ' to participate',
        name: 'earnRuleDetailsStakingAmountPart2',
      );

  String get earnRuleDetailsParticipationLimit => Intl.message(
        'You can participate ',
        name: 'earnRuleDetailsParticipationLimit',
      );

  String earnRuleDetailsParticipationCount(int participationCount) =>
      Intl.plural(
        participationCount,
        one: 'one time',
        other: '$participationCount times',
        args: [participationCount],
        name: 'earnRuleDetailsParticipationCount',
      );

  String get earnRuleDetailsUnlimitedParticipation => Intl.message(
        'You can participate unlimited times.',
        name: 'earnRuleDetailsUnlimitedParticipation',
      );

  String get earnRuleDetailsPreviousParticipationPart1 => Intl.message(
        'You have successfully participated ',
        name: 'earnRuleDetailsPreviousParticipationPart1',
      );

  String get earnRuleDetailsPreviousParticipationPart2 => Intl.message(
        ' and earned ',
        name: 'earnRuleDetailsPreviousParticipationPart2',
      );

  String get earnRuleDetailsPreviousParticipationPart3 => Intl.message(
        ' so far',
        name: 'earnRuleDetailsPreviousParticipationPart3',
      );

  String get earnRuleDetailsReadMoreButton => Intl.message(
        'Read more',
        name: 'earnRuleDetailsReadMoreButton',
      );

  String get earnRuleDetailsOfferUnavailableTitle =>
      Intl.message('Task unavailable',
          name: 'earnRuleDetailsOfferUnavailableTitle');

  String get earnRuleDetailsViewOffersButton =>
      Intl.message('View other offers',
          name: 'earnRuleDetailsViewOffersButton');

  String get earnRuleDetailsLowBalanceErrorPart1 =>
      Intl.message('You need ', name: 'earnRuleDetailsLowBalanceErrorPart1');

  String get earnRuleDetailsLowBalanceErrorPart2 =>
      Intl.message(' in order to be eligible to participate in this offer.',
          name: 'earnRuleDetailsLowBalanceErrorPart2');

  String get earnRuleDetailsParticipationLimitError => Intl.message(
      'You’ve reached the limit of times to participate in this offer.',
      name: 'earnRuleDetailsParticipationLimitError');

  //region How it works page

  String get earnRuleIndicativeAmountInfoHospitality => Intl.message(
        '* This is an indicative amount based on average night stay.',
        name: 'earnRuleIndicativeAmountInfoHospitality',
      );

  String get earnRuleIndicativeAmountInfoRealEstate => Intl.message(
        '* It will depend on the property price.',
        name: 'earnRuleIndicativeAmountInfoRealEstate',
      );

  String get earnRuleIndicativeAmountInfoGeneric => Intl.message(
        '* This is an indicative amount.',
        name: 'earnRuleIndicativeAmountInfoGeneric',
      );

  String get stakingDetailsPart1 => Intl.message(
        // ignore: lines_longer_than_80_chars
        'In order to be eligible to participate in this offer you need to lock ',
        name: 'stakingDetailsPart1',
      );

  String get stakingDetailsRealEstatePart5 => Intl.message(
        // ignore: lines_longer_than_80_chars
        'You’ll be awarded upon completion of the different milestones during the purchase process.',
        name: 'stakingDetailsRealEstatePart5',
      );

  String get stakingDetailsRealEstateStakingRulePart1 => Intl.message(
        'If your friend makes a purchase we will return ',
        name: 'stakingDetailsRealEstateStakingRulePart1',
      );

  String get stakingDetailsRealEstateStakingRulePart2_100percent =>
      Intl.message(
        ' of the staking amount.',
        name: 'stakingDetailsRealEstateStakingRulePart2_100percent',
      );

  String stakingDetailsRealEstateBurningRulePart1(String time) => Intl.message(
        'If your friend doesn\'t accept the invite within $time you will lose ',
        args: [time],
        name: 'stakingDetailsRealEstateBurningRulePart1',
      );

  String get stakingDetailsRealEstateBurningRulePart2 => Intl.message(
        ' of the staking amount.',
        name: 'stakingDetailsRealEstateBurningRulePart2',
      );

  String get stakingDetailsLockedAmount => Intl.message(
        'Locked amount',
        name: 'stakingDetailsLockedAmount',
      );

  String get stakingDetailsReward => Intl.message(
        'Award',
        name: 'stakingDetailsReward',
      );

  //endregion How it works page

//endregion Earn Detail Page

//region Common texts

  String get copiedToClipboard => Intl.message(
        'Copied to Clipboard',
        name: 'copiedToClipboard',
      );

  String amountTokens(int amount, String token) =>
      Intl.message(' $amount $token points ',
          name: 'amountTokens',
          args: [amount, token],
          desc: 'Amount of tokens',
          examples: const {'amount': 100, 'token': 'ABC'});

//endregion Common texts

//region Bottom bar texts

  String get bottomBarExplore => Intl.message(
        'Explore',
        name: 'bottomBarExplore',
      );

  String get bottomBarOffers => Intl.message(
        'Offers',
        name: 'bottomBarOffers',
      );

  String get bottomBarWallet => Intl.message(
        'Wallet',
        name: 'bottomBarWallet',
      );

  String get bottomBarSocial => Intl.message(
        'Community',
        name: 'bottomBarSocial',
      );

//endregion Bottom bar texts

//region Maintenance
  String get maintenanceTitle => Intl.message(
        'Ongoing maintenance',
        name: 'maintenanceTitle',
      );

  String maintenanceDescription(String period) => Intl.message(
        'We are undergoing some routine maintenance '
        'and will be up and running in the next $period',
        args: [period],
        name: 'maintenanceDescription',
      );

  String get maintenanceErrorMessage => Intl.message(
        'The system is under maintenance. Please try again later.',
        name: 'maintenanceErrorMessage',
      );

  String get maintenanceErrorCoupleOfHours => Intl.message(
        'couple of hours',
        name: 'maintenanceErrorCoupleOfHours',
      );

  String hours(int hours) => Intl.plural(
        hours,
        one: '$hours hour',
        other: '$hours hours',
        args: [hours],
        name: 'hours',
      );

//endregion Maintenance

//region Payment Request Page

  String get transferRequestTitle => Intl.message(
        'Transfer request',
        name: 'transferRequestTitle',
      );

  String transferRequestIdHolder(String id) => Intl.message('ID : $id',
      name: 'transferRequestIdHolder',
      args: [id],
      desc: 'ID of the transfer request',
      examples: const {'id': '123456ABC'});

  String transferRequestInfoHolder(String transferRequestOrganization) =>
      Intl.message(
          'You received a transfer request from $transferRequestOrganization. '
          'Please review and confirm it.',
          name: 'transferRequestInfoHolder',
          args: [transferRequestOrganization],
          desc: 'The entity that sends the transfer request',
          examples: const {'transferRequestOrganization': 'Rove Hotel'});

  String get transferRequestTotalBillLabel => Intl.message(
        'Total Bill',
        name: 'transferRequestTotalBillLabel',
      );

  String transferRequestTotalBillHolder(
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

  String get transferRequestWalletBalanceLabel => Intl.message(
        'Your wallet balance',
        name: 'transferRequestWalletBalanceLabel',
      );

  String amountTokensHolder(String amount, String token) =>
      Intl.message('$amount $token points ',
          name: 'amountTokensHolder',
          args: [amount, token],
          desc: 'Amount of tokens',
          examples: const {'amount': '100.45', 'token': 'ABC'});

  String get transferRequestRecipientLabel => Intl.message(
        'Recipient',
        name: 'transferRequestRecipientLabel',
      );

  String get transferRequestRemainingTimeLabel => Intl.message(
        'Time remaining',
        name: 'transferRequestRemainingTimeLabel',
      );

  String expirationFormatDays(int days) => Intl.plural(days,
      one: '$days day',
      other: '$days days',
      name: 'expirationFormatDays',
      args: [days]);

  String transferRequestSendingAmountLabel(String token) => Intl.message(
        'Sending Amount ($token)',
        name: 'transferRequestSendingAmountLabel',
        args: [token],
      );

  String transferRequestAmountExceedsRequestedError(String requestedAmount) =>
      Intl.message(
        'You cannot pay more than $requestedAmount',
        args: [requestedAmount],
        name: 'transferRequestAmountExceedsRequestedError',
      );

  String get transferRequestGenericError => Intl.message(
        'We were unable to complete the transfer, please try again',
        name: 'transferRequestGenericError',
      );

  String get transferRequestAmountIsZeroError =>
      Intl.message('Amount must be bigger than zero',
          name: 'transferRequestAmountIsZeroError');

  String get transferRequestNotEnoughTokensError => Intl.message(
      'Sorry, you do not have enough points to complete this transaction.',
      name: 'transferRequestNotEnoughTokensError');

  String get transferRequestInvalidStateError => Intl.message(
      'Something\'s wrong… '
      'The request seems to be already completed or canceled.',
      name: 'transferRequestInvalidStateError');

  String get transferRequestRejectButton => Intl.message(
        'Reject',
        name: 'transferRequestRejectButton',
      );

  String get transferRequestRejectDialogText => Intl.message(
        'Are you sure you want to reject this transfer?',
        name: 'transferRequestRejectDialogText',
      );

  String get transferRequestSuccessTitle => Intl.message(
        'Transfer submitted',
        name: 'transferRequestSuccessTitle',
      );

  String get transferRequestSuccessDetails => Intl.message(
        'Great! Your transfer has been submitted',
        name: 'transferRequestSuccessDetails',
      );

//endregion Payment Request Page

//region Transfer Request Expired Page

  String get transferRequestExpiredTitle => Intl.message(
        'Request expired',
        name: 'transferRequestExpiredTitle',
      );

  String get transferRequestExpiredDetails => Intl.message(
        'This transfer request has expired, '
        'please ask the reception desk to send a new request ',
        name: 'transferRequestExpiredDetails',
      );

//endregion Transfer Request Expired Page

//region Payment Request List Page
  String get transferRequestListPageTitle => Intl.message(
        'Transfer requests',
        name: 'transferRequestListPageTitle',
      );

  String get transferRequestListGenericError => Intl.message(
        'Sorry, we are unable to show more transfer requests right now',
        name: 'transferRequestListGenericError',
      );

//endregion Payment Request List Page

//region PaymentRequestStatusCard

  String get transferRequestStatusCardRecipientLabel => Intl.message(
        'Recipient',
        name: 'transferRequestStatusCardRecipientLabel',
      );

  String get transferRequestStatusCardSendingAmountLabel => Intl.message(
        'Sending Amount',
        name: 'transferRequestStatusCardSendingAmountLabel',
      );

  String get transferRequestStatusCardTotalBillLabel => Intl.message(
        'Total Bill',
        name: 'transferRequestStatusCardTotalBillLabel',
      );

  String transferRequestStatusCardRecipientIdLabel(String recipientId) =>
      Intl.message(
        'ID: $recipientId',
        name: 'transferRequestStatusCardRecipientIdLabel',
        args: [recipientId],
        examples: const {'recipientId': '12345678'},
      );

  String get transferRequestStatusCardStatusCancelled => Intl.message(
        'Canceled',
        name: 'transferRequestStatusCardStatusCancelled',
      );

  String get transferRequestStatusCardStatusCompleted => Intl.message(
        'Completed',
        name: 'transferRequestStatusCardStatusCompleted',
      );

  String get transferRequestStatusCardStatusExpired => Intl.message(
        'Expired',
        name: 'transferRequestStatusCardStatusExpired',
      );

  String get transferRequestStatusCardStatusFailed => Intl.message(
        'Failed',
        name: 'transferRequestStatusCardStatusFailed',
      );

  String get transferRequestStatusCardStatusPending => Intl.message(
        'Pending',
        name: 'transferRequestStatusCardStatusPending',
      );

  String get transferRequestStatusCardStatusConfirmed => Intl.message(
        'Confirmed',
        name: 'transferRequestStatusCardStatusConfirmed',
      );

  String get transferRequestOngoingTab => Intl.message(
        'Ongoing',
        name: 'transferRequestOngoingTab',
      );

  String get transferRequestCompletedTab => Intl.message(
        'Completed',
        name: 'transferRequestCompletedTab',
      );

  String get transferRequestUnsuccessfulTab => Intl.message(
        'Unsuccessful',
        name: 'transferRequestUnsuccessfulTab',
      );

  String get transferRequestEmptyOngoing => Intl.message(
        'You have no ongoing requests at the moment',
        name: 'transferRequestEmptyOngoing',
      );

  String get transferRequestEmptyCompleted => Intl.message(
        'You have no completed requests at the moment',
        name: 'transferRequestEmptyCompleted',
      );

  String get transferRequestEmptyUnsuccessful => Intl.message(
        'You have no unsuccessful requests at the moment',
        name: 'transferRequestEmptyUnsuccessful',
      );

//endregion PaymentRequestStatusCard

//region Hotel Pre Checkout Dialog

  String get hotelPreCheckoutDialogHeading => Intl.message(
        'Thanks for staying with us',
        name: 'hotelPreCheckoutDialogHeading',
      );

  String get hotelPreCheckoutDialogViewInvoiceButton => Intl.message(
        'View Invoice',
        name: 'hotelPreCheckoutDialogViewInvoiceButton',
      );

//endregion Hotel Pre Checkout Dialog

//region Biometric Authentication
  String get biometricAuthenticationDialogTitleAndroid => Intl.message(
        'Do you want to enable fingerprint security?',
        name: 'biometricAuthenticationDialogTitleAndroid',
      );

  String get biometricAuthenticationDialogMessageAndroid => Intl.message(
        'Next time, sign-in using your fingerprint. '
        'It\'s fast, easy and secure.',
        name: 'biometricAuthenticationDialogMessageAndroid',
      );

  String get biometricAuthenticationDialogTitleIOS => Intl.message(
        'Do you want to enable Touch ID/Face ID?',
        name: 'biometricAuthenticationDialogTitleIOS',
      );

  String get biometricAuthenticationDialogMessageIOS => Intl.message(
        'Next time, sign-in using Touch ID/Face ID. It\'s fast, easy and secure.',
        name: 'biometricAuthenticationDialogMessageIOS',
      );

  String get biometricAuthenticationPromptTitle => Intl.message(
        'Hello',
        name: 'biometricAuthenticationPromptTitle',
      );

  String get biometricAuthenticationPromptMessage => Intl.message(
        'Sign-in with your fingerprint',
        name: 'biometricAuthenticationPromptMessage',
      );

  String get biometricsGoToSettingsDescription => Intl.message(
      // ignore: lines_longer_than_80_chars
      'Biometric authentication is not set up on your device. Please enable either Touch ID or Face ID on your phone.',
      name: 'biometricsGoToSettingsDescription');

//endregion Biometric Authentication

//region Scanned Info Dialog

  String get scannedInfoDialogTitle =>
      Intl.message('Scanned Info', name: 'scannedInfoDialogTitle');

  String get scannedInfoDialogErrorMessage =>
      Intl.message('This QR code type is currently unsupported',
          name: 'scannedInfoDialogErrorMessage');

  String get scannedInfoDialogPositiveButton =>
      Intl.message('Open in browser', name: 'scannedInfoDialogPositiveButton');

  String get scannedInfoDialogNegativeButton =>
      Intl.message('Cancel', name: 'scannedInfoDialogNegativeButton');

  String scannedInfoDialogEmailPositiveButton(String token) => Intl.message(
        'Transfer $token',
        args: [token],
        name: 'scannedInfoDialogEmailPositiveButton',
      );

//endregion Scanned Info Dialog

//region conversion Rate

  String conversionRate(
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

  String noTokensConversionRateText(String token) => Intl.message(
        'Start earning $token now!',
        name: 'noTokensConversionRateText',
        args: [token],
      );

//endregion Wallet Conversion Rate

// region Personal Detail Page

  String get personalDetailsFirstNameTitle => Intl.message(
        'First Name',
        name: 'personalDetailsFirstNameTitle',
      );

  String get personalDetailsLastNameTitle => Intl.message(
        'Last Name',
        name: 'personalDetailsLastNameTitle',
      );

  String get personalDetailsEmailTitle => Intl.message(
        'Email Address',
        name: 'personalDetailsEmailTitle',
      );

  String get personalDetailsPhoneNumberTitle => Intl.message(
        'Phone Number',
        name: 'personalDetailsPhoneNumberTitle',
      );

  String get personalDetailsCountryOfNationality =>
      Intl.message('Country of nationality',
          name: 'personalDetailsCountryOfNationality');

  String get personalDetailsDeleteAccountButton =>
      Intl.message('Delete your account',
          name: 'personalDetailsDeleteAccountButton');

  String get personalDetailsGenericError => Intl.message(
      'We are unable to get your personal details right now. Please try again.',
      name: 'personalDetailsGenericError');

// endregion Personal Detail Page

//region Email Verification
  String get emailVerificationTitle =>
      Intl.message('Confirm email address', name: 'emailVerificationTitle');

  String get emailVerificationMessage1 =>
      Intl.message('We’ve sent a confirmation to: ',
          name: 'emailVerificationMessage1');

  String get emailVerificationMessage1Resent =>
      Intl.message('We’ve resent a confirmation to: ',
          name: 'emailVerificationMessage1Resent');

  String get emailVerificationMessage2 => Intl.message(
      'Check your email and click on the confirmation link to continue',
      name: 'emailVerificationMessage2');

  String get emailVerificationResetText =>
      Intl.message('Didn’t receive an email? resend the link',
          name: 'emailVerificationResetText');

  String get registerWithAnotherAccountButton =>
      Intl.message('Register with another account',
          name: 'registerWithAnotherAccountButton');

  String get emailVerificationButton =>
      Intl.message('Resend link', name: 'emailVerificationButton');

  String get emailVerificationExceededMaxAttemptsError =>
      Intl.message('Too many attempts, please try again later',
          name: 'emailVerificationExceededMaxAttemptsError');

  String emailVerificationLinkExpired(String email) => Intl.message(
        'This link has expired, we’ve sent a new one to $email, '
        'please check your email and use the new link',
        name: 'emailVerificationLinkExpired',
        args: [email],
        examples: const {'email': 'samplemail@gmail.com'},
      );

//endregion Email Verification

//region Email Verification Success Page
  String get emailVerificationSuccessTitle =>
      Intl.message('Email confirmed', name: 'emailVerificationSuccessTitle');

  String get emailVerificationSuccessDetails =>
      Intl.message('Thanks! your email address has been confirmed',
          name: 'emailVerificationSuccessDetails');

//endregion Email Verification Success Page

//region Previous Referrals

  String get previousReferralsCardTypeRealEstate =>
      Intl.message('Real estate', name: 'previousReferralsCardTypeRealEstate');

  String get previousReferralsCardTypeHospitality =>
      Intl.message('Hospitality', name: 'previousReferralsCardTypeHospitality');

  String get previousReferralsCardTypeAppReferral =>
      Intl.message('App referral',
          name: 'previousReferralsCardTypeAppReferral');

  String get previousReferralsCardAward =>
      Intl.message('award', name: 'previousReferralsCardAward');

  String get previousReferralsCardTimeLeftToAccept =>
      Intl.message('Time left to accept',
          name: 'previousReferralsCardTimeLeftToAccept');

  String get previousReferralsCardRemaining =>
      Intl.message('Remaining to earn', name: 'previousReferralsCardRemaining');

  String get previousReferralsCardDontLose =>
      Intl.message('Don\'t lose your', name: 'previousReferralsCardDontLose');

  String previousReferralsCardContact(String person) =>
      Intl.message('Contact $person',
          args: [person], name: 'previousReferralsCardContact');

  String previousReferralsNameHolder(String firstName, String lastName) =>
      Intl.message('$firstName $lastName',
          args: [firstName, lastName], name: 'previousReferralsNameHolder');

//endregion Previous Referrals

//region Common Date

  String get dateTimeToday => Intl.message('Today', name: 'dateTimeToday');

  String get dateTimeYesterday =>
      Intl.message('Yesterday', name: 'dateTimeYesterday');

//endregion Common Date

//region Partners

  String multiplePartnersTitle(String firstPartnerName, int numberOfPartner) =>
      Intl.plural(numberOfPartner,
          one: '$firstPartnerName & $numberOfPartner other',
          other: '$firstPartnerName & $numberOfPartner others',
          name: 'multiplePartnersTitle',
          args: [firstPartnerName, numberOfPartner]);

  String get viewPartnerDetailsButtonTitle =>
      Intl.message('View partner details',
          name: 'viewPartnerDetailsButtonTitle');

  String get partnerDetailsPageTitle =>
      Intl.message('Partner Details', name: 'partnerDetailsPageTitle');

//endregion Partners

//region App Upgrade

  String get nonMandatoryAppUpgradeDialogTitle =>
      Intl.message('New version available',
          name: 'nonMandatoryAppUpgradeDialogTitle');

  String get nonMandatoryAppUpgradeDialogContent => Intl.message(
      'There is a new version of the app available to download. '
      'Please update so you can see the latest changes.',
      name: 'nonMandatoryAppUpgradeDialogContent');

  String get nonMandatoryAppUpgradeDialogPositiveButton =>
      Intl.message('Update',
          name: 'nonMandatoryAppUpgradeDialogPositiveButton');

  String get nonMandatoryAppUpgradeDialogNegativeButton =>
      Intl.message('No, thanks',
          name: 'nonMandatoryAppUpgradeDialogNegativeButton');

  String get mandatoryAppUpgradePageTitle =>
      Intl.message('Update required', name: 'mandatoryAppUpgradePageTitle');

  String get mandatoryAppUpgradePageContent => Intl.message(
      // ignore: lines_longer_than_80_chars
      'A new version of the app available to download. Please update in order to continue.',
      name: 'mandatoryAppUpgradePageContent');

  String get mandatoryAppUpgradePageButton =>
      Intl.message('Update', name: 'mandatoryAppUpgradePageButton');

//endregion App Upgrade

//region Privacy policy and Terms of Use

  String get termsOfUse => Intl.message(
        'Terms of Use',
        name: 'termsOfUse',
      );

  String get privacyPolicy =>
      Intl.message('Privacy policy', name: 'privacyPolicy');

  String get and => Intl.message(' and ', name: 'and');

//endregion Privacy policy

//region Common texts

  String get transferInProgress => Intl.message(
        'Transfer in progress',
        name: 'transferInProgress',
      );

  String get goToWallet => Intl.message(
        'Go to Wallet',
        name: 'goToWallet',
      );

  String transferInProgressDetails(String token) => Intl.message(
        'Your ${token}s'
        ' have been transferred. '
        'We’ll notify you when the operation is completed.',
        name: 'transferInProgressDetails',
        args: [token],
      );

//endregion Common texts

//region Service errors

  String get customerBlockedError => Intl.message(
        'This account is currently blocked',
        name: 'customerBlockedError',
      );

  String get customerDoesNotExistError => Intl.message(
        'Sorry, the customer could not be found',
        name: 'customerDoesNotExistError',
      );

  String get customerPhoneIsMissingError => Intl.message(
        'Error. User\'s phone number could not be retrieved',
        name: 'customerPhoneIsMissingError',
      );

  String get customerProfileDoesNotExistError => Intl.message(
        'Error. User could not be found',
        name: 'customerProfileDoesNotExistError',
      );

  String get customerWalletBlockedError => Intl.message(
        'Sorry, your wallet is currently blocked '
        'and cannot process transactions',
        name: 'customerWalletBlockedError',
      );

  String get emailIsAlreadyVerifiedError => Intl.message(
        'An account with this email already exists',
        name: 'emailIsAlreadyVerifiedError',
      );

  String get invalidAmountError => Intl.message(
        'Oops… That\'s an invalid amount. '
        'Please enter a valid amount and retry.',
        name: 'invalidAmountError',
      );

  String get invalidCredentialsError => Intl.message(
        'Error. Invalid credentials',
        name: 'invalidCredentialsError',
      );

  String get invalidEmailFormatError => Intl.message(
        'Invalid email format',
        name: 'invalidEmailFormatError',
      );

  String get invalidPasswordFormatError => Intl.message(
        'Please ensure the password adheres to the password policy',
        name: 'invalidPasswordFormatError',
      );

  String get invalidPrivateAddressError => Intl.message(
        'This is not a valid wallet address. Please amend and retry',
        name: 'invalidPrivateAddressError',
      );

  String get invalidPublicAddressError => Intl.message(
        'This is not a valid wallet address. Please amend and retry',
        name: 'invalidPublicAddressError',
      );

  String get invalidSignatureError => Intl.message(
        'This is not a valid signature. Please amend and retry',
        name: 'invalidSignatureError',
      );

  String get invalidWalletLinkSignatureError => Intl.message(
        'This is not a valid signature. Please amend and retry',
        name: 'invalidWalletLinkSignatureError',
      );

  String get linkingRequestAlreadyApprovedError => Intl.message(
        'Error. This linking request has already been approved',
        name: 'linkingRequestAlreadyApprovedError',
      );

  String get linkingRequestAlreadyExistsError => Intl.message(
        'Error. This linking request has already been submitted',
        name: 'linkingRequestAlreadyExistsError',
      );

  String get linkingRequestDoesNotExistError => Intl.message(
        'Error. This linking request can not be found. Please retry.',
        name: 'linkingRequestDoesNotExistError',
      );

  String get loginAlreadyInUseError => Intl.message(
        'An account with this email already exists',
        name: 'loginAlreadyInUseError',
      );

  String get noCustomerWithSuchEmailError => Intl.message(
        'This customer does not exist',
        name: 'noCustomerWithSuchEmailError',
      );

  String notEnoughTokensError(String token) => Intl.message(
        'Sorry, you do not have sufficient $token points for this activity',
        name: 'notEnoughTokensError',
        args: [token],
      );

  String get paymentDoesNotExistError => Intl.message(
        'Sorry, we couldn\'t find this transfer request',
        name: 'paymentDoesNotExistError',
      );

  String get paymentIsNotInACorrectStatusToBeUpdatedError => Intl.message(
        'The request seems to be already completed or canceled.',
        name: 'paymentIsNotInACorrectStatusToBeUpdatedError',
      );

  String get paymentRequestsIsForAnotherCustomerError => Intl.message(
        'Sorry, we couldn\'t find this transfer request',
        name: 'paymentRequestsIsForAnotherCustomerError',
      );

  String get phoneAlreadyExistsError => Intl.message(
        'This phone number is already verified',
        name: 'phoneAlreadyExistsError',
      );

  String get phoneIsAlreadyVerifiedError => Intl.message(
        'An account with this phone number is already verified',
        name: 'phoneIsAlreadyVerifiedError',
      );

  String get referralAlreadyConfirmedError => Intl.message(
        // ignore: lines_longer_than_80_chars
        'It appears this person has already been referred by another user. Why don\'t you try someone else?',
        name: 'referralAlreadyConfirmedError',
      );

  String get referralAlreadyExistError => Intl.message(
        'Error. This user has already been referred',
        name: 'referralAlreadyExistError',
      );

  String get referralNotFoundError => Intl.message(
        'Sorry, we couldn\'t find the referral. Please try again',
        name: 'referralNotFoundError',
      );

  String get referralsLimitExceededError => Intl.message(
        'Wow! You\'re a superstar, you\'ve reached the referral limit',
        name: 'referralsLimitExceededError',
      );

  String get senderCustomerNotFoundError => Intl.message(
        'Sorry, we couldn\'t find this account. Transfer canceled',
        name: 'senderCustomerNotFoundError',
      );

  String get targetCustomerNotFoundError => Intl.message(
        'Sorry, we couldn\'t find this account. Transfer canceled',
        name: 'targetCustomerNotFoundError',
      );

  String get tooManyLoginRequestError => Intl.message(
        'You\'ve exceeded your login attempts. Please contact support.',
        name: 'tooManyLoginRequestError',
      );

  String get transferSourceAndTargetMustBeDifferentError => Intl.message(
        'The source and target wallets cannot be the same',
        name: 'transferSourceAndTargetMustBeDifferentError',
      );

  String get transferSourceCustomerWalletBlockedError => Intl.message(
        'Sorry, your wallet is currently blocked and '
        'cannot accept this transaction',
        name: 'transferSourceCustomerWalletBlockedError',
      );

  String get transferTargetCustomerWalletBlockedError => Intl.message(
        'Sorry, the target wallet is currently blocked and '
        'cannot accept this transaction',
        name: 'transferTargetCustomerWalletBlockedError',
      );

  String get verificationCodeDoesNotExistError => Intl.message(
        'Error. The verification code is invalid',
        name: 'verificationCodeDoesNotExistError',
      );

  String get verificationCodeExpiredError => Intl.message(
        'Error. The verification code has expired',
        name: 'verificationCodeExpiredError',
      );

  String get verificationCodeMismatchError => Intl.message(
        'Error. The verification code is invalid',
        name: 'verificationCodeMismatchError',
      );

//endregion Service errors

//region Friend Referral
  String get inviteAFriend => Intl.message(
        'Invite a Friend',
        name: 'inviteAFriend',
      );

  String get inviteAFriendPageDetails => Intl.message(
        'Enter the details of a friend you would like to invite to the app',
        name: 'inviteAFriendPageDetails',
      );

  String get friendReferralSuccessDetails => Intl.message(
        // ignore: lines_longer_than_80_chars
        'Great! Your referral has been submitted, we will notify you when the points are added to your wallet.',
        name: 'friendReferralSuccessDetails',
      );

//endregion Friend Referral

//region Vouchers

  String get voucherListEmpty => Intl.message(
        'There are no vouchers available at the moment',
        name: 'voucherListEmpty',
      );

  String get voucherCopied => Intl.message(
        'Voucher copied to clipboard',
        name: 'voucherCopied',
      );

//endregion Vouchers

//region Notifications
  String get notifications => Intl.message(
        'Notifications',
        name: 'notifications',
      );

  String get notificationListEmpty => Intl.message(
        'You have no notifications yet',
        name: 'notificationListEmpty',
      );

  String minutesAgo(int minutes) => Intl.plural(minutes,
      one: '$minutes minute ago',
      other: '$minutes minutes ago',
      name: 'minutesAgo',
      args: [minutes]);

  String hoursAgo(int hours) => Intl.plural(hours,
      one: '$hours hour ago',
      other: '$hours hours ago',
      name: 'hoursAgo',
      args: [hours]);

  String daysAgo(int days) => Intl.plural(days,
      one: '$days day ago',
      other: '$days days ago',
      name: 'daysAgo',
      args: [days]);

  String get notificationListMarkAllAsRead => Intl.message(
        'Mark all as read',
        name: 'notificationListMarkAllAsRead',
      );

  String get newHeader => Intl.message(
        'New',
        name: 'newHeader',
      );

  String get earlierHeader => Intl.message(
        'Earlier',
        name: 'earlierHeader',
      );

  String get notificationListRequestGenericErrorSubtitle => Intl.message(
      'Sorry, we are unable to show your notifications, please try again.',
      name: 'notificationListRequestGenericErrorSubtitle');

//endregion Notifications

//region Email prefilling
  String get emailSubject => Intl.message(
        'Subject',
        name: 'emailSubject',
      );

  String get emailBody => Intl.message(
        'Content',
        name: 'emailBody',
      );

//endregion Email prefilling
}
