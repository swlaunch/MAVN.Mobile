import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/campaign_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/partner_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/maintenance/response_model/maintenance_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/feature_account/view/account_page.dart';
import 'package:lykke_mobile_mavn/feature_account/view/contact_us_page.dart';
import 'package:lykke_mobile_mavn/feature_account_deactivated/view/account_deactivated_page.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/di/friend_referral_module.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/view/friend_referral_page.dart';
import 'package:lykke_mobile_mavn/feature_app_referral/view/friend_referral_success_page.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/di/barcode_scan_module.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/view/biometric_agreement_page.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/view/bottom_bar_page.dart';
import 'package:lykke_mobile_mavn/feature_campaign_details/view/campaign_details_page.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/di/campaign_list_module.dart';
import 'package:lykke_mobile_mavn/feature_campaign_list/view/campaign_list_page.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/di/campaign_map_module.dart';
import 'package:lykke_mobile_mavn/feature_campaigns_map/view/campaign_map_page.dart';
import 'package:lykke_mobile_mavn/feature_change_password/di/change_password_module.dart';
import 'package:lykke_mobile_mavn/feature_change_password/view/change_password_page.dart';
import 'package:lykke_mobile_mavn/feature_change_password/view/change_password_success_page.dart';
import 'package:lykke_mobile_mavn/feature_coming_soon/view/coming_soon_page.dart';
import 'package:lykke_mobile_mavn/feature_country/view/country_list_page.dart';
import 'package:lykke_mobile_mavn/feature_country_code/view/country_code_list_page.dart';
import 'package:lykke_mobile_mavn/feature_earn/di/earn_module.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/di/earn_rule_detail_module.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/view/earn_rule_detail_page.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/view/staking_details_page.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/di/email_verification_module.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/view/email_confirmation_page.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/view/email_verification_page.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/view/email_verification_success_page.dart';
import 'package:lykke_mobile_mavn/feature_home/di/staking_referrals_module.dart';
import 'package:lykke_mobile_mavn/feature_home/view/home_page.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/di/hotel_pre_checkout_di.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/view/hotel_pre_checkout_dialog.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/di/hotel_referral_module.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/view/hotel_referral_accepted_page.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/view/hotel_referral_page.dart';
import 'package:lykke_mobile_mavn/feature_hotel_referral/view/hotel_referral_success_page.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/di/hotel_welcome_di.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/view/hotel_welcome_dialog.dart';
import 'package:lykke_mobile_mavn/feature_landing/di/landing_di.dart';
import 'package:lykke_mobile_mavn/feature_landing/view/landing_page.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/di/sme_linking_module.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/view/sme_linking_page.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/view/sme_linking_success_page.dart';
import 'package:lykke_mobile_mavn/feature_login/di/login_module.dart';
import 'package:lykke_mobile_mavn/feature_login/view/login_page.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/di/maintenance_module.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/view/maintenance_page.dart';
import 'package:lykke_mobile_mavn/feature_notification/di/notification_module.dart';
import 'package:lykke_mobile_mavn/feature_notification/view/notification_list_page.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/di/onboarding_module.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/view/onboarding_page.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/di/transaction_form_module.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_form_page.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_success_page.dart';
import 'package:lykke_mobile_mavn/feature_partners/di/partner_name_di.dart';
import 'package:lykke_mobile_mavn/feature_partners/view/partner_list_page.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/di/password_validation_module.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/di/payment_request_module.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_approval_success_page.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_expired_page.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/view/payment_request_page.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/di/partner_payments_module.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/payment_request_list_page.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/di/personal_details_module.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/view/personal_details_page.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_confirm_page.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_create_page.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_created_success_page.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_forgot_page.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_sign_in_page.dart';
import 'package:lykke_mobile_mavn/feature_pin/view/pin_verification_page.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/di/p2p_receive_token_module.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/view/p2p_receive_token_page.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/di/referral_list_module.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/view/referral_list_page.dart';
import 'package:lykke_mobile_mavn/feature_register/di/register_module.dart';
import 'package:lykke_mobile_mavn/feature_register/view/register_page.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/di/reset_password_module.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/view/reset_password_page.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/view/set_password_page.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/view/set_password_success_page.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/di/sme_invalidate_voucher_module.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/view/sme_invalidate_voucher_page.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/view/sme_invalidate_voucher_success_page.dart';
import 'package:lykke_mobile_mavn/feature_social/view/social_page.dart';
import 'package:lykke_mobile_mavn/feature_spend/di/transfer_module.dart';
import 'package:lykke_mobile_mavn/feature_splash/di/splash_module.dart';
import 'package:lykke_mobile_mavn/feature_splash/view/mandatory_app_upgrade_page.dart';
import 'package:lykke_mobile_mavn/feature_splash/view/splash_page.dart';
import 'package:lykke_mobile_mavn/feature_terms_and_policies/view/privacy_policy_page.dart';
import 'package:lykke_mobile_mavn/feature_terms_and_policies/view/terms_of_use_page.dart';
import 'package:lykke_mobile_mavn/feature_ticker/di/ticker_module.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/view/transfer_voucher_page.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/view/transfer_voucher_success_page.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/di/voucher_details_module.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/view/voucher_details_page.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/di/voucher_purchase_module.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/di/voucher_wallet_page_module.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/view/voucher_wallet_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet/view/wallet_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/link_advanced_wallet/link_advanced_wallet_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/link_wallet/link_simple_wallet_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/link_wallet/link_wallet_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/link_wallet_in_progress/link_wallet_in_progress_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/link_wallet_receive/link_wallet_receive_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/linked_wallet.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/linked_wallet_send/linked_wallet_send_failed_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/linked_wallet_send/linked_wallet_send_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/linked_wallet_send/linked_wallet_send_progress_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/di/wallet_unlinking_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/view/unlink_wallet_in_progress/unlink_wallet_in_progress_page.dart';
import 'package:lykke_mobile_mavn/feature_welcome/di/welcome_module.dart';
import 'package:lykke_mobile_mavn/feature_welcome/view/welcome_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:provider/provider.dart';

