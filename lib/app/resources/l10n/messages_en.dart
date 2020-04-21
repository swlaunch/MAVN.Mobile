// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(appVersion) => "App version: ${appVersion}";

  static m1(token) => "The ${token} Team";

  static m2(token) =>
      "We don’t want to see you go, deactivating your account permanently locks you out of all your ${token} benefits.";

  static m3(contactNumber) =>
      "For further details, please contact our Customer Support Team on ${contactNumber}.";

  static m4(amount, token) => " ${amount} ${token} points ";

  static m5(amount, token) => "${amount} ${token} points ";

  static m6(token) => "Back to ${token} Wallet";

  static m7(currencyCode, amount) => "${amount} ${currencyCode}";

  static m8(amountInToken, token, amountInCurrency, currency) =>
      "${amountInToken} ${token} = ${amountInCurrency} ${currency}";

  static m9(days) =>
      "${Intl.plural(days, one: '${days} day ago', other: '${days} days ago')}";

  static m10(token) =>
      "Congratulations! You have completed this task! Have a look at other offers to continue earning ${token}s";

  static m11(participationCount) =>
      "${Intl.plural(participationCount, one: 'one time', other: '${participationCount} times')}";

  static m12(number, total) => "${number} / ${total} completed";

  static m13(number) => "You can participate in this offer ${number} times";

  static m14(token) => "Earn ${token} points every time you complete the offer";

  static m15(number) => "${number} completed";

  static m16(fromDate, toDate) => "Valid : from ${fromDate} to ${toDate}";

  static m17(email) =>
      "This link has expired, we’ve sent a new one to ${email}, please check your email and use the new link";

  static m18(days) =>
      "${Intl.plural(days, one: '${days} day', other: '${days} days')}";

  static m19(token) =>
      "Before sending and receiving ${token}s, you need to link an Ethereum wallet, here is how to link it";

  static m20(fee) => "Fee: ${fee}";

  static m21(sender) => "From ${sender}";

  static m22(serviceNumber) =>
      "Oops! It looks like something went wrong. Please try again. If the issue continues, contact our friendly customer service on ${serviceNumber}";

  static m23(count) => "View all (${count})";

  static m24(token, company) =>
      "Thanks for accepting the referral, the next time you stay at ${company} hotel you will be awarded with ${token} points";

  static m25(partnerName) =>
      "Please enter the details for the person you would like to refer to ${partnerName} properties. ";

  static m26(refereeFullName) =>
      "Great! You\'ve successfully referred ${refereeFullName}";

  static m27(partnerName) => " to ${partnerName}";

  static m28(hours) =>
      "${Intl.plural(hours, one: '${hours} hour', other: '${hours} hours')}";

  static m29(hours) =>
      "${Intl.plural(hours, one: '${hours} hour ago', other: '${hours} hours ago')}";

  static m30(refereeFirstName, refereeLastName) =>
      "Great! You\'ve successfully referred ${refereeFirstName} ${refereeLastName}";

  static m31(partnerName) => " to ${partnerName} properties";

  static m32(token) =>
      "Transfer balance from your linked external wallet to your ${token} wallet";

  static m33(token) => "Receive ${token} points from external wallet";

  static m34(token) =>
      "Transfer from your ${token} wallet to your linked external wallet";

  static m35(token) => "Transfer ${token} points to external wallet";

  static m36(attemptNumber) =>
      "${Intl.plural(attemptNumber, one: 'You have ${attemptNumber} more attempt to sign in, after that your account will be temporarily locked.', other: 'You have ${attemptNumber} more attempts to sign in, after that your account will be temporarily locked.')}";

  static m37(numberOfMinutes) =>
      "${Intl.plural(numberOfMinutes, one: 'Your account has been locked. Please try again in ${numberOfMinutes} minute.', other: 'Your account has been locked. Please try again in ${numberOfMinutes} minutes.')}";

  static m38(period) =>
      "We are undergoing some routine maintenance and will be up and running in the next ${period}";

  static m39(maxLength) =>
      "Phone number can only be a maximum of ${maxLength} digits long";

  static m40(precision) =>
      "Amount should not exceed ${precision} decimal places";

  static m41(minLength) =>
      "${Intl.plural(minLength, one: 'Minimum length should be at least one character', other: 'Minimum length should be at least ${minLength} characters')}";

  static m42(minLength) =>
      "Phone number should be at least ${minLength} digits long";

  static m43(minutes) =>
      "${Intl.plural(minutes, one: '${minutes} minute ago', other: '${minutes} minutes ago')}";

  static m44(firstPartnerName, numberOfPartner) =>
      "${Intl.plural(numberOfPartner, one: '${firstPartnerName} & ${numberOfPartner} other', other: '${firstPartnerName} & ${numberOfPartner} others')}";

  static m45(token) => "Start earning ${token} now!";

  static m46(token) =>
      "Sorry, you do not have sufficient ${token} points for this activity";

  static m47(appName) => "Welcome to ${appName}";

  static m48(token, company) =>
      "Earn ${token} points by referring friends to ${company} and much more";

  static m49(token) => "Start earning ${token} points";

  static m50(token, company) =>
      "Use your ${token} points on ${company} for invoices, hotel stays, restaurants and much more";

  static m51(token) => "Use ${token} points easily";

  static m52(count) =>
      "${Intl.plural(count, one: 'Make sure your password contains at least one lower case character', other: 'Make sure your password contains at least ${count} lower case characters')}";

  static m53(count) =>
      "${Intl.plural(count, one: 'Make sure your password contains at least one numeric character', other: 'Make sure your password contains at least ${count} numeric characters')}";

  static m54(count, specialCharacters) =>
      "${Intl.plural(count, one: 'Make sure your password contains at least one special character (${specialCharacters})', other: 'Make sure your password contains at least ${count} special characters (${specialCharacters})')}";

  static m55(count) =>
      "Make sure your password is at most ${count} characters long";

  static m56(count) =>
      "Make sure your password is at least ${count} characters long";

  static m57(count) =>
      "${Intl.plural(count, one: 'Make sure your password contains at least one upper case character', other: 'Make sure your password contains at least ${count} upper case characters')}";

  static m58(count) => "${count} characters";

  static m59(count) =>
      "${Intl.plural(count, one: 'One lowercase character', other: '${count} lowercase characters')}";

  static m60(count) =>
      "${Intl.plural(count, one: 'One number', other: '${count} numbers')}";

  static m61(count, specialCharacters) =>
      "${Intl.plural(count, one: 'One special character (${specialCharacters})', other: '${count} special characters (${specialCharacters})')}";

  static m62(count) =>
      "${Intl.plural(count, one: 'One uppercase character', other: '${count} uppercase characters')}";

  static m63(phoneNumber) =>
      "We’ve sent a verification code  to ${phoneNumber}";

  static m64(timeLeft) => "Resend code in ${timeLeft}";

  static m65(appName) =>
      "Create a PIN to quickly sign in to your ${appName} account next time";

  static m66(count) =>
      "You have ${count} attempts remaining after which you will need to sign-in with your email and password";

  static m67(person) => "Contact ${person}";

  static m68(firstName, lastName) => "${firstName} ${lastName}";

  static m69(amount, currencyName) => "Equals to: ${amount} ${currencyName}";

  static m70(token) => "From external wallet to ${token} wallet";

  static m71(token) => "Receive ${token} points";

  static m72(token) => "Transfer ${token}";

  static m73(token) => "From ${token} wallet to external wallet";

  static m74(token) => "Transfer ${token}";

  static m75(time) =>
      "If your friend doesn\'t accept the invite within ${time} you will lose ";

  static m76(step, totalSteps) => "${step} of ${totalSteps}";

  static m77(recipient) => "To ${recipient}";

  static m78(token) => "Amount (${token} points)";

  static m79(token) =>
      "Transfer ${token} points easily, scan the receivers QR code or enter their email address";

  static m80(token) => "Transfer ${token} points";

  static m81(lockedAmount) => "${lockedAmount} are locked";

  static m82(token) =>
      "Your ${token}s have been transferred. We’ll notify you when the operation is completed.";

  static m83(requestedAmount) => "You cannot pay more than ${requestedAmount}";

  static m84(id) => "ID : ${id}";

  static m85(transferRequestOrganization) =>
      "You received a transfer request from ${transferRequestOrganization}. Please review and confirm it.";

  static m86(token) => "Sending Amount (${token})";

  static m87(recipientId) => "ID: ${recipientId}";

  static m88(amountTokens, token, amountCurrency, currencyCode) =>
      "${amountTokens} ${token} (${amountCurrency} ${currencyCode})";

  static m89(token) => "Transfer amount (${token})";

  static m90(soldCount) => "${soldCount} used this offer";

  static m91(stockCount) =>
      "${Intl.plural(stockCount, zero: 'Out of stock', other: '${stockCount} left')}";

  static m92(count) =>
      "${Intl.plural(count, zero: 'You have no pending transfers', one: 'You have ${count} pending transfer', other: 'You have ${count} pending transfers')}";

  static m93(token) => "Receive points from other ${token} users";

  static m94(token) => "Receive ${token} points";

  static m95(token) => "Send ${token} points to anyone";

  static m96(token) => "Received ${token} points";

  static m97(token) => "Sent ${token} points";

  static m98(appName) => "Welcome to ${appName}";

  static m99(token) => "Earn and use ${token}s across the world";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static _notInlinedMessages(_) => <String, Function>{
        "accountAppVersion": m0,
        "accountDeactivatedLaunchContactNumberError":
            MessageLookupByLibrary.simpleMessage(
                "Your phone app failed to launch"),
        "accountDeactivatedPageContactButton":
            MessageLookupByLibrary.simpleMessage("Contact our support team"),
        "accountDeactivatedPageMessageClosePart1":
            MessageLookupByLibrary.simpleMessage("Kind regards,"),
        "accountDeactivatedPageMessageClosePart2": m1,
        "accountDeactivatedPageMessagePart1":
            MessageLookupByLibrary.simpleMessage("You\'ll be missed"),
        "accountDeactivatedPageMessagePart2": m2,
        "accountDeactivatedPageMessagePart3": m3,
        "accountDeactivatedPageTitle": MessageLookupByLibrary.simpleMessage(
            "It\'s sad to see you leave, but we hope to see you again soon"),
        "accountPageBiometricsSignInOptionAndroid":
            MessageLookupByLibrary.simpleMessage(
                "Sign-in with your fingerprint"),
        "accountPageBiometricsSignInOptionIOS":
            MessageLookupByLibrary.simpleMessage(
                "Sign-in with Touch ID/Face ID"),
        "accountPageChangePasswordOption":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "accountPageLogOutConfirmContent": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to log out?"),
        "accountPageLogOutConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Please confirm"),
        "accountPageLogoutOption":
            MessageLookupByLibrary.simpleMessage("Log out"),
        "accountPagePersonalDetailsOption":
            MessageLookupByLibrary.simpleMessage("Personal details"),
        "accountPageTitle": MessageLookupByLibrary.simpleMessage("My account"),
        "addPhoneAndRefCodeHeader":
            MessageLookupByLibrary.simpleMessage("Phone and referral code"),
        "advancedWalletsDescription": MessageLookupByLibrary.simpleMessage(
            "My Crypto, My Ether Wallet, …"),
        "advancedWalletsTitle":
            MessageLookupByLibrary.simpleMessage("Advanced wallets"),
        "amountTokens": m4,
        "amountTokensHolder": m5,
        "and": MessageLookupByLibrary.simpleMessage(" and "),
        "approvedReferralListEmptyState": MessageLookupByLibrary.simpleMessage(
            "You have no approved referrals at the moment"),
        "backToTokenWalletButton": m6,
        "backToWalletButton":
            MessageLookupByLibrary.simpleMessage("Back to Wallet"),
        "balanceBoxErrorMessage": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to process your balance"),
        "balanceBoxHeader": MessageLookupByLibrary.simpleMessage("Balance"),
        "barcodeScanError": MessageLookupByLibrary.simpleMessage(
            "There was a problem scanning the QR code. Please try again."),
        "barcodeScanPermissionError": MessageLookupByLibrary.simpleMessage(
            "Camera permission is required for QR code scanning."),
        "biometricAuthenticationDialogMessageAndroid":
            MessageLookupByLibrary.simpleMessage(
                "Next time, sign-in using your fingerprint. It\'s fast, easy and secure."),
        "biometricAuthenticationDialogMessageIOS":
            MessageLookupByLibrary.simpleMessage(
                "Next time, sign-in using Touch ID/Face ID. It\'s fast, easy and secure."),
        "biometricAuthenticationDialogTitleAndroid":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to enable fingerprint security?"),
        "biometricAuthenticationDialogTitleIOS":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to enable Touch ID/Face ID?"),
        "biometricAuthenticationPromptMessage":
            MessageLookupByLibrary.simpleMessage(
                "Sign-in with your fingerprint"),
        "biometricAuthenticationPromptTitle":
            MessageLookupByLibrary.simpleMessage("Hello"),
        "biometricsGoToSettingsDescription": MessageLookupByLibrary.simpleMessage(
            "Biometric authentication is not set up on your device. Please enable either Touch ID or Face ID on your phone."),
        "bottomBarExplore": MessageLookupByLibrary.simpleMessage("Explore"),
        "bottomBarOffers": MessageLookupByLibrary.simpleMessage("Offers"),
        "bottomBarSocial": MessageLookupByLibrary.simpleMessage("Community"),
        "bottomBarWallet": MessageLookupByLibrary.simpleMessage("Wallet"),
        "cameraPreviewRetakeButton":
            MessageLookupByLibrary.simpleMessage("Retake"),
        "cameraPreviewTitle":
            MessageLookupByLibrary.simpleMessage("\nPleased with the result?"),
        "cameraViewGuide": MessageLookupByLibrary.simpleMessage(
            "•\tPlace fully in the frame, not cut off\n•\tAvoid glare so that all info is visible\n•\tHold steady to avoid a blurry scan"),
        "canNotReferYourselfError": MessageLookupByLibrary.simpleMessage(
            "Self-referral is not possible. Your referral cannot be submitted."),
        "cannotGetOffersError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to show any offers at this moment, please try again"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "changePasswordPageConfirmPasswordHint":
            MessageLookupByLibrary.simpleMessage("Please confirm new password"),
        "changePasswordPagePasswordHint":
            MessageLookupByLibrary.simpleMessage("Please enter new password"),
        "changePasswordPagePasswordLabel":
            MessageLookupByLibrary.simpleMessage("New password*"),
        "changePasswordPagePrompt": MessageLookupByLibrary.simpleMessage(
            "Please create a new password "),
        "changePasswordSuccessBackToAccountButton":
            MessageLookupByLibrary.simpleMessage("Back to account"),
        "changePasswordSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Great! Your password has been changed."),
        "changePasswordSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Password updated"),
        "confirmPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Confirm password*"),
        "contactUsButton": MessageLookupByLibrary.simpleMessage("Contact us"),
        "contactUsEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "contactUsGenericErrorSubtitle": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to show contact information please try again."),
        "contactUsLaunchContactEmailError":
            MessageLookupByLibrary.simpleMessage(
                "There was a problem launching your email app."),
        "contactUsLaunchContactNumberError":
            MessageLookupByLibrary.simpleMessage(
                "There was a problem launching your phone app."),
        "contactUsPageDetail": MessageLookupByLibrary.simpleMessage(
            "Feel free to get in touch with us for any help and support"),
        "contactUsPhoneNumber":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "contactUsWhatsApp": MessageLookupByLibrary.simpleMessage("Whatsapp"),
        "contactUsWhatsAppStartingMessage":
            MessageLookupByLibrary.simpleMessage("Hello"),
        "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
        "conversionRate": m7,
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Copied to Clipboard"),
        "copyEmail": MessageLookupByLibrary.simpleMessage("Copy email"),
        "couldNotLoadBalanceError": MessageLookupByLibrary.simpleMessage(
            "We are unable to make transactions at this point as we could not retrieve your balance. Please try again."),
        "countryCodeEmptyPrompt": MessageLookupByLibrary.simpleMessage("Code"),
        "countryCodeListPageTitle":
            MessageLookupByLibrary.simpleMessage("Select your country code"),
        "countryListFilterHint":
            MessageLookupByLibrary.simpleMessage("Search for country name"),
        "countryListPageTitle":
            MessageLookupByLibrary.simpleMessage("Select country"),
        "createAPasswordHeader":
            MessageLookupByLibrary.simpleMessage("Create a password"),
        "currencyConversionLabel": m8,
        "customerBlockedError": MessageLookupByLibrary.simpleMessage(
            "This account is currently blocked"),
        "customerDoesNotExistError": MessageLookupByLibrary.simpleMessage(
            "Sorry, the customer could not be found"),
        "customerPhoneIsMissingError": MessageLookupByLibrary.simpleMessage(
            "Error. User\'s phone number could not be retrieved"),
        "customerProfileDoesNotExistError":
            MessageLookupByLibrary.simpleMessage(
                "Error. User could not be found"),
        "customerWalletBlockedError": MessageLookupByLibrary.simpleMessage(
            "Sorry, your wallet is currently blocked and cannot process transactions"),
        "dapBrowserHint": MessageLookupByLibrary.simpleMessage(
            "You can also copy the linking url to open in a dApp Browser"),
        "dateTimeToday": MessageLookupByLibrary.simpleMessage("Today"),
        "dateTimeYesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
        "daysAgo": m9,
        "defaultGenericError": MessageLookupByLibrary.simpleMessage(
            "Oops! It looks like something went wrong. Please try again."),
        "deleteAccountDialogCancelButton":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "deleteAccountDialogDeleteButton":
            MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccountDialogDetails": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete your account?"),
        "deleteAccountDialogTitle":
            MessageLookupByLibrary.simpleMessage("Delete account"),
        "doneButton": MessageLookupByLibrary.simpleMessage("Done"),
        "earlierHeader": MessageLookupByLibrary.simpleMessage("Earlier"),
        "earn": MessageLookupByLibrary.simpleMessage("Earn"),
        "earnDetailPageGenericErrorSubTitle":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, we are unable to show task details please try again."),
        "earnRuleCampaignMissionSubtitle": MessageLookupByLibrary.simpleMessage(
            "Finish the tasks below and earn the offer award!"),
        "earnRuleCampaignMissionTitle":
            MessageLookupByLibrary.simpleMessage("Task mission"),
        "earnRuleCompletionMessage": m10,
        "earnRuleConditionCompleted":
            MessageLookupByLibrary.simpleMessage("Completed"),
        "earnRuleConditionGetStarted":
            MessageLookupByLibrary.simpleMessage("Get started"),
        "earnRuleDetailsEarnUponCompletion":
            MessageLookupByLibrary.simpleMessage(
                "Each time you complete this task, you could earn "),
        "earnRuleDetailsEarnUponCompletionConversionRate":
            MessageLookupByLibrary.simpleMessage(
                " (* indicative amount based on average night stay)."),
        "earnRuleDetailsHowItWorks":
            MessageLookupByLibrary.simpleMessage("How it works"),
        "earnRuleDetailsLowBalanceErrorPart1":
            MessageLookupByLibrary.simpleMessage("You need "),
        "earnRuleDetailsLowBalanceErrorPart2":
            MessageLookupByLibrary.simpleMessage(
                " in order to be eligible to participate in this offer."),
        "earnRuleDetailsOfferUnavailableTitle":
            MessageLookupByLibrary.simpleMessage("Task unavailable"),
        "earnRuleDetailsParticipationCount": m11,
        "earnRuleDetailsParticipationLimit":
            MessageLookupByLibrary.simpleMessage("You can participate "),
        "earnRuleDetailsParticipationLimitError":
            MessageLookupByLibrary.simpleMessage(
                "You’ve reached the limit of times to participate in this offer."),
        "earnRuleDetailsPreviousParticipationPart1":
            MessageLookupByLibrary.simpleMessage(
                "You have successfully participated "),
        "earnRuleDetailsPreviousParticipationPart2":
            MessageLookupByLibrary.simpleMessage(" and earned "),
        "earnRuleDetailsPreviousParticipationPart3":
            MessageLookupByLibrary.simpleMessage(" so far"),
        "earnRuleDetailsReadMoreButton":
            MessageLookupByLibrary.simpleMessage("Read more"),
        "earnRuleDetailsStakingAmountPart1":
            MessageLookupByLibrary.simpleMessage(
                "This offer requires you to lock "),
        "earnRuleDetailsStakingAmountPart2":
            MessageLookupByLibrary.simpleMessage(" to participate"),
        "earnRuleDetailsUnlimitedParticipation":
            MessageLookupByLibrary.simpleMessage(
                "You can participate unlimited times."),
        "earnRuleDetailsViewOffersButton":
            MessageLookupByLibrary.simpleMessage("View other offers"),
        "earnRuleIndicativeAmountInfoGeneric":
            MessageLookupByLibrary.simpleMessage(
                "* This is an indicative amount."),
        "earnRuleIndicativeAmountInfoHospitality":
            MessageLookupByLibrary.simpleMessage(
                "* This is an indicative amount based on average night stay."),
        "earnRuleIndicativeAmountInfoRealEstate":
            MessageLookupByLibrary.simpleMessage(
                "* It will depend on the property price."),
        "earnRuleLimitedCompletionInfo": m12,
        "earnRuleLimitedParticipationInfo": m13,
        "earnRuleOnlyOnceParticipationInfo":
            MessageLookupByLibrary.simpleMessage(
                "You can participate in this only once"),
        "earnRulePageEmpty": MessageLookupByLibrary.simpleMessage(
            "Sorry, it appears there are no earn offers right now"),
        "earnRulePageInitialPageError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to load earn offers right now"),
        "earnRulePagePaginationError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to show more earn offers right now"),
        "earnRuleRewardBoxSubTitle": m14,
        "earnRuleRewardBoxTitle":
            MessageLookupByLibrary.simpleMessage("Offer Award"),
        "earnRuleUnlimitedCompletionInfo": m15,
        "earnRuleUnlimitedParticipationInfo":
            MessageLookupByLibrary.simpleMessage(
                "You can participate in this offer unlimited times"),
        "earnRuleValidDate": m16,
        "earnRuleViewOtherOffers":
            MessageLookupByLibrary.simpleMessage("View other offers"),
        "emailAddressHint":
            MessageLookupByLibrary.simpleMessage("Enter email address"),
        "emailBody": MessageLookupByLibrary.simpleMessage("Content"),
        "emailIsAlreadyVerifiedError": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists"),
        "emailRequiredLabel": MessageLookupByLibrary.simpleMessage("Email*"),
        "emailSubject": MessageLookupByLibrary.simpleMessage("Subject"),
        "emailVerificationButton":
            MessageLookupByLibrary.simpleMessage("Resend link"),
        "emailVerificationExceededMaxAttemptsError":
            MessageLookupByLibrary.simpleMessage(
                "Too many attempts, please try again later"),
        "emailVerificationLinkExpired": m17,
        "emailVerificationMessage1": MessageLookupByLibrary.simpleMessage(
            "We’ve sent a confirmation to: "),
        "emailVerificationMessage1Resent": MessageLookupByLibrary.simpleMessage(
            "We’ve resent a confirmation to: "),
        "emailVerificationMessage2": MessageLookupByLibrary.simpleMessage(
            "Check your email and click on the confirmation link to continue"),
        "emailVerificationResetText": MessageLookupByLibrary.simpleMessage(
            "Didn’t receive an email? resend the link"),
        "emailVerificationSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Thanks! your email address has been confirmed"),
        "emailVerificationSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Email confirmed"),
        "emailVerificationTitle":
            MessageLookupByLibrary.simpleMessage("Confirm email address"),
        "emptyCountryCodeClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Country code is required"),
        "emptyEmailClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Email is required"),
        "emptyFirstNameClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("First name is required"),
        "emptyFullNameClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "emptyLastNameClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Last name is required"),
        "emptyLinkAdvancedWalletTextFieldCodeSignatureError":
            MessageLookupByLibrary.simpleMessage(
                "Linking code signature is required"),
        "emptyLinkAdvancedWalletTextFieldPublicAddressError":
            MessageLookupByLibrary.simpleMessage(
                "Public account address is required"),
        "emptyNameClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "emptyPasswordClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Password is required"),
        "emptyPaymentInvoiceError":
            MessageLookupByLibrary.simpleMessage("Invoice number is required"),
        "emptyPhoneNumberClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Phone number is required"),
        "enterAmountHint": MessageLookupByLibrary.simpleMessage("Enter amount"),
        "expirationFormatDays": m18,
        "expiredReferralListEmptyState": MessageLookupByLibrary.simpleMessage(
            "You have no expired referrals at the moment"),
        "externalLinkWalletDescription": m19,
        "externalWalletHint":
            MessageLookupByLibrary.simpleMessage("Link to your account"),
        "externalWalletTitle":
            MessageLookupByLibrary.simpleMessage("Your external wallet"),
        "feeLabel": m20,
        "firstNameHint":
            MessageLookupByLibrary.simpleMessage("Enter first name"),
        "firstNameNotRequiredLabel":
            MessageLookupByLibrary.simpleMessage("First name"),
        "firstNameRequiredLabel":
            MessageLookupByLibrary.simpleMessage("First name*"),
        "friendReferralSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Great! Your referral has been submitted, we will notify you when the points are added to your wallet."),
        "from": m21,
        "genericError": m22,
        "genericErrorShort":
            MessageLookupByLibrary.simpleMessage("Please try again."),
        "getStartedButton": MessageLookupByLibrary.simpleMessage("Get started"),
        "goToWallet": MessageLookupByLibrary.simpleMessage("Go to Wallet"),
        "homePageCountdownSubtitle": MessageLookupByLibrary.simpleMessage(
            "are waiting for you, hurry up"),
        "homePageCountdownTitle":
            MessageLookupByLibrary.simpleMessage("Countdown!"),
        "homePageCountdownViewAll": m23,
        "hotelPreCheckoutDialogHeading":
            MessageLookupByLibrary.simpleMessage("Thanks for staying with us"),
        "hotelPreCheckoutDialogViewInvoiceButton":
            MessageLookupByLibrary.simpleMessage("View Invoice"),
        "hotelReferralAcceptedSuccessBody": m24,
        "hotelReferralErrorDetails": MessageLookupByLibrary.simpleMessage(
            "We were unable submit your referral, please retry"),
        "hotelReferralErrorLeadAlreadyExists":
            MessageLookupByLibrary.simpleMessage(
                "This referral already exists."),
        "hotelReferralErrorTitle":
            MessageLookupByLibrary.simpleMessage("Invite unsuccessful"),
        "hotelReferralFullNameFieldHint":
            MessageLookupByLibrary.simpleMessage("Enter full name"),
        "hotelReferralFullNameFieldLabel":
            MessageLookupByLibrary.simpleMessage("Full name*"),
        "hotelReferralPageButton":
            MessageLookupByLibrary.simpleMessage("Send invite"),
        "hotelReferralPageDescription": MessageLookupByLibrary.simpleMessage(
            "Please enter your referral\'s email address"),
        "hotelReferralPageTitle":
            MessageLookupByLibrary.simpleMessage("Refer a hotel"),
        "hotelReferralPartnerInfo": m25,
        "hotelReferralStakingInfo":
            MessageLookupByLibrary.simpleMessage("You are required to lock "),
        "hotelReferralSuccessPageDetails": m26,
        "hotelReferralSuccessPageDetailsPartnerName": m27,
        "hours": m28,
        "hoursAgo": m29,
        "installmentOverdue": MessageLookupByLibrary.simpleMessage("Overdue"),
        "instalmentListChooseAnInstalment":
            MessageLookupByLibrary.simpleMessage("Choose an installment"),
        "insufficientBalanceError": MessageLookupByLibrary.simpleMessage(
            "We are unable to make transactions at this point as we could not load your balance"),
        "insufficientFunds": MessageLookupByLibrary.simpleMessage(
            "You have insufficient funds to link to an external wallet"),
        "invalidAmountError": MessageLookupByLibrary.simpleMessage(
            "Oops… That\'s an invalid amount. Please enter a valid amount and retry."),
        "invalidCharactersClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Invalid characters"),
        "invalidCredentialsError":
            MessageLookupByLibrary.simpleMessage("Error. Invalid credentials"),
        "invalidEmailClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "invalidEmailFormatError":
            MessageLookupByLibrary.simpleMessage("Invalid email format"),
        "invalidFirstNameClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("First name is invalid"),
        "invalidLastNameClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Last name is invalid"),
        "invalidPasswordFormatError": MessageLookupByLibrary.simpleMessage(
            "Please ensure the password adheres to the password policy"),
        "invalidPhoneNumberClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Invalid phone number"),
        "invalidPrivateAddressError": MessageLookupByLibrary.simpleMessage(
            "This is not a valid wallet address. Please amend and retry"),
        "invalidPublicAddressError": MessageLookupByLibrary.simpleMessage(
            "This is not a valid wallet address. Please amend and retry"),
        "invalidSignatureError": MessageLookupByLibrary.simpleMessage(
            "This is not a valid signature. Please amend and retry"),
        "invalidWalletLinkSignatureError": MessageLookupByLibrary.simpleMessage(
            "This is not a valid signature. Please amend and retry"),
        "inviteAFriend":
            MessageLookupByLibrary.simpleMessage("Invite a Friend"),
        "inviteAFriendPageDetails": MessageLookupByLibrary.simpleMessage(
            "Enter the details of a friend you would like to invite to the app"),
        "inviteFriendEarnUpToPart1":
            MessageLookupByLibrary.simpleMessage("Earn up to "),
        "inviteFriendEarnUpToPart2": MessageLookupByLibrary.simpleMessage(
            " for every friend you invite to the app"),
        "inviteFriendSectionTitle":
            MessageLookupByLibrary.simpleMessage("Invite a friend"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("Enter last name"),
        "lastNameNotRequiredLabel":
            MessageLookupByLibrary.simpleMessage("Last name"),
        "lastNameRequiredLabel":
            MessageLookupByLibrary.simpleMessage("Last name*"),
        "leadReferralAcceptedSuccessBody": MessageLookupByLibrary.simpleMessage(
            "Thanks for accepting the referral."),
        "leadReferralFormPageCommunityOfInterestLabel":
            MessageLookupByLibrary.simpleMessage(
                "Community/Property of interest"),
        "leadReferralPageTitle":
            MessageLookupByLibrary.simpleMessage("Refer a friend"),
        "leadReferralSuccessPageDetails": m30,
        "leadReferralSuccessPageDetailsPartnerName": m31,
        "linkAdvancedWalletButton":
            MessageLookupByLibrary.simpleMessage("Link wallet"),
        "linkAdvancedWalletDescription": MessageLookupByLibrary.simpleMessage(
            "To link to an advanced wallet, you must be using an app that supports signatures"),
        "linkAdvancedWalletHeader":
            MessageLookupByLibrary.simpleMessage("Link an advanced wallet"),
        "linkAdvancedWalletInstructionCopyCode":
            MessageLookupByLibrary.simpleMessage("Copy this code"),
        "linkAdvancedWalletInstructionCopySignature":
            MessageLookupByLibrary.simpleMessage("Copy the signature"),
        "linkAdvancedWalletInstructionPasteSignature":
            MessageLookupByLibrary.simpleMessage("Paste it in the field below"),
        "linkAdvancedWalletInstructionPublicAddress":
            MessageLookupByLibrary.simpleMessage(
                "Enter your public address and tap ‘Link wallet’"),
        "linkAdvancedWalletInstructionSignMessage":
            MessageLookupByLibrary.simpleMessage(
                "Sign a message with this code"),
        "linkAdvancedWalletInstructionSwitchApp":
            MessageLookupByLibrary.simpleMessage(
                "Switch to the wallet app you want to link"),
        "linkAdvancedWalletTextFieldCodeSignatureHint":
            MessageLookupByLibrary.simpleMessage("Paste signature here"),
        "linkAdvancedWalletTextFieldCodeSignatureTitle":
            MessageLookupByLibrary.simpleMessage("Linking code signature"),
        "linkAdvancedWalletTextFieldPublicAddressHint":
            MessageLookupByLibrary.simpleMessage(
                "Enter public account address"),
        "linkAdvancedWalletTextFieldPublicAddressTitle":
            MessageLookupByLibrary.simpleMessage("Public account address"),
        "linkSimpleWalletDescription": MessageLookupByLibrary.simpleMessage(
            "To link to a simple wallet, copy the linking url and paste in your external wallet"),
        "linkSimpleWalletHeader":
            MessageLookupByLibrary.simpleMessage("Link a simple wallet"),
        "linkSimpleWalletInstructionCopyUrl":
            MessageLookupByLibrary.simpleMessage("Copy this url"),
        "linkSimpleWalletInstructionPasteAddress":
            MessageLookupByLibrary.simpleMessage(
                "Paste it in the address field"),
        "linkSimpleWalletInstructionPasteLink":
            MessageLookupByLibrary.simpleMessage("Press \"link wallet\""),
        "linkSimpleWalletInstructionSwitchToWallet":
            MessageLookupByLibrary.simpleMessage(
                "Switch to the wallet app you want to link"),
        "linkWalletChooseSupportedWallets":
            MessageLookupByLibrary.simpleMessage("Choose any supported wallet"),
        "linkWalletHeader":
            MessageLookupByLibrary.simpleMessage("Link an external wallet"),
        "linkWalletInProgressDescription": MessageLookupByLibrary.simpleMessage(
            "This may take a while, you can continue using the app we will let you know once it completed"),
        "linkWalletInProgressHeader":
            MessageLookupByLibrary.simpleMessage("Linking in progress"),
        "linkWalletInProgressTitle": MessageLookupByLibrary.simpleMessage(
            "Your wallet is currently being linked"),
        "linkWalletInstructionConfirmLinking":
            MessageLookupByLibrary.simpleMessage(
                "Follow the instructions to confirm the linking"),
        "linkWalletInstructionFees": MessageLookupByLibrary.simpleMessage(
            "Linking external wallets has associated fees"),
        "linkWalletInstructionSelectWallet":
            MessageLookupByLibrary.simpleMessage(
                "Select a wallet from the options below"),
        "linkWalletReceiveCopyAddress":
            MessageLookupByLibrary.simpleMessage("Copy address"),
        "linkWalletReceiveHint": m32,
        "linkWalletReceiveNote": MessageLookupByLibrary.simpleMessage(
            "Note: Funds will be lost if you use a wallet other than your linked external wallet"),
        "linkWalletReceiveTitle": m33,
        "linkWalletTransferFailedDetails": MessageLookupByLibrary.simpleMessage(
            "We were unable to complete your transfer, please try again."),
        "linkWalletTransferFailedSubDetails":
            MessageLookupByLibrary.simpleMessage(
                "Your transaction failed due to public blockchain error."),
        "linkWalletTransferFailedTitle":
            MessageLookupByLibrary.simpleMessage("Transfer failed"),
        "linkYourWallet":
            MessageLookupByLibrary.simpleMessage("Link to your account"),
        "linkedWalletHeader":
            MessageLookupByLibrary.simpleMessage("Your external wallet"),
        "linkedWalletSendHint": m34,
        "linkedWalletSendTitle": m35,
        "linkingRequestAlreadyApprovedError":
            MessageLookupByLibrary.simpleMessage(
                "Error. This linking request has already been approved"),
        "linkingRequestAlreadyExistsError":
            MessageLookupByLibrary.simpleMessage(
                "Error. This linking request has already been submitted"),
        "linkingRequestDoesNotExistError": MessageLookupByLibrary.simpleMessage(
            "Error. This linking request can not be found. Please retry."),
        "linkingWalletDisabled":
            MessageLookupByLibrary.simpleMessage("Currently disabled"),
        "listNoResultsDetails": MessageLookupByLibrary.simpleMessage(
            "We can’t find any item matching your search"),
        "listNoResultsTitle":
            MessageLookupByLibrary.simpleMessage("No results found"),
        "loginAlreadyInUseError": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists"),
        "loginPageEmailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "loginPageForgottenPasswordButton":
            MessageLookupByLibrary.simpleMessage("Forgot password"),
        "loginPageHeader": MessageLookupByLibrary.simpleMessage("Sign-in"),
        "loginPageInvalidCredentialsError":
            MessageLookupByLibrary.simpleMessage(
                "Your login details are incorrect. Please try again."),
        "loginPageLoginAttemptWarningMessage": m36,
        "loginPageLoginSubmitButton":
            MessageLookupByLibrary.simpleMessage("Sign in"),
        "loginPagePasswordHint":
            MessageLookupByLibrary.simpleMessage("Enter password"),
        "loginPagePasswordLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "loginPageTooManyRequestMessage": m37,
        "loginPageUnauthorizedRedirectionMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your session has expired, please log in again"),
        "maintenanceDescription": m38,
        "maintenanceErrorCoupleOfHours":
            MessageLookupByLibrary.simpleMessage("couple of hours"),
        "maintenanceErrorMessage": MessageLookupByLibrary.simpleMessage(
            "The system is under maintenance. Please try again later."),
        "maintenanceTitle":
            MessageLookupByLibrary.simpleMessage("Ongoing maintenance"),
        "mandatoryAppUpgradePageButton":
            MessageLookupByLibrary.simpleMessage("Update"),
        "mandatoryAppUpgradePageContent": MessageLookupByLibrary.simpleMessage(
            "A new version of the app available to download. Please update in order to continue."),
        "mandatoryAppUpgradePageTitle":
            MessageLookupByLibrary.simpleMessage("Update required"),
        "maxPhoneNumberLengthClientSideValidationError": m39,
        "maximumDecimalPlacesError": m40,
        "minLengthClientSideValidationError": m41,
        "minPhoneNumberLengthClientSideValidationError": m42,
        "minutesAgo": m43,
        "monthlyChallenges":
            MessageLookupByLibrary.simpleMessage("Monthly challenges"),
        "monthlyChallengesSubtitle": MessageLookupByLibrary.simpleMessage(
            "Test yourself and earn points"),
        "multiplePartnersTitle": m44,
        "nationalityHint":
            MessageLookupByLibrary.simpleMessage("Enter nationality"),
        "nationalityLabel": MessageLookupByLibrary.simpleMessage("Nationality"),
        "nationalityListPageTitle":
            MessageLookupByLibrary.simpleMessage("Select nationality"),
        "nationalityOptionalLabel":
            MessageLookupByLibrary.simpleMessage("Nationality (optional)"),
        "networkError": MessageLookupByLibrary.simpleMessage(
            "It seems you\'re not connected to the internet. Please check your connection and try again."),
        "networkErrorTitle":
            MessageLookupByLibrary.simpleMessage("Internet connection problem"),
        "newHeader": MessageLookupByLibrary.simpleMessage("New"),
        "nextPageButton": MessageLookupByLibrary.simpleMessage("Next"),
        "noCustomerWithSuchEmailError": MessageLookupByLibrary.simpleMessage(
            "This customer does not exist"),
        "noTokensConversionRateText": m45,
        "noVouchersInStockError": MessageLookupByLibrary.simpleMessage(
            "Sorry, all vouchers are sold out"),
        "nonMandatoryAppUpgradeDialogContent": MessageLookupByLibrary.simpleMessage(
            "There is a new version of the app available to download. Please update so you can see the latest changes."),
        "nonMandatoryAppUpgradeDialogNegativeButton":
            MessageLookupByLibrary.simpleMessage("No, thanks"),
        "nonMandatoryAppUpgradeDialogPositiveButton":
            MessageLookupByLibrary.simpleMessage("Update"),
        "nonMandatoryAppUpgradeDialogTitle":
            MessageLookupByLibrary.simpleMessage("New version available"),
        "notEnoughTokensError": m46,
        "noteHint":
            MessageLookupByLibrary.simpleMessage("Add additional notes"),
        "noteLabel": MessageLookupByLibrary.simpleMessage("Notes"),
        "notificationListEmpty": MessageLookupByLibrary.simpleMessage(
            "You have no notifications yet"),
        "notificationListMarkAllAsRead":
            MessageLookupByLibrary.simpleMessage("Mark all as read"),
        "notificationListRequestGenericErrorSubtitle":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, we are unable to show your notifications, please try again."),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "offerDetailGenericError": MessageLookupByLibrary.simpleMessage(
            "We are unable to load offer details at the moment. Please try again."),
        "offers": MessageLookupByLibrary.simpleMessage("Offers"),
        "onboardingPage1Title": m47,
        "onboardingPage2Details": m48,
        "onboardingPage2Title": m49,
        "onboardingPage3Details": m50,
        "onboardingPage3Title": m51,
        "onboardingSkipButton": MessageLookupByLibrary.simpleMessage("Skip"),
        "outOfStockDescription": MessageLookupByLibrary.simpleMessage(
            "The vouchers in this offer are currently sold out."),
        "partnerDetailsPageTitle":
            MessageLookupByLibrary.simpleMessage("Partner Details"),
        "passwordGuide": MessageLookupByLibrary.simpleMessage(
            "We care about your security, please make sure your password has at least:"),
        "passwordHint": MessageLookupByLibrary.simpleMessage("Enter password"),
        "passwordInvalidCharactersClientSideValidationError":
            MessageLookupByLibrary.simpleMessage(
                "Password contains invalid characters"),
        "passwordInvalidError": MessageLookupByLibrary.simpleMessage(
            "Make sure your password follows the rules below"),
        "passwordLowerCaseError": m52,
        "passwordNumberError": m53,
        "passwordRequiredLabel":
            MessageLookupByLibrary.simpleMessage("Password*"),
        "passwordSpecialCharactersError": m54,
        "passwordTooLongError": m55,
        "passwordTooShortError": m56,
        "passwordUpperCaseError": m57,
        "passwordValidationAllowSpaces":
            MessageLookupByLibrary.simpleMessage("Spaces are allowed"),
        "passwordValidationDoNotAllowSpaces":
            MessageLookupByLibrary.simpleMessage("Spaces are not allowed"),
        "passwordValidationMinCharacters": m58,
        "passwordValidationMinLowerCaseCharacters": m59,
        "passwordValidationMinNumericCharacters": m60,
        "passwordValidationMinSpecialCharacters": m61,
        "passwordValidationMinUpperCaseCharacters": m62,
        "passwordsDoNotMatchClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "paymentAmountInvalidError":
            MessageLookupByLibrary.simpleMessage("Amount is not valid"),
        "paymentAmountRequiredError":
            MessageLookupByLibrary.simpleMessage("Amount is required"),
        "paymentDoesNotExistError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we couldn\'t find this transfer request"),
        "paymentIsNotInACorrectStatusToBeUpdatedError":
            MessageLookupByLibrary.simpleMessage(
                "The request seems to be already completed or canceled."),
        "paymentRequestsIsForAnotherCustomerError":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, we couldn\'t find this transfer request"),
        "paymentSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Great! Your transfer has been submitted. We\'ll notify you as soon as it\'s approved"),
        "pendingReferralListEmptyState": MessageLookupByLibrary.simpleMessage(
            "You have no pending referrals at the moment"),
        "personalDetailsCountryOfNationality":
            MessageLookupByLibrary.simpleMessage("Country of nationality"),
        "personalDetailsDeleteAccountButton":
            MessageLookupByLibrary.simpleMessage("Delete your account"),
        "personalDetailsEmailTitle":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "personalDetailsFirstNameTitle":
            MessageLookupByLibrary.simpleMessage("First Name"),
        "personalDetailsGenericError": MessageLookupByLibrary.simpleMessage(
            "We are unable to get your personal details right now. Please try again."),
        "personalDetailsHeader":
            MessageLookupByLibrary.simpleMessage("Personal Details"),
        "personalDetailsLastNameTitle":
            MessageLookupByLibrary.simpleMessage("Last Name"),
        "personalDetailsPhoneNumberTitle":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "phoneAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "This phone number is already verified"),
        "phoneIsAlreadyVerifiedError": MessageLookupByLibrary.simpleMessage(
            "An account with this phone number is already verified"),
        "phoneNumberHeader":
            MessageLookupByLibrary.simpleMessage("Phone number"),
        "phoneNumberHint":
            MessageLookupByLibrary.simpleMessage("Enter phone number"),
        "phoneNumberLabel":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "phoneNumberRequiredLabel":
            MessageLookupByLibrary.simpleMessage("Phone Number*"),
        "phoneNumberVerificationCodeNotSentError":
            MessageLookupByLibrary.simpleMessage(
                "Verification code was not sent, please retry"),
        "phoneNumberVerificationCodeResent":
            MessageLookupByLibrary.simpleMessage(
                "Verification code was re-sent"),
        "phoneNumberVerificationDetails": m63,
        "phoneNumberVerificationExpiredCodeError":
            MessageLookupByLibrary.simpleMessage(
                "This code has expired, please request a new one"),
        "phoneNumberVerificationInvalidCodeError":
            MessageLookupByLibrary.simpleMessage(
                "Incorrect code, please check it and try again"),
        "phoneNumberVerificationPageTitle":
            MessageLookupByLibrary.simpleMessage("Enter code"),
        "phoneNumberVerificationRequestNewCode":
            MessageLookupByLibrary.simpleMessage(
                "Request a new verification code"),
        "phoneNumberVerificationResendCodeTimer": m64,
        "pinConfirmDescription":
            MessageLookupByLibrary.simpleMessage("Please confirm your PIN"),
        "pinConfirmHeading":
            MessageLookupByLibrary.simpleMessage("Confirm PIN"),
        "pinCreateDescription": m65,
        "pinCreateHeading":
            MessageLookupByLibrary.simpleMessage("Create a PIN"),
        "pinCreatedSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Great! your PIN has been created successfully"),
        "pinCreatedSuccessTitle":
            MessageLookupByLibrary.simpleMessage("PIN created"),
        "pinErrorDoesNotMatch":
            MessageLookupByLibrary.simpleMessage("PIN does not match"),
        "pinErrorIncorrectPassCode": MessageLookupByLibrary.simpleMessage(
            "Incorrect passcode, please retry"),
        "pinErrorRemainingAttempts": m66,
        "pinForgotButton": MessageLookupByLibrary.simpleMessage("Forgot?"),
        "pinForgotPageButton": MessageLookupByLibrary.simpleMessage("Proceed"),
        "pinForgotPageDescription": MessageLookupByLibrary.simpleMessage(
            "Please sign in with your email and password after which you can set a new PIN."),
        "pinForgotPageTitle":
            MessageLookupByLibrary.simpleMessage("Forgot your PIN?"),
        "pinHide": MessageLookupByLibrary.simpleMessage("Hide PIN"),
        "pinShow": MessageLookupByLibrary.simpleMessage("Show PIN"),
        "pinSignInDescription": MessageLookupByLibrary.simpleMessage(
            "Please enter your PIN to sign-in"),
        "pinSignInHeading":
            MessageLookupByLibrary.simpleMessage("Enter your PIN"),
        "pinVerificationDescription":
            MessageLookupByLibrary.simpleMessage("Please re-enter your PIN"),
        "previousReferralsCardAward":
            MessageLookupByLibrary.simpleMessage("award"),
        "previousReferralsCardContact": m67,
        "previousReferralsCardDontLose":
            MessageLookupByLibrary.simpleMessage("Don\'t lose your"),
        "previousReferralsCardRemaining":
            MessageLookupByLibrary.simpleMessage("Remaining to earn"),
        "previousReferralsCardTimeLeftToAccept":
            MessageLookupByLibrary.simpleMessage("Time left to accept"),
        "previousReferralsCardTypeAppReferral":
            MessageLookupByLibrary.simpleMessage("App referral"),
        "previousReferralsCardTypeHospitality":
            MessageLookupByLibrary.simpleMessage("Hospitality"),
        "previousReferralsCardTypeRealEstate":
            MessageLookupByLibrary.simpleMessage("Real estate"),
        "previousReferralsNameHolder": m68,
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "propertyPaymentAmountExceedsInstalment":
            MessageLookupByLibrary.simpleMessage(
                "Amount can\'t exceed the total of the installment"),
        "propertyPaymentAvailableBalanceLabel":
            MessageLookupByLibrary.simpleMessage("Available balance"),
        "propertyPaymentConversionHolder": m69,
        "propertyPaymentFull": MessageLookupByLibrary.simpleMessage("Full"),
        "propertyPaymentPageSubDetails": MessageLookupByLibrary.simpleMessage(
            "Your can pay your installment in full or partially"),
        "propertyPaymentPageTitle":
            MessageLookupByLibrary.simpleMessage("Pay your installment"),
        "propertyPaymentPartial":
            MessageLookupByLibrary.simpleMessage("Partial"),
        "propertyPaymentProperty":
            MessageLookupByLibrary.simpleMessage("Property"),
        "realEstateListChooseAProperty":
            MessageLookupByLibrary.simpleMessage("Choose a property"),
        "realEstateListNoPurchases": MessageLookupByLibrary.simpleMessage(
            "You have no ongoing purchases at the moment"),
        "receive": MessageLookupByLibrary.simpleMessage("Receive"),
        "receiveExternalWalletButton": MessageLookupByLibrary.simpleMessage(
            "Receive from external wallet"),
        "receiveExternalWalletButtonSubtitle": m70,
        "receiveTokenPageGenericErrorSubtitle":
            MessageLookupByLibrary.simpleMessage(
                "Oh no! We\'re unable to display the QR code. Please try again."),
        "receiveTokenPageGenericErrorTitle":
            MessageLookupByLibrary.simpleMessage("This doesn’t seem right"),
        "receiveTokenPageSubDetails": MessageLookupByLibrary.simpleMessage(
            "Share this code with the sender, you\'ll receive points quicker than you thought"),
        "receiveTokenPageTitle": m71,
        "redeem": MessageLookupByLibrary.simpleMessage("Redeem"),
        "redeemVoucherButton":
            MessageLookupByLibrary.simpleMessage("Redeem voucher"),
        "redeemVoucherInsufficientFunds": MessageLookupByLibrary.simpleMessage(
            "You can’t complete this action, you have insufficient funds"),
        "redemptionSuccessCopyTitle":
            MessageLookupByLibrary.simpleMessage("Your voucher code is"),
        "redemptionSuccessDetailsLink":
            MessageLookupByLibrary.simpleMessage("my account"),
        "redemptionSuccessDetailsText": MessageLookupByLibrary.simpleMessage(
            "If you want to view this code later, you can find it under "),
        "redemptionSuccessOpenVoucherAppButton":
            MessageLookupByLibrary.simpleMessage("Open Voucher App"),
        "redemptionSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Redemption successful"),
        "redemptionSuccessToastMessage":
            MessageLookupByLibrary.simpleMessage("Voucher copied to clipboard"),
        "referAHotelSectionTitle":
            MessageLookupByLibrary.simpleMessage("Refer a hotel"),
        "referralAcceptedInvalidCode":
            MessageLookupByLibrary.simpleMessage("Invalid Referral Code."),
        "referralAcceptedNotFoundError":
            MessageLookupByLibrary.simpleMessage("Referral not found"),
        "referralAcceptedSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Referral accepted"),
        "referralAcceptedTitle":
            MessageLookupByLibrary.simpleMessage("Referral"),
        "referralAlreadyConfirmedError": MessageLookupByLibrary.simpleMessage(
            "It appears this person has already been referred by another user. Why don\'t you try someone else?"),
        "referralAlreadyExistError": MessageLookupByLibrary.simpleMessage(
            "Error. This user has already been referred"),
        "referralLeadAlreadyConfirmedError": MessageLookupByLibrary.simpleMessage(
            "This person has already been referred to Real Estate. Your referral cannot be submitted."),
        "referralLeadAlreadyExistError": MessageLookupByLibrary.simpleMessage(
            "Looks like this lovely person is already in our system, try referring someone else!"),
        "referralListCompletedTab":
            MessageLookupByLibrary.simpleMessage("Completed"),
        "referralListExpiredTab":
            MessageLookupByLibrary.simpleMessage("Expired"),
        "referralListOngoingTab":
            MessageLookupByLibrary.simpleMessage("Ongoing"),
        "referralListPageDescription": MessageLookupByLibrary.simpleMessage(
            "Track all your referrals here"),
        "referralListPageTitle":
            MessageLookupByLibrary.simpleMessage("Referrals"),
        "referralListRequestGenericErrorSubtitle":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, we are unable to show your referrals, please try again."),
        "referralListRequestGenericErrorTitle":
            MessageLookupByLibrary.simpleMessage(
                "Hmm… seems like something is not right"),
        "referralNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we couldn\'t find the referral. Please try again"),
        "referralSuccessGoToRefsButton":
            MessageLookupByLibrary.simpleMessage("Go to referrals"),
        "referralSuccessPageSubDetails": MessageLookupByLibrary.simpleMessage(
            "You can track the progress in the referral section"),
        "referralSuccessPageTitle":
            MessageLookupByLibrary.simpleMessage("Referral submitted"),
        "referralTrackingPersonalDetailsOption":
            MessageLookupByLibrary.simpleMessage("Referral tracking"),
        "referralsLimitExceededError": MessageLookupByLibrary.simpleMessage(
            "Wow! You\'re a superstar, you\'ve reached the referral limit"),
        "registerPageAgreeTermsOfUse":
            MessageLookupByLibrary.simpleMessage("I agree with the "),
        "registerPageAgreeTermsOfUseError":
            MessageLookupByLibrary.simpleMessage(
                "Please accept the Terms of Use and Privacy Policy below"),
        "registerPageBackendInvalidEmailError":
            MessageLookupByLibrary.simpleMessage("Invalid email"),
        "registerPageBackendInvalidPasswordError":
            MessageLookupByLibrary.simpleMessage("Invalid password"),
        "registerPageHeader": MessageLookupByLibrary.simpleMessage("Register"),
        "registerPageLoginAlreadyInUseError":
            MessageLookupByLibrary.simpleMessage("Login already in use"),
        "registerPageRegisterSubmitButton":
            MessageLookupByLibrary.simpleMessage("Register"),
        "registerWithAnotherAccountButton":
            MessageLookupByLibrary.simpleMessage(
                "Register with another account"),
        "requests": MessageLookupByLibrary.simpleMessage("Requests"),
        "requiredCountryOfResidenceClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Please select a country"),
        "requiredPhotoIdBackSideClientSideValidationError":
            MessageLookupByLibrary.simpleMessage(
                "Photo on the back side is required"),
        "requiredPhotoIdClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Photo ID is required"),
        "requiredPhotoIdFrontSideClientSideValidationError":
            MessageLookupByLibrary.simpleMessage(
                "Photo on the front side is required"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
        "resetPasswordPrompt": MessageLookupByLibrary.simpleMessage(
            "Please create a new password and sign in again"),
        "resetPasswordSendLinkHint": MessageLookupByLibrary.simpleMessage(
            "We’ll send you a link to reset your password"),
        "resetPasswordSentEmailHint": MessageLookupByLibrary.simpleMessage(
            "Link has been sent, please check your email, if you didn’t receive it try to request it again or check your spam folder"),
        "resetPasswordTitle":
            MessageLookupByLibrary.simpleMessage("Enter email address"),
        "retryButton": MessageLookupByLibrary.simpleMessage("Retry"),
        "scannedInfoDialogEmailPositiveButton": m72,
        "scannedInfoDialogErrorMessage": MessageLookupByLibrary.simpleMessage(
            "This QR code type is currently unsupported"),
        "scannedInfoDialogNegativeButton":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "scannedInfoDialogPositiveButton":
            MessageLookupByLibrary.simpleMessage("Open in browser"),
        "scannedInfoDialogTitle":
            MessageLookupByLibrary.simpleMessage("Scanned Info"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "sendToExternalWalletButton":
            MessageLookupByLibrary.simpleMessage("Transfer to external wallet"),
        "sendToExternalWalletButtonSubtitle": m73,
        "sendTokensButton": m74,
        "senderCustomerNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we couldn\'t find this account. Transfer canceled"),
        "setPasswordSuccessBackToAccountButton":
            MessageLookupByLibrary.simpleMessage("Back to sign-in"),
        "setPasswordSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Your password has been reset please login with your new details"),
        "setPasswordSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Password reset successfully"),
        "setPhoneNumberPageTitle":
            MessageLookupByLibrary.simpleMessage("Add phone number"),
        "setPhoneNumberVerifyButton":
            MessageLookupByLibrary.simpleMessage("Verify"),
        "simpleWalletsDescription": MessageLookupByLibrary.simpleMessage(
            "Metamask, Coinbase, Trust wallet, ..."),
        "simpleWalletsTitle":
            MessageLookupByLibrary.simpleMessage("Simple wallets"),
        "socialOrContinueWith":
            MessageLookupByLibrary.simpleMessage("Or continue with"),
        "socialPageComingSoon":
            MessageLookupByLibrary.simpleMessage("Coming Soon"),
        "socialPageTitle": MessageLookupByLibrary.simpleMessage("Community"),
        "somethingIsNotRightError": MessageLookupByLibrary.simpleMessage(
            "Something is not right, give it another go!"),
        "spendPageTitle": MessageLookupByLibrary.simpleMessage("Redeem"),
        "spendRulePageEmpty": MessageLookupByLibrary.simpleMessage(
            "Sorry, it appears there are no redeem offers right now"),
        "stakingDetailsLockedAmount":
            MessageLookupByLibrary.simpleMessage("Locked amount"),
        "stakingDetailsPart1": MessageLookupByLibrary.simpleMessage(
            "In order to be eligible to participate in this offer you need to lock "),
        "stakingDetailsRealEstateBurningRulePart1": m75,
        "stakingDetailsRealEstateBurningRulePart2":
            MessageLookupByLibrary.simpleMessage(" of the staking amount."),
        "stakingDetailsRealEstatePart5": MessageLookupByLibrary.simpleMessage(
            "You’ll be awarded upon completion of the different milestones during the purchase process."),
        "stakingDetailsRealEstateStakingRulePart1":
            MessageLookupByLibrary.simpleMessage(
                "If your friend makes a purchase we will return "),
        "stakingDetailsRealEstateStakingRulePart2_100percent":
            MessageLookupByLibrary.simpleMessage(" of the staking amount."),
        "stakingDetailsReward": MessageLookupByLibrary.simpleMessage("Award"),
        "stepOf": m76,
        "submitButton": MessageLookupByLibrary.simpleMessage("Submit"),
        "targetCustomerNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we couldn\'t find this account. Transfer canceled"),
        "termsOfUse": MessageLookupByLibrary.simpleMessage("Terms of Use"),
        "to": m77,
        "tokensLocked": MessageLookupByLibrary.simpleMessage("are locked"),
        "tooManyLoginRequestError": MessageLookupByLibrary.simpleMessage(
            "You\'ve exceeded your login attempts. Please contact support."),
        "transactionAmountGreaterThanBalanceError":
            MessageLookupByLibrary.simpleMessage(
                "Your balance is too low for this transaction."),
        "transactionAmountInvalidError": MessageLookupByLibrary.simpleMessage(
            "Transaction amount is not valid"),
        "transactionAmountOfTokensHint": MessageLookupByLibrary.simpleMessage(
            "How many points are required?"),
        "transactionAmountRequiredError": MessageLookupByLibrary.simpleMessage(
            "Transaction amount is required"),
        "transactionAmountTokensLabel": m78,
        "transactionEmptyAddressError":
            MessageLookupByLibrary.simpleMessage("Wallet address is required"),
        "transactionFormOr": MessageLookupByLibrary.simpleMessage("or"),
        "transactionFormPageSubDetails": m79,
        "transactionFormPageTitle": m80,
        "transactionFormScanQRCode":
            MessageLookupByLibrary.simpleMessage("Scan QR Code"),
        "transactionFormStakedAmount": m81,
        "transactionInvalidAddressError": MessageLookupByLibrary.simpleMessage(
            "Are you sure that\'s your wallet address?"),
        "transactionReceiverEmailAddressHint":
            MessageLookupByLibrary.simpleMessage(
                "Enter receiver email address"),
        "transactionReceiverEmailAddressLabel":
            MessageLookupByLibrary.simpleMessage("Receiver email address"),
        "transactionSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Thanks for submitting your payment. We\'ll let you know once it\'s processed."),
        "transactionSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Transfer submitted"),
        "transfer": MessageLookupByLibrary.simpleMessage("Transfer"),
        "transferInProgress":
            MessageLookupByLibrary.simpleMessage("Transfer in progress"),
        "transferInProgressDetails": m82,
        "transferRequestAmountExceedsRequestedError": m83,
        "transferRequestAmountIsZeroError":
            MessageLookupByLibrary.simpleMessage(
                "Amount must be bigger than zero"),
        "transferRequestCompletedTab":
            MessageLookupByLibrary.simpleMessage("Completed"),
        "transferRequestEmptyCompleted": MessageLookupByLibrary.simpleMessage(
            "You have no completed requests at the moment"),
        "transferRequestEmptyOngoing": MessageLookupByLibrary.simpleMessage(
            "You have no ongoing requests at the moment"),
        "transferRequestEmptyUnsuccessful":
            MessageLookupByLibrary.simpleMessage(
                "You have no unsuccessful requests at the moment"),
        "transferRequestExpiredDetails": MessageLookupByLibrary.simpleMessage(
            "This transfer request has expired, please ask the reception desk to send a new request "),
        "transferRequestExpiredTitle":
            MessageLookupByLibrary.simpleMessage("Request expired"),
        "transferRequestGenericError": MessageLookupByLibrary.simpleMessage(
            "We were unable to complete the transfer, please try again"),
        "transferRequestIdHolder": m84,
        "transferRequestInfoHolder": m85,
        "transferRequestInvalidStateError": MessageLookupByLibrary.simpleMessage(
            "Something\'s wrong… The request seems to be already completed or canceled."),
        "transferRequestListGenericError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to show more transfer requests right now"),
        "transferRequestListPageTitle":
            MessageLookupByLibrary.simpleMessage("Transfer requests"),
        "transferRequestNotEnoughTokensError": MessageLookupByLibrary.simpleMessage(
            "Sorry, you do not have enough points to complete this transaction."),
        "transferRequestOngoingTab":
            MessageLookupByLibrary.simpleMessage("Ongoing"),
        "transferRequestRecipientLabel":
            MessageLookupByLibrary.simpleMessage("Recipient"),
        "transferRequestRejectButton":
            MessageLookupByLibrary.simpleMessage("Reject"),
        "transferRequestRejectDialogText": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to reject this transfer?"),
        "transferRequestRemainingTimeLabel":
            MessageLookupByLibrary.simpleMessage("Time remaining"),
        "transferRequestSendingAmountLabel": m86,
        "transferRequestStatusCardRecipientIdLabel": m87,
        "transferRequestStatusCardRecipientLabel":
            MessageLookupByLibrary.simpleMessage("Recipient"),
        "transferRequestStatusCardSendingAmountLabel":
            MessageLookupByLibrary.simpleMessage("Sending Amount"),
        "transferRequestStatusCardStatusCancelled":
            MessageLookupByLibrary.simpleMessage("Canceled"),
        "transferRequestStatusCardStatusCompleted":
            MessageLookupByLibrary.simpleMessage("Completed"),
        "transferRequestStatusCardStatusConfirmed":
            MessageLookupByLibrary.simpleMessage("Confirmed"),
        "transferRequestStatusCardStatusExpired":
            MessageLookupByLibrary.simpleMessage("Expired"),
        "transferRequestStatusCardStatusFailed":
            MessageLookupByLibrary.simpleMessage("Failed"),
        "transferRequestStatusCardStatusPending":
            MessageLookupByLibrary.simpleMessage("Pending"),
        "transferRequestStatusCardTotalBillLabel":
            MessageLookupByLibrary.simpleMessage("Total Bill"),
        "transferRequestSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Great! Your transfer has been submitted"),
        "transferRequestSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Transfer submitted"),
        "transferRequestTitle":
            MessageLookupByLibrary.simpleMessage("Transfer request"),
        "transferRequestTotalBillHolder": m88,
        "transferRequestTotalBillLabel":
            MessageLookupByLibrary.simpleMessage("Total Bill"),
        "transferRequestUnsuccessfulTab":
            MessageLookupByLibrary.simpleMessage("Unsuccessful"),
        "transferRequestWalletBalanceLabel":
            MessageLookupByLibrary.simpleMessage("Your wallet balance"),
        "transferSourceAndTargetMustBeDifferentError":
            MessageLookupByLibrary.simpleMessage(
                "The source and target wallets cannot be the same"),
        "transferSourceCustomerWalletBlockedError":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, your wallet is currently blocked and cannot accept this transaction"),
        "transferTargetCustomerWalletBlockedError":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, the target wallet is currently blocked and cannot accept this transaction"),
        "transferTokenAmountLabel": m89,
        "transferTokensButton":
            MessageLookupByLibrary.simpleMessage("Send points"),
        "unlinkExternalWalletButton":
            MessageLookupByLibrary.simpleMessage("Unlink external wallet"),
        "unlinkExternalWalletButtonSubtitle":
            MessageLookupByLibrary.simpleMessage(
                "Remove external wallet from your account"),
        "unlinkWalletInProgressHeader":
            MessageLookupByLibrary.simpleMessage("Unlinking in progress"),
        "unlinkWalletInProgressTitle": MessageLookupByLibrary.simpleMessage(
            "Your wallet is currently being unlinked"),
        "useBiometricButton":
            MessageLookupByLibrary.simpleMessage("or use biometric"),
        "useFaceIDButton":
            MessageLookupByLibrary.simpleMessage("or use Face ID"),
        "useFingerprintButton":
            MessageLookupByLibrary.simpleMessage("or use fingerprint"),
        "verificationCodeDoesNotExistError":
            MessageLookupByLibrary.simpleMessage(
                "Error. The verification code is invalid"),
        "verificationCodeExpiredError": MessageLookupByLibrary.simpleMessage(
            "Error. The verification code has expired"),
        "verificationCodeMismatchError": MessageLookupByLibrary.simpleMessage(
            "Error. The verification code is invalid"),
        "viewPartnerDetailsButtonTitle":
            MessageLookupByLibrary.simpleMessage("View partner details"),
        "voucherCopied":
            MessageLookupByLibrary.simpleMessage("Voucher copied to clipboard"),
        "voucherDetailsAmount": MessageLookupByLibrary.simpleMessage("Amount"),
        "voucherDetailsAvailableBalance":
            MessageLookupByLibrary.simpleMessage("Available balance"),
        "voucherListEmpty": MessageLookupByLibrary.simpleMessage(
            "There are no vouchers available at the moment"),
        "voucherSoldCountInfo": m90,
        "voucherStockCount": m91,
        "vouchersOption": MessageLookupByLibrary.simpleMessage("Vouchers"),
        "walletLinkingInProgress":
            MessageLookupByLibrary.simpleMessage("Wallet linking in progress"),
        "walletPageMyTotalTokens":
            MessageLookupByLibrary.simpleMessage("My total points"),
        "walletPagePaymentRequestsSubtitle": m92,
        "walletPageReceiveButtonSubtitle": m93,
        "walletPageReceiveButtonTitle": m94,
        "walletPageSendButtonSubtitle": m95,
        "walletPageTitle": MessageLookupByLibrary.simpleMessage("Wallet"),
        "walletPageTransactionHistoryEmpty":
            MessageLookupByLibrary.simpleMessage(
                "Once you have a few transactions you will see them here"),
        "walletPageTransactionHistoryInitialPageError":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, we are unable to load this section right now"),
        "walletPageTransactionHistoryPaginationError":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, we are unable to show more transactions right now"),
        "walletPageTransactionHistoryPaymentType":
            MessageLookupByLibrary.simpleMessage("Property Purchase"),
        "walletPageTransactionHistoryReceivedType": m96,
        "walletPageTransactionHistoryRefundType":
            MessageLookupByLibrary.simpleMessage("Refund"),
        "walletPageTransactionHistoryRewardType":
            MessageLookupByLibrary.simpleMessage("Award"),
        "walletPageTransactionHistorySentType": m97,
        "walletPageTransactionHistoryTitle":
            MessageLookupByLibrary.simpleMessage("History"),
        "walletPageTransactionHistoryTransferFeeType":
            MessageLookupByLibrary.simpleMessage("Transfer Fee"),
        "walletPageTransactionHistoryTransferFromExternalType":
            MessageLookupByLibrary.simpleMessage(
                "Transfer from external wallet"),
        "walletPageTransactionHistoryTransferToExternalType":
            MessageLookupByLibrary.simpleMessage("Transfer to external wallet"),
        "walletPageTransactionHistoryVoucherPurchaseType":
            MessageLookupByLibrary.simpleMessage("Voucher purchase"),
        "walletPageTransactionHistoryWalletLinkingType":
            MessageLookupByLibrary.simpleMessage("Wallet Linking Fee"),
        "walletPageTransferRequestsTitle":
            MessageLookupByLibrary.simpleMessage("Transfer requests"),
        "walletPageWalletDisabledError":
            MessageLookupByLibrary.simpleMessage("Wallet disabled"),
        "walletPageWalletDisabledErrorMessage":
            MessageLookupByLibrary.simpleMessage(
                "Sorry, your wallet has been disabled, please contact us to resolve the issue."),
        "warningDialogGoToSettings":
            MessageLookupByLibrary.simpleMessage("Go to settings"),
        "warningDialogLeavingPageDetails": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to go back? We don’t want you to lose your progress"),
        "warningDialogLeavingPageTitle":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "warningDialogNoButton": MessageLookupByLibrary.simpleMessage("No"),
        "warningDialogNoThanksButton":
            MessageLookupByLibrary.simpleMessage("No, thanks"),
        "warningDialogYesButton": MessageLookupByLibrary.simpleMessage("Yes"),
        "welcomeCreateAccountButtonText":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "welcomePageHeader": m98,
        "welcomePageSubHeader": m99,
        "welcomeSignInButtonText":
            MessageLookupByLibrary.simpleMessage("Sign in"),
        "yourOffers": MessageLookupByLibrary.simpleMessage("Your offers")
      };
}
