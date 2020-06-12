/// Keys should be snake case (e.g. words separated by an underscore
/// to conform to Firebase analytics naming conventions e.g. example_page
class RouterPageName {
  //region Splash, Onboarding & Welcome
  static const String splashPage = 'splash_page';
  static const String welcomePage = 'welcome_page';
  static const String onboardingPage = 'onboarding_page';

  //endregion Splash, Onboarding & Welcome

  //region Authentication
  //region Login
  static const String loginPage = 'login_page';

  //endregion Login

  //region PIN
  static const String pinCreatePage = 'pin_create_page';
  static const String pinConfirmPage = 'pin_confirm_page';
  static const String pinSignInPage = 'pin_sign_in_page';
  static const String pinVerificationPage = 'pin_verification_page';
  static const String pinCreatedSuccessPage = 'pin_created_success_page';
  static const String pinForgotPage = 'pin_forgot_page';
  static const String biometricAgreementPage = 'biometric_agreement_page';

  //endregion PIN

  //region Registration
  static const String registerPage = 'register_page';
  static const String emailVerificationPage = 'email_verification_page';
  static const String emailConfirmationPage = 'email_confirmation_page';
  static const String emailVerificationSuccessPage =
      'email_verification_success_page';
  static const String setPhoneNumberPage = 'set_phone_number_page';
  static const String phoneNumberVerificationPage =
      'phone_number_verification_page';

  //endregion Registration
  //region Password
  static const String changePasswordPage = 'change_password_page';
  static const String resetPasswordPage = 'reset_password_page';
  static const String setPasswordSuccessPage = 'set_password_success_page';
  static const String changePasswordSuccessPage =
      'change_password_success_page';

  //endregion Password

  static const String accountDeactivatedPage = 'account_deactivated_page';

  //endregion Authentication

  //region Utilities
  static const String maintenancePage = 'maintenance_page';
  static const String countryCodeListPage = 'country_code_list_page';
  static const String countryListPage = 'country_list_page';

  //endregion Utilities

  //region Home
  static const String homePage = 'home_page';
  static const String landingPage = 'landing_page';
  static const String walletPage = 'wallet_page';
  static const String accountPage = 'account_page';

  //endregion Home

  //region Referrals
  static const String leadReferralPage = 'lead_referral_page';
  static const String leadReferralSuccessPage = 'lead_referral_success_page';
  static const String leadReferralAcceptedPage = 'lead_referral_accepted_page';
  static const String hotelReferralPage = 'hotel_referral_page';
  static const String hotelReferralSuccessPage = 'hotel_referral_success_page';
  static const String hotelReferralAcceptedPage =
      'hotel_referral_accepted_page';
  static const String friendReferralPage = 'friend_referral_page';
  static const String friendReferralSuccessPage =
      'friend_referral_success_page';
  static const String referralListPage = 'referral_list_page';

  //endregion Referrals

  //region Transactions & Payments
  static const String transactionFormPage = 'transaction_form_page';
  static const String p2pTransactionSuccessPage =
      'p2p_transaction_success_page';
  static const String propertyPaymentPage = 'property_payment_page';
  static const String propertyPaymentSuccessPage =
      'property_payment_success_page';

  static const String p2pReceiveTokenPage = 'p2p_receive_token_page';
  static const String receiveOptionsPage = 'receive_options_page';
  static const String sendOptionsPage = 'send_options_page';
  static const String linkedWalletSendPage = 'linked_wallet_send_page';
  static const String linkedWalletSendProgressPage =
      'linked_wallet_send_progress_page';
  static const String linkedWalletSendFailedPage =
      'linked_wallet_send_failed_page';
  static const String linkWalletPage = 'link_wallet_page';
  static const String linkedWalletPage = 'linked_wallet_page';
  static const String linkWalletInProgressPage = 'link_wallet_in_progress_page';
  static const String linkAdvancedWalletPage = 'link_advanced_wallet_page';
  static const String linkSimpleWalletPage = 'link_simple_wallet_page';
  static const String unlinkWalletInProgressPage =
      'unlink_wallet_in_progress_page';
  static const String linkWalletReceivePage = 'link_wallet_receive_page';
  static const String paymentRequestPage = 'payment_request_page';
  static const String paymentRequestApprovalSuccessPage =
      'payment_request_approval_success_page';
  static const String paymentRequestExpiredPage =
      'payment_request_expired_page';
  static const String paymentRequestListPage = 'payment_request_list_page';

  //endregion Transactions & Payments

  //region Spend & Earn Rules
  static const String offersPage = 'offers_page';
  static const String spendRuleListPage = 'spend_rule_list_page';
  static const String earnRuleListPage = 'earn_rule_list_page';
  static const String earnRuleDetailsPage = 'earn_rule_detail_page';
  static const String stakingDetailsPage = 'staking_details_page';
  static const String offerDetailsPage = 'offer_details_page';
  static const String partnerListPage = 'partner_list_page';
  static const String propertyListPage = 'property_list_page';
  static const String instalmentListPage = 'instalment_list_page';
  static const String redemptionSuccessfulPage = 'redemption_success_page';

  //endregion Spend & Earn Rules

  //region Account Static Pages
  static const String contactUsPage = 'contact_us_page';
  static const String termsOfUsePage = 'terms_of_use_page';
  static const String privacyPolicyPage = 'privacy_policy_page';
  static const String personalDetailsPage = 'personal_details_page';

//endregion Account Static Pages

  //region Campaigns
  static const String campaignListPage = 'campaign_list_page';
  static const String campaignMapPage = 'campaign_map_page';
  static const String campaignDetailsPage = 'campaign_details_page';

  //endregion Campaigns

  //region Voucher
  static const String voucherDetailsPage = 'voucher_details_page';
  static const String voucherTransferPage = 'voucher_transfer_page';
  static const String voucherTransferSuccessPage =
      'voucher_transfer_success_page';

  //endregion Voucher

  //region misc
  static const String mandatoryAppUpgradePage = 'mandatory_app_upgrade_page';

  //endregion misc

  //region Notifications
  static const String notificationListPage = 'notification_list_page';

//endregion Notifications

//region Social

  static const String socialPage = 'social_page';

//endregion Social

// region SME linking
  static const String smeLinkingPage = 'sme_linking_page';
  static const String smeLinkingSuccessPage = 'sme_linking_success_page';
  static const String smeInvalidateVoucherPage = 'sme_invalidate_voucher_page';
  static const String smeInvalidateSuccessPage = 'sme_invalidate_success_page';

// endregion SME linking

//region Misc

  static const String comingSoonPage = 'coming_soon_page';

//endregion Misc
}