class RouterPageFactory {
  RouterPageFactory._();

  //region Splash, Onboarding & Welcome
  static Widget getSplashPage() => ModuleProvider(
        module: SplashModule(),
        child: SplashPage(),
      );

  static Widget getOnboardingPage() =>
      ModuleProvider(module: OnboardingModule(), child: OnboardingPage());

  static Widget getWelcomePage() =>
      ModuleProvider(module: WelcomeModule(), child: WelcomePage());

  //endregion Splash, Onboarding & Welcome

  //region Authentication
  //region Login
  static Widget getLoginPage({
    bool unauthorizedInterceptorRedirection = false,
  }) =>
      ModuleProvider(
        module: LoginModule(),
        child: LoginPage(
          unauthorizedInterceptorRedirection:
              unauthorizedInterceptorRedirection,
        ),
      );

  //endregion Login

  //region PIN
  static Widget getPinCreatePage() => ModuleProvider(
        module: PinModule(),
        child: PinCreatePage(),
      );

  static Widget getPinConfirmPage(List<int> passCode) => ModuleProvider(
        module: PinModule(),
        child: PinConfirmPage(passCode),
      );

  static Widget getPinForgotPage() => ModuleProvider(
        module: PinModule(),
        child: PinForgotPage(),
      );

  static Widget getPinSignInPage() => ModuleProvider(
        module: PinModule(),
        child: PinSignInPage(),
      );

  static Widget getPinVerificationPage() => ModuleProvider(
        module: PinModule(),
        child: const PinVerificationPage(),
      );

  static Widget getPinCreatedSuccessPage() => PinCreatedSuccessPage();

  static Widget getBiometricAgreementPage(
          {bool unauthorizedInterceptorRedirection}) =>
      BiometricAgreementPage(
        unauthorizedInterceptorRedirection: unauthorizedInterceptorRedirection,
      );

  //endregion PIN

  //region Registration
  static Widget getRegisterPage() => MultiProvider(
        providers: [
          ModuleProvider(module: PasswordValidationModule()),
          ModuleProvider(module: RegisterModule())
        ],
        child: RegisterPage(),
      );

  static Widget getEmailVerificationPage({
    @required String email,
    @required VerificationStatus status,
  }) =>
      ModuleProvider(
        module: EmailVerificationModule(),
        child: EmailVerificationPage(email: email, status: status),
      );

  static Widget getEmailConfirmationPage() => const EmailConfirmationPage();

  static Widget getEmailVerificationSuccessPage() =>
      EmailVerificationSuccessPage();

  //endregion Registration

  //region Password
  static Widget getChangePasswordPage() => MultiProvider(providers: [
        ModuleProvider(module: PasswordValidationModule()),
        ModuleProvider(module: ChangePasswordModule())
      ], child: ChangePasswordPage());

  static Widget getResetPasswordPage() => ModuleProvider(
        module: ResetPasswordModule(),
        child: ResetPasswordPage(),
      );

  static Widget getSetPasswordPage(String email, String resetIdentifier) =>
      MultiProvider(
          providers: [
            ModuleProvider(module: PasswordValidationModule()),
            ModuleProvider(module: ResetPasswordModule())
          ],
          child: SetPasswordPage(
            email: email,
            resetIdentifier: resetIdentifier,
          ));

  static Widget getChangePasswordSuccessPage() => ChangePasswordSuccessPage();

  static Widget getSetPasswordSuccessPage() => SetPasswordSuccessPage();

  //endregion Password

