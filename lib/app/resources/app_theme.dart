import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

abstract class BaseAppTheme {
  Color get appBackground;

  Color get overlayBottom;

  Color get appBarBackground;

  Color get sectionBackground;

  Color get appBarIcon;

  Color get appBarBubble;

  Color get elevationBottomColor;

  Color get bottomBarBackground;

  Color get bottomBarBorder;

  Color get bottomBarNotchBackground;

  Color get bottomBarNotchIcon;

  Color get bottomBarSelected;

  Color get bottomBarDeselected;

  Color get homeWalletBackground;

  Color get homeAppReferralBackground;

  Color get homeYourOffersBackground;

  Color get iconBackground;

  Color get icon;

  Color get walletBoxGradientTop;

  Color get walletBoxGradientBottom;

  Color get walletButtonsBackground;

  Color get walletButtonsIcon;

  Color get walletButtonsBorder;

  Color tabBar;

  Color tabBarIndicator;
}

class LightTheme extends BaseAppTheme {
  @override
  Color get appBackground => ColorStyles.alabaster;

  @override
  Color get overlayBottom => ColorStyles.alabaster;

  @override
  Color get appBarBackground => ColorStyles.alabaster;

  @override
  Color get sectionBackground => ColorStyles.white;

  @override
  Color get appBarIcon => ColorStyles.boulder;

  @override
  Color get appBarBubble => ColorStyles.redOrange;

  @override
  Color get bottomBarBackground => ColorStyles.white;

  @override
  Color get bottomBarBorder => ColorStyles.grayNurse;

  @override
  Color get bottomBarNotchBackground => ColorStyles.bitterSweet;

  @override
  Color get bottomBarNotchIcon => ColorStyles.white;

  @override
  Color get bottomBarSelected => ColorStyles.vividTangerine;

  @override
  Color get bottomBarDeselected => ColorStyles.dustyGray;

  @override
  Color get elevationBottomColor => ColorStyles.alabaster;

  @override
  Color get homeWalletBackground => ColorStyles.chestNutRose;

  @override
  Color get homeAppReferralBackground => ColorStyles.robRoy;

  @override
  Color get homeYourOffersBackground => ColorStyles.tradeWind;

  @override
  Color get iconBackground => ColorStyles.alabaster;

  @override
  Color get icon => ColorStyles.silverChalice;

  @override
  Color get walletBoxGradientTop => ColorStyles.sunglo;

  @override
  Color get walletBoxGradientBottom => ColorStyles.fuzzyWuzzyBrown;

  @override
  Color get walletButtonsBackground => ColorStyles.white;

  @override
  Color get walletButtonsIcon => ColorStyles.bitterSweet;

  @override
  Color get walletButtonsBorder => ColorStyles.concrete;

  @override
  Color get tabBar => ColorStyles.alabaster;

  @override
  Color get tabBarIndicator => ColorStyles.bitterSweet;
}

class DarkTheme extends BaseAppTheme {
  @override
  Color get appBackground => Colors.white;

  @override
  Color get overlayBottom => ColorStyles.alabaster;

  @override
  Color get appBarBackground => ColorStyles.white;

  @override
  Color get sectionBackground => ColorStyles.white;

  @override
  Color get appBarIcon => ColorStyles.boulder;

  @override
  Color get appBarBubble => ColorStyles.redOrange;

  @override
  Color get bottomBarBackground => ColorStyles.white;

  @override
  Color get bottomBarBorder => ColorStyles.grayNurse;

  @override
  Color get bottomBarNotchBackground => ColorStyles.bitterSweet;

  @override
  Color get bottomBarNotchIcon => ColorStyles.white;

  @override
  Color get bottomBarSelected => ColorStyles.vividTangerine;

  @override
  Color get bottomBarDeselected => ColorStyles.dustyGray;

  @override
  // TODO: implement elevationBottomColor
  Color get elevationBottomColor => throw UnimplementedError();

  @override
  Color get homeWalletBackground => ColorStyles.chestNutRose;

  @override
  Color get homeAppReferralBackground => ColorStyles.robRoy;

  @override
  Color get homeYourOffersBackground => ColorStyles.tradeWind;

  @override
  Color get iconBackground => ColorStyles.alabaster;

  @override
  Color get icon => ColorStyles.silverChalice;

  @override
  Color get walletBoxGradientTop => ColorStyles.sunglo;

  @override
  Color get walletBoxGradientBottom => ColorStyles.fuzzyWuzzyBrown;

  @override
  Color get walletButtonsBackground => ColorStyles.fuzzyWuzzyBrown;

  @override
  Color get walletButtonsIcon => ColorStyles.fuzzyWuzzyBrown;
  @override
  Color get walletButtonsBorder => ColorStyles.fuzzyWuzzyBrown;

  @override
  Color get tabBar => ColorStyles.alabaster;

  @override
  Color get tabBarIndicator => ColorStyles.bitterSweet;
}
