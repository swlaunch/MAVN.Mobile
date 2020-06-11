import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class TextStyles {
  TextStyles._();

  static const String commonFontFamily = 'NunitoSans';
  static const String headerTitleFontFamily = 'PlayFairDisplay';

  static const TextStyle darkHeaderTitle = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: headerTitleFontFamily,
    fontStyle: FontStyle.normal,
    fontSize: 26,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle lightHeaderTitle = TextStyle(
    color: ColorStyles.white,
    fontFamily: headerTitleFontFamily,
    fontStyle: FontStyle.normal,
    fontSize: 26,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle h1PageHeader = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle h1PageHeaderLight = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle imageButtonCardCallToAction = TextStyle(
    color: ColorStyles.resolutionBlue,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );

  static const TextStyle body1BoldDarkHigh = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle textLinkButton = TextStyle(
    color: ColorStyles.primaryBlue,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle darkInputLabelBold = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  static const darkHeadersH1 = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 36,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const lightHeadersH1 = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 36,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const darkHeadersH2 = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const headersH2Disabled = TextStyle(
    color: ColorStyles.cloudyBlue,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const lightHeadersH2 = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const darkHeadersH3 = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const lightHeadersH3 = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const darkBodyBody1Bold = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const darkBodyBody4Regular = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const bodyBody4RegularError = TextStyle(
    color: ColorStyles.redOverdue,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const darkBodyBody1Regular = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const darkBodyBody1RegularHigh = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const lightBody4Bold = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const darkButtonExtraBold = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const lightButtonExtraBold = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const darkBodyBody2Bold = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const darkBodyBody2Black = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const darkBodyBody2BoldHigh = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static const inputTextBoldError = TextStyle(
    color: ColorStyles.errorRed,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const inputTextRegularError = TextStyle(
    color: ColorStyles.errorRed,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const headersH2Error = TextStyle(
    color: ColorStyles.errorRed,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const darkInputTextBold = TextStyle(
    color: ColorStyles.primaryDark,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const inputTextBoldDisabled = TextStyle(
    color: ColorStyles.cloudyBlue,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const lightInputTextRegular = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const linksTextLinkBold = TextStyle(
    color: ColorStyles.primaryBlue,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const linksTextLinkBoldHigh = TextStyle(
    color: ColorStyles.primaryBlue,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const darkBodyBody2RegularHigh = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const darkBodyBody2RegularExtraHigh = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const darkBodyBody2Regular = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const lightBodyBody2Regular = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const lightBodyBody2RegularHigh = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const inputLabelBoldError = TextStyle(
    color: ColorStyles.errorRed,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  static const inputLabelBoldGrey = TextStyle(
    color: ColorStyles.slateGrey,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const darkButtonText = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const linksTextLinkSmallBold = TextStyle(
    color: ColorStyles.primaryBlue,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const darkBodyBody3RegularHigh = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const darkBodyBody3Regular = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: 1,
  );
  static const darkBodyBody3Bold = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    height: 1,
  );

  static const errorTextBold = TextStyle(
    color: ColorStyles.errorRed,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const lightBodyBody3Regular = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static const offerListItemTitle = TextStyle(
    color: ColorStyles.charcoalGrey,
    fontFamily: commonFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // Special font without color or size for the BottomBar text
  static const bottomBarItemText = TextStyle(
    fontFamily: commonFontFamily,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  static const balanceConversionText = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle badge = TextStyle(
    color: Colors.white,
    fontFamily: commonFontFamily,
    fontSize: 10,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static const notificationListItemSubtitle = TextStyle(
    color: ColorStyles.slateGrey,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  ///from design
  static const voucherPartnerName = TextStyle(
    color: ColorStyles.white,
    fontFamily: commonFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static const body3Light = TextStyle(
    color: ColorStyles.white,
    fontFamily: commonFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const partnerNameTopSection = TextStyle(
    color: Colors.black,
    fontFamily: commonFontFamily,
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const transactionHistoryHeader = TextStyle(
    color: Colors.black,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const transactionHistoryOperation = TextStyle(
    color: Colors.black,
    fontFamily: commonFontFamily,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
  );

  static const transactionHistoryCampaign = TextStyle(
    color: Colors.black,
    fontFamily: commonFontFamily,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const transactionHistoryPartner = TextStyle(
    color: ColorStyles.manatee50,
    fontFamily: commonFontFamily,
    fontSize: 10,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );

  static const transactionHistoryAmount = TextStyle(
    color: ColorStyles.resolutionBlue,
    fontFamily: commonFontFamily,
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );
}