  static Widget getAccountDeactivatedPage() => AccountDeactivatedPage();

  //endregion Authentication

  //region Home
  static Widget getHomePage() => MultiProvider(
        providers: [
          ModuleProvider(module: StakingReferralsModule()),
          ModuleProvider(module: NotificationModule())
        ],
        child: HomePage(),
      );

  static Widget getBottomBarPage() =>
      ModuleProvider(module: BottomBarModule(), child: BottomBarPage());

  static Widget getLandingPage() => ModuleProvider(
        module: LandingModule(),
        child: LandingPage(),
      );

  static Widget getWalletPage() => ModuleProvider(
        module: WalletPageModule(),
        child: WalletPage(),
      );

  static Widget getAccountPage() => AccountPage();

  static Widget getNotificationListPage() => ModuleProvider(
        module: NotificationModule(),
        child: NotificationListPage(),
      );

  //endregion Home

  //region Referrals

  //region Hotel Referral

  static Widget getHotelReferralPage(ExtendedEarnRule extendedEarnRule) =>
      MultiProvider(
        providers: [
          ModuleProvider(module: PartnerNameModule()),
          ModuleProvider(module: HotelReferralModule())
        ],
        child: HotelReferralPage(extendedEarnRule: extendedEarnRule),
      );

  static Widget getHotelReferralSuccessPage(
    String refereeFullName,
    ExtendedEarnRule extendedEarnRule,
  ) =>
      ModuleProvider(
        module: PartnerNameModule(),
        child: HotelReferralSuccessPage(
          refereeFullName: refereeFullName,
          extendedEarnRule: extendedEarnRule,
        ),
      );

  static Widget getHotelReferralAcceptedPage() => HotelReferralAcceptedPage();

  //endregion Hotel Referral

  //region Friend Referral

  static Widget getFriendReferralPage(ExtendedEarnRule extendedEarnRule) =>
      ModuleProvider(
        module: FriendReferralModule(),
        child: FriendReferralPage(extendedEarnRule: extendedEarnRule),
      );

  static Widget getFriendReferralSuccessPage() => FriendReferralSuccessPage();

  //endregion Friend Referral

  static Widget getReferralListPage() => ModuleProvider(
        module: ReferralListModule(),
        child: ReferralListPage(),
      );

  //endregion Referrals

  //region Utilities
  static Widget getMaintenancePage(MaintenanceResponseModel maintenanceModel) =>
      ModuleProvider(
          module: MaintenanceModule(),
          child: MaintenancePage(maintenanceModel: maintenanceModel));

  static Widget getCountryCodeListPage() => CountryCodeListPage();

  static Widget getCountryListPage({String pageTitle}) =>
      CountryListPage(pageTitle: pageTitle);

  //endregion Utilities

  //region Transactions & Payments
  static Widget getTransactionFormPage({String emailAddress}) => ModuleProvider(
        module: TransactionFormModule(),
        child: TransactionFormPage(emailAddress: emailAddress),
      );

  static Widget getP2pTransactionSuccessPage() => TransactionSuccessPage();

  static Widget getP2PReceiveTokenPage() => ModuleProvider(
        module: P2PReceiveTokenModule(),
        child: P2pReceiveTokenPage(),
      );

