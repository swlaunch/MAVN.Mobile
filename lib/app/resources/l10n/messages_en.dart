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

  static m6(vendorName) => "Available at ${vendorName}";

  static m7(token) => "Back to ${token} Wallet";

  static m8(currencyCode, amount) => "${amount} ${currencyCode}";

  static m9(amountInToken, token, amountInCurrency, currency) =>
      "${amountInToken} ${token} = ${amountInCurrency} ${currency}";

  static m97(purchaseDate) => "Date of purchase: ${purchaseDate}";

  static m10(days) =>
      "${Intl.plural(days, one: '${days} day ago', other: '${days} days ago')}";

  static m11(token) =>
      "Congratulations! You have completed this task! Have a look at other offers to continue earning ${token}s";

  static m12(participationCount) =>
      "${Intl.plural(participationCount, one: 'one time', other: '${participationCount} times')}";

  static m13(number, total) => "${number} / ${total} completed";

  static m14(number) => "You can participate in this offer ${number} times";

  static m15(token) => "Earn ${token} points every time you complete the offer";

  static m16(number) => "${number} completed";

  static m17(fromDate, toDate) => "Valid : from ${fromDate} to ${toDate}";

  static m18(email) =>
      "This link has expired, we’ve sent a new one to ${email}, please check your email and use the new link";

  static m98(expirationDate) => "Expiration Date: ${expirationDate}";

  static m19(days) =>
      "${Intl.plural(days, one: '${days} day', other: '${days} days')}";

  static m20(token) =>
      "Before sending and receiving ${token}s, you need to link an Ethereum wallet, here is how to link it";

  static m21(fee) => "Fee: ${fee}";

  static m22(sender) => "From ${sender}";

  static m23(serviceNumber) =>
      "Oops! It looks like something went wrong. Please try again. If the issue continues, contact our friendly customer service on ${serviceNumber}";

  static m24(count) => "View all (${count})";

  static m25(token, company) =>
      "Thanks for accepting the referral, the next time you stay at ${company} hotel you will be awarded with ${token} points";

  static m26(partnerName) =>
      "Please enter the details for the person you would like to refer to ${partnerName} properties. ";

  static m27(refereeFullName) =>
      "Great! You\'ve successfully referred ${refereeFullName}";

  static m28(partnerName) => " to ${partnerName}";

  static m29(hours) =>
      "${Intl.plural(hours, one: '${hours} hour', other: '${hours} hours')}";

  static m30(hours) =>
      "${Intl.plural(hours, one: '${hours} hour ago', other: '${hours} hours ago')}";

  static m31(token) =>
      "Transfer balance from your linked external wallet to your ${token} wallet";

  static m32(token) => "Receive ${token} points from external wallet";

  static m33(token) =>
      "Transfer from your ${token} wallet to your linked external wallet";

  static m34(token) => "Transfer ${token} points to external wallet";

  static m35(attemptNumber) =>
      "${Intl.plural(attemptNumber, one: 'You have ${attemptNumber} more attempt to sign in, after that your account will be temporarily locked.', other: 'You have ${attemptNumber} more attempts to sign in, after that your account will be temporarily locked.')}";

  static m36(numberOfMinutes) =>
      "${Intl.plural(numberOfMinutes, one: 'Your account has been locked. Please try again in ${numberOfMinutes} minute.', other: 'Your account has been locked. Please try again in ${numberOfMinutes} minutes.')}";

  static m37(period) =>
      "We are undergoing some routine maintenance and will be up and running in the next ${period}";

  static m38(maxLength) =>
      "Phone number can only be a maximum of ${maxLength} digits long";

  static m39(precision) =>
      "Amount should not exceed ${precision} decimal places";

  static m40(minLength) =>
      "${Intl.plural(minLength, one: 'Minimum length should be at least one character', other: 'Minimum length should be at least ${minLength} characters')}";

  static m41(minLength) =>
      "Phone number should be at least ${minLength} digits long";

  static m42(minutes) =>
      "${Intl.plural(minutes, one: '${minutes} minute ago', other: '${minutes} minutes ago')}";

  static m43(firstPartnerName, numberOfPartner) =>
      "${Intl.plural(numberOfPartner, one: '${firstPartnerName} & ${numberOfPartner} other', other: '${firstPartnerName} & ${numberOfPartner} others')}";

  static m44(token) => "Start earning ${token} now!";

  static m45(token) =>
      "Sorry, you do not have sufficient ${token} points for this activity";

  static m46(expirationDate) => "This offer expires on: ${expirationDate}";

  static m47(appName) => "Welcome to ${appName}";

  static m48(token, company) =>
      "Earn ${token} points by referring friends to ${company} and much more";

  static m49(token) => "Start earning ${token} points";

  static m50(token, company) =>
      "Use your ${token} points on ${company} for invoices, hotel stays, restaurants and much more";

  static m51(token) => "Use ${token} points easily";

  static m99(count) => "Partner code must be ${count} characters long";

  static m100(count) => "Linking code must be ${count} characters long";

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

  static m63(appName) =>
      "Create a PIN to quickly sign in to your ${appName} account next time";

  static m64(count) =>
      "You have ${count} attempts remaining after which you will need to sign-in with your email and password";

  static m65(person) => "Contact ${person}";

  static m66(firstName, lastName) => "${firstName} ${lastName}";

  static m67(token) => "From external wallet to ${token} wallet";

  static m68(token) => "Receive ${token} points";

  static m69(token) => "Transfer ${token}";

  static m70(token) => "From ${token} wallet to external wallet";

  static m71(token) => "Transfer ${token}";

  static m72(time) =>
      "If your friend doesn\'t accept the invite within ${time} you will lose ";

  static m73(step, totalSteps) => "${step} of ${totalSteps}";

  static m74(recipient) => "To ${recipient}";

  static m75(token) => "Amount (${token} points)";

  static m76(token) =>
      "Transfer ${token} points easily, scan the receivers QR code or enter their email address";

  static m77(token) => "Transfer ${token} points";

  static m78(lockedAmount) => "${lockedAmount} are locked";

  static m79(token) =>
      "Your ${token}s have been transferred. We’ll notify you when the operation is completed.";

  static m80(requestedAmount) => "You cannot pay more than ${requestedAmount}";

  static m81(id) => "ID : ${id}";

  static m82(transferRequestOrganization) =>
      "You received a transfer request from ${transferRequestOrganization}. Please review and confirm it.";

  static m83(token) => "Sending Amount (${token})";

  static m84(recipientId) => "ID: ${recipientId}";

  static m85(amountTokens, token, amountCurrency, currencyCode) =>
      "${amountTokens} ${token} (${amountCurrency} ${currencyCode})";

  static m86(token) => "Transfer amount (${token})";

  static m87(soldCount) => "${soldCount} used this offer";

  static m88(stockCount) =>
      "${Intl.plural(stockCount, zero: 'Out of stock', other: '${stockCount} left')}";

  static m89(count) =>
      "${Intl.plural(count, zero: 'You have no pending transfers', one: 'You have ${count} pending transfer', other: 'You have ${count} pending transfers')}";

  static m90(token) => "Receive points from other ${token} users";

  static m91(token) => "Receive ${token} points";

  static m92(token) => "Send ${token} points to anyone";

  static m93(token) => "Received ${token} points";

  static m94(token) => "Sent ${token} points";

  static m95(appName) => "Welcome to ${appName}";

  static m96(token) => "Earn and use ${token}s across the world";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
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
        "availableAt": m6,
        "backToTokenWalletButton": m7,
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
        "cancelVoucher": MessageLookupByLibrary.simpleMessage("Cancel Voucher"),
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
        "conversionRate": m8,
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
        "currencyConversionLabel": m9,
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
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "dateOfPurchase": m97,
        "dateTimeToday": MessageLookupByLibrary.simpleMessage("Today"),
        "dateTimeYesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
        "daysAgo": m10,
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
        "earnRuleCompletionMessage": m11,
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
        "earnRuleDetailsParticipationCount": m12,
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
        "earnRuleLimitedCompletionInfo": m13,
        "earnRuleLimitedParticipationInfo": m14,
        "earnRuleOnlyOnceParticipationInfo":
            MessageLookupByLibrary.simpleMessage(
                "You can participate in this only once"),
        "earnRulePageEmpty": MessageLookupByLibrary.simpleMessage(
            "Sorry, it appears there are no earn offers right now"),
        "earnRulePageInitialPageError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to load earn offers right now"),
        "earnRulePagePaginationError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we are unable to show more earn offers right now"),
        "earnRuleRewardBoxSubTitle": m15,
        "earnRuleRewardBoxTitle":
            MessageLookupByLibrary.simpleMessage("Offer Award"),
        "earnRuleUnlimitedCompletionInfo": m16,
        "earnRuleUnlimitedParticipationInfo":
            MessageLookupByLibrary.simpleMessage(
                "You can participate in this offer unlimited times"),
        "earnRuleValidDate": m17,
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
        "emailVerificationLinkExpired": m18,
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
        "emptyPhoneNumberClientSideValidationError":
            MessageLookupByLibrary.simpleMessage("Phone number is required"),
        "enterAmountHint": MessageLookupByLibrary.simpleMessage("Enter amount"),
        "expirationDate": m98,
        "expirationFormatDays": m19,
        "expired": MessageLookupByLibrary.simpleMessage("Expired"),
        "expiredReferralListEmptyState": MessageLookupByLibrary.simpleMessage(
            "You have no expired referrals at the moment"),
        "externalLinkWalletDescription": m20,
        "externalWalletHint":
            MessageLookupByLibrary.simpleMessage("Link to your account"),
        "externalWalletTitle":
            MessageLookupByLibrary.simpleMessage("Your external wallet"),
        "feeLabel": m21,
        "firstNameHint":
            MessageLookupByLibrary.simpleMessage("Enter first name"),
        "firstNameNotRequiredLabel":
            MessageLookupByLibrary.simpleMessage("First name"),
        "firstNameRequiredLabel":
            MessageLookupByLibrary.simpleMessage("First name*"),
        "friendReferralSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Great! Your referral has been submitted, we will notify you when the points are added to your wallet."),
        "from": m22,
        "genericError": m23,
        "genericErrorShort":
            MessageLookupByLibrary.simpleMessage("Please try again."),
        "getStartedButton": MessageLookupByLibrary.simpleMessage("Get started"),
        "goToWallet": MessageLookupByLibrary.simpleMessage("Go to Wallet"),
        "homePageCountdownSubtitle": MessageLookupByLibrary.simpleMessage(
            "are waiting for you, hurry up"),
        "homePageCountdownTitle":
            MessageLookupByLibrary.simpleMessage("Countdown!"),
        "homePageCountdownViewAll": m24,
        "hotelPreCheckoutDialogHeading":
            MessageLookupByLibrary.simpleMessage("Thanks for staying with us"),
        "hotelPreCheckoutDialogViewInvoiceButton":
            MessageLookupByLibrary.simpleMessage("View Invoice"),
        "hotelReferralAcceptedSuccessBody": m25,
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
        "hotelReferralPartnerInfo": m26,
        "hotelReferralStakingInfo":
            MessageLookupByLibrary.simpleMessage("You are required to lock "),
        "hotelReferralSuccessPageDetails": m27,
        "hotelReferralSuccessPageDetailsPartnerName": m28,
        "hours": m29,
        "hoursAgo": m30,
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
        "leadReferralPageTitle":
            MessageLookupByLibrary.simpleMessage("Refer a friend"),
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
        "linkBusinessAccount":
            MessageLookupByLibrary.simpleMessage("Link business account"),
        "linkBusinessAccountDescription": MessageLookupByLibrary.simpleMessage(
            "Enter the details of the account you\'d like to link"),
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
        "linkWalletReceiveHint": m31,
        "linkWalletReceiveNote": MessageLookupByLibrary.simpleMessage(
            "Note: Funds will be lost if you use a wallet other than your linked external wallet"),
        "linkWalletReceiveTitle": m32,
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
        "linkedWalletSendHint": m33,
        "linkedWalletSendTitle": m34,
        "linkingCode": MessageLookupByLibrary.simpleMessage("Linking Code"),
        "linkingCodeHint": MessageLookupByLibrary.simpleMessage(
            "Please enter your Linking Code"),
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
        "locationDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Location Services are not enabled on your device. Please enable them and try again."),
        "locationDialogTitle": MessageLookupByLibrary.simpleMessage(
            "Please turn on Location Services"),
        "loginAlreadyInUseError": MessageLookupByLibrary.simpleMessage(
            "An account with this email already exists"),
        "loginPageEmailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "loginPageForgottenPasswordButton":
            MessageLookupByLibrary.simpleMessage("Forgot password"),
        "loginPageHeader": MessageLookupByLibrary.simpleMessage("Sign-in"),
        "loginPageInvalidCredentialsError":
            MessageLookupByLibrary.simpleMessage(
                "Your login details are incorrect. Please try again."),
        "loginPageLoginAttemptWarningMessage": m35,
        "loginPageLoginSubmitButton":
            MessageLookupByLibrary.simpleMessage("Sign in"),
        "loginPagePasswordHint":
            MessageLookupByLibrary.simpleMessage("Enter password"),
        "loginPagePasswordLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "loginPageTooManyRequestMessage": m36,
        "loginPageUnauthorizedRedirectionMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your session has expired, please log in again"),
        "maintenanceDescription": m37,
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
        "maxPhoneNumberLengthClientSideValidationError": m38,
        "maximumDecimalPlacesError": m39,
        "minLengthClientSideValidationError": m40,
        "minPhoneNumberLengthClientSideValidationError": m41,
        "minutesAgo": m42,
        "monthlyChallenges":
            MessageLookupByLibrary.simpleMessage("Monthly challenges"),
        "monthlyChallengesSubtitle": MessageLookupByLibrary.simpleMessage(
            "Test yourself and earn points"),
        "multiplePartnersTitle": m43,
        "nationalityHint":
            MessageLookupByLibrary.simpleMessage("Enter nationality"),
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
        "noTokensConversionRateText": m44,
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
        "notEnoughTokensError": m45,
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
        "offerExpiresOn": m46,
        "offerNoExpirationDate": MessageLookupByLibrary.simpleMessage(
            "This offer has no expiration date"),
        "offers": MessageLookupByLibrary.simpleMessage("Offers"),
        "onboardingPage1Title": m47,
        "onboardingPage2Details": m48,
        "onboardingPage2Title": m49,
        "onboardingPage3Details": m50,
        "onboardingPage3Title": m51,
        "onboardingSkipButton": MessageLookupByLibrary.simpleMessage("Skip"),
        "outOfStockDescription": MessageLookupByLibrary.simpleMessage(
            "The vouchers in this offer are currently sold out."),
        "partnerCode": MessageLookupByLibrary.simpleMessage("Partner Code"),
        "partnerCodeHint": MessageLookupByLibrary.simpleMessage(
            "Please enter your Partner Code"),
        "partnerCodeInvalid": m99,
        "partnerCodeRequired":
            MessageLookupByLibrary.simpleMessage("Partner code is required"),
        "partnerDetailsPageTitle":
            MessageLookupByLibrary.simpleMessage("Partner Details"),
        "partnerLinkingCodeInvalid": MessageLookupByLibrary.simpleMessage(
            "Linking code must contain only alphanumeric characters"),
        "partnerLinkingCodeInvalidLength": m100,
        "partnerLinkingCodeRequired":
            MessageLookupByLibrary.simpleMessage("Partner code is required"),
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
        "pending": MessageLookupByLibrary.simpleMessage("Pending"),
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
        "phoneNumberHeader":
            MessageLookupByLibrary.simpleMessage("Phone number"),
        "phoneNumberHint":
            MessageLookupByLibrary.simpleMessage("Enter phone number"),
        "phoneNumberLabel":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "phoneNumberRequiredLabel":
            MessageLookupByLibrary.simpleMessage("Phone Number*"),
        "pinConfirmDescription":
            MessageLookupByLibrary.simpleMessage("Please confirm your PIN"),
        "pinConfirmHeading":
            MessageLookupByLibrary.simpleMessage("Confirm PIN"),
        "pinCreateDescription": m63,
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
        "pinErrorRemainingAttempts": m64,
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
        "previousReferralsCardContact": m65,
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
        "previousReferralsNameHolder": m66,
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "propertyPaymentAvailableBalanceLabel":
            MessageLookupByLibrary.simpleMessage("Available balance"),
        "receive": MessageLookupByLibrary.simpleMessage("Receive"),
        "receiveExternalWalletButton": MessageLookupByLibrary.simpleMessage(
            "Receive from external wallet"),
        "receiveExternalWalletButtonSubtitle": m67,
        "receiveTokenPageGenericErrorSubtitle":
            MessageLookupByLibrary.simpleMessage(
                "Oh no! We\'re unable to display the QR code. Please try again."),
        "receiveTokenPageGenericErrorTitle":
            MessageLookupByLibrary.simpleMessage("This doesn’t seem right"),
        "receiveTokenPageSubDetails": MessageLookupByLibrary.simpleMessage(
            "Share this code with the sender, you\'ll receive points quicker than you thought"),
        "receiveTokenPageTitle": m68,
        "redeem": MessageLookupByLibrary.simpleMessage("Redeem"),
        "redeemOffer": MessageLookupByLibrary.simpleMessage("Purchase voucher"),
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
        "scannedInfoDialogEmailPositiveButton": m69,
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
        "sendToExternalWalletButtonSubtitle": m70,
        "sendToFriend":
            MessageLookupByLibrary.simpleMessage("Send to a friend"),
        "sendTokensButton": m71,
        "senderCustomerNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we couldn\'t find this account. Transfer canceled"),
        "setPasswordSuccessBackToAccountButton":
            MessageLookupByLibrary.simpleMessage("Back to sign-in"),
        "setPasswordSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "Your password has been reset please login with your new details"),
        "setPasswordSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Password reset successfully"),
        "simpleWalletsDescription": MessageLookupByLibrary.simpleMessage(
            "Metamask, Coinbase, Trust wallet, ..."),
        "simpleWalletsTitle":
            MessageLookupByLibrary.simpleMessage("Simple wallets"),
        "smeLinkingAlreadyLinkedError": MessageLookupByLibrary.simpleMessage(
            "Your account is already linked to business."),
        "smeLinkingCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Please check credentials and try again"),
        "smeLinkingSuccessDetails": MessageLookupByLibrary.simpleMessage(
            "You have successfully linked your accounts. You can now scan vouchers."),
        "smeLinkingSuccessPageTitle":
            MessageLookupByLibrary.simpleMessage("Accounts Linked"),
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
        "stakingDetailsRealEstateBurningRulePart1": m72,
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
        "stepOf": m73,
        "submitButton": MessageLookupByLibrary.simpleMessage("Submit"),
        "targetCustomerNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Sorry, we couldn\'t find this account. Transfer canceled"),
        "termsOfUse": MessageLookupByLibrary.simpleMessage("Terms of Use"),
        "to": m74,
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
        "transactionAmountTokensLabel": m75,
        "transactionEmptyAddressError":
            MessageLookupByLibrary.simpleMessage("Wallet address is required"),
        "transactionFormOr": MessageLookupByLibrary.simpleMessage("or"),
        "transactionFormPageSubDetails": m76,
        "transactionFormPageTitle": m77,
        "transactionFormScanQRCode":
            MessageLookupByLibrary.simpleMessage("Scan QR Code"),
        "transactionFormStakedAmount": m78,
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
        "transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
        "transfer": MessageLookupByLibrary.simpleMessage("Transfer"),
        "transferInProgress":
            MessageLookupByLibrary.simpleMessage("Transfer in progress"),
        "transferInProgressDetails": m79,
        "transferRequestAmountExceedsRequestedError": m80,
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
        "transferRequestIdHolder": m81,
        "transferRequestInfoHolder": m82,
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
        "transferRequestSendingAmountLabel": m83,
        "transferRequestStatusCardRecipientIdLabel": m84,
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
        "transferRequestTotalBillHolder": m85,
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
        "transferTokenAmountLabel": m86,
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
        "viewOffer": MessageLookupByLibrary.simpleMessage("View Offer"),
        "viewPartner": MessageLookupByLibrary.simpleMessage("View the shop"),
        "viewPartnerDetailsButtonTitle":
            MessageLookupByLibrary.simpleMessage("View partner details"),
        "viewVoucher": MessageLookupByLibrary.simpleMessage("View Voucher"),
        "voucherCopied":
            MessageLookupByLibrary.simpleMessage("Voucher copied to clipboard"),
        "voucherDetailsAmount": MessageLookupByLibrary.simpleMessage("Amount"),
        "voucherDetailsAvailableBalance":
            MessageLookupByLibrary.simpleMessage("Available balance"),
        "voucherListEmpty": MessageLookupByLibrary.simpleMessage(
            "There are no vouchers available at the moment"),
        "voucherSoldCountInfo": m87,
        "voucherStockCount": m88,
        "vouchers": MessageLookupByLibrary.simpleMessage("Vouchers"),
        "vouchersOption": MessageLookupByLibrary.simpleMessage("Vouchers"),
        "walletLinkingInProgress":
            MessageLookupByLibrary.simpleMessage("Wallet linking in progress"),
        "walletPageMyTotalTokens":
            MessageLookupByLibrary.simpleMessage("My total points"),
        "walletPagePaymentRequestsSubtitle": m89,
        "walletPageReceiveButtonSubtitle": m90,
        "walletPageReceiveButtonTitle": m91,
        "walletPageSendButtonSubtitle": m92,
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
        "walletPageTransactionHistoryReceivedType": m93,
        "walletPageTransactionHistoryRefundType":
            MessageLookupByLibrary.simpleMessage("Refund"),
        "walletPageTransactionHistoryRewardType":
            MessageLookupByLibrary.simpleMessage("Award"),
        "walletPageTransactionHistorySentType": m94,
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
        "welcomePageHeader": m95,
        "welcomePageSubHeader": m96,
        "welcomeSignInButtonText":
            MessageLookupByLibrary.simpleMessage("Sign in"),
        "yourOffers": MessageLookupByLibrary.simpleMessage("Your offers")
      };
}
