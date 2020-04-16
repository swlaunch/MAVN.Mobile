import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class RectangularInputDecoration extends InputDecoration {
  RectangularInputDecoration({
    String labelText,
    Widget suffix,
    EdgeInsets contentPadding = const EdgeInsets.all(16),
    bool hasError = false,
    bool hasFocus = false,
  }) : super(
          hintText: labelText,
          hintStyle: hasError
              ? TextStyles.inputTextRegularError
              : TextStyles.darkBodyBody2RegularHigh,
          errorStyle: TextStyles.errorTextBold,
          errorMaxLines: 3,
          counterText: '',
          contentPadding: contentPadding,
          focusedBorder: hasError
              ? RectangularBorderStyles.errorBorder
              : RectangularBorderStyles.focusedBorder,
          enabledBorder: hasError
              ? RectangularBorderStyles.errorBorder
              : RectangularBorderStyles.defaultBorder,
          disabledBorder: RectangularBorderStyles.dynamicBorder(
              hasError: hasError, hasFocus: hasFocus),
          focusedErrorBorder: RectangularBorderStyles.errorBorder,
          errorBorder: RectangularBorderStyles.errorBorder,
          border: RectangularBorderStyles.dynamicBorder(
              hasError: hasError, hasFocus: hasFocus),
          suffix: suffix,
        );
}

class RectangularBorderStyles {
  static const defaultBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorStyles.primaryDark),
  );

  static const errorBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorStyles.errorRed),
  );

  static const focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorStyles.primaryDark),
  );

  static OutlineInputBorder dynamicBorder({bool hasError, bool hasFocus}) =>
      OutlineInputBorder(
        borderSide: BorderSide(
            width: 2,
            color: ColorStyles.inputBorderColor(
                hasError: hasError, hasFocus: hasFocus)),
      );
}