  static Widget getLinkWalletPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkWalletPage(),
      );

  static Widget getLinkedWalletSendPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkedWalletSendPage(),
      );

  static Widget getLinkedWalletSendProgressPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkedWalletSendProgressPage(),
      );

  static Widget getLinkedWalletSendFailedPage({String amount, String error}) =>
      ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkedWalletSendFailedPage(
          amount: amount,
          error: error,
        ),
      );

  static Widget getLinkedWalletPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkedWalletPage(),
      );

  static Widget getLinkWalletInProgressPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkWalletInProgressPage(),
      );

  static Widget getUnlinkWalletInProgressPage() => ModuleProvider(
        module: WalletUnlinkingModule(),
        child: UnlinkWalletInProgressPage(),
      );

  static Widget getLinkAdvancedWalletPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkAdvancedWalletPage(),
      );

  static Widget getLinkSimpleWalletPage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkSimpleWalletPage(),
      );

  static Widget getLinkWalletReceivePage() => ModuleProvider(
        module: WalletLinkingModule(),
        child: LinkWalletReceivePage(),
      );

  static Widget getPaymentRequestApprovalSuccessPage() =>
      PaymentRequestApprovalSuccessPage();

  static Widget getPaymentRequestExpiredPage() => PaymentRequestExpiredPage();

  static Widget getPaymentRequestListPage() => ModuleProvider(
        module: PartnerPaymentsModule(),
        child: const PaymentRequestListPage(),
      );

  //endregion Transactions & Payments

  //region Spend & Earn rules
  static Widget getOffersPage() => ModuleProvider(
        module: CampaignListModule(),
        child: CampaignListPage(),
      );

  static Widget getPartnerListPage(List<Partner> partners) =>
      PartnerListPage(partners: partners);

  static Widget getEarnRuleDetailPage(EarnRule earnRule) => MultiProvider(
        providers: [
          ModuleProvider(module: EarnModule()),
          ModuleProvider(module: EarnRuleDetailModule())
        ],
        child: EarnRuleDetailPage(earnRule: earnRule),
      );

  static Widget getStakingDetailsPage(ExtendedEarnRule extendedEarnRule) =>
      StakingDetailsPage(extendedEarnRule: extendedEarnRule);

  static Widget getPaymentRequestPage(String paymentRequestId,
          {bool fromPushNotification = false}) =>
      MultiProvider(
        providers: [
          ModuleProvider(module: RedeemTransferModule()),
          ModuleProvider(module: TickerModule()),
          ModuleProvider(module: PaymentRequestModule())
        ],
        child: PaymentRequestPage(
            paymentRequestId: paymentRequestId,
            fromPushNotification: fromPushNotification),
      );

  //endregion Spend & Earn rules

  //region Partners
  static Widget getHotelWelcomeDialog(String partnerMessageId) =>
      ModuleProvider(
        module: HotelWelcomeModule(),
        child: HotelWelcomeDialog(partnerMessageId: partnerMessageId),
      );

  static Widget getHotelPreCheckoutDialog(String paymentRequestId) =>
      ModuleProvider(
        module: HotelPreCheckoutModule(),
        child: HotelPreCheckoutDialog(paymentRequestId: paymentRequestId),
      );

  //endregion Partners

  //region Static pages from Account
  static Widget getContactUsPage() => ContactUsPage();

  static Widget getPersonalDetailsPage() => ModuleProvider(
        module: PersonalDetailsModule(),
        child: PersonalDetailsPage(),
      );

  static Widget getTermsOfUsePage() => TermsOfUsePage();

  static Widget getPrivacyPolicyPage() => PrivacyPolicyPage();

//endregion Static pages from Account

  //region Campaigns
  static Widget getCampaignListPage() => ModuleProvider(
        module: CampaignListModule(),
        child: CampaignListPage(),
      );

  static Widget getCampaignMapPage() => ModuleProvider(
        module: CampaignMapModule(),
        child: CampaignMapPage(),
      );

  static Widget getCampaignDetailsPage({CampaignResponseModel campaign}) =>
      ModuleProvider(
        module: VoucherPurchaseModule(),
        child: CampaignDetailsPage(campaign: campaign),
      );

  //endregion Campaigns

  //region Vouchers

  static Widget getVoucherWalletPage() => MultiProvider(
        providers: [
          ModuleProvider(module: WalletPageModule()),
          ModuleProvider(module: VoucherWalletModule()),
        ],
        child: VoucherWalletPage(),
      );

  static Widget getVoucherDetailsPage({
    VoucherResponseModel voucher,
    Color voucherColor,
  }) =>
      ModuleProvider(
        module: VoucherDetailsModule(),
        child: VoucherDetailsPage(voucher: voucher, voucherColor: voucherColor),
      );

  static Widget getTransferVoucherPage({
    String voucherShortCode,
  }) =>
      TransferVoucherPage(voucherCode: voucherShortCode);

  static Widget getVoucherTransferSuccessPage(String receiverEmail) =>
      TransferVoucherSuccessPage(receiverEmail: receiverEmail);

  //endregion Vouchers

  //region Social
  static Widget getSocialPage() => SocialPage();

  //endregion Social

  //region SME linking

  static Widget getSmeLinkingPage() => MultiProvider(
        providers: [
          ModuleProvider(module: SmeLinkingModule()),
          ModuleProvider(module: BarcodeScanModule()),
        ],
        child: SmeLinkingPage(),
      );

  static Widget getSmeLinkingSuccessPage() => SmeLinkingSuccessPage();

  static Widget getSmeInvalidateVoucherPage(
          {@required String voucherShortCode}) =>
      MultiProvider(
        providers: [
          ModuleProvider(module: SmeInvalidateVoucherModule()),
          ModuleProvider(module: VoucherDetailsModule()),
        ],
        child: SmeInvalidateVoucherPage(
          voucherShortCode: voucherShortCode,
        ),
      );

  static Widget getSmeInvalidateVoucherSuccessPage() =>
      SmeInvalidateVoucherSuccessPage();

  //endregion SME linking

  //region Misc
  static Widget getMandatoryAppUpgradePage() => const MandatoryAppUpgradePage();

  static Widget getComingSoonPage({String title, bool hasBackButton}) =>
      ComingSoonPage(
        title: title,
        hasBackButton: hasBackButton,
      );

//endregion Misc
}
