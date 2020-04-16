import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class StyledInputDecoration extends InputDecoration {
  StyledInputDecoration({
    String labelText,
    Widget suffix,
    EdgeInsets contentPadding = const EdgeInsets.only(bottom: 4),
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
              ? FieldBorderStyles.errorBorder
              : FieldBorderStyles.focusedBorder,
          enabledBorder: hasError
              ? FieldBorderStyles.errorBorder
              : FieldBorderStyles.defaultBorder,
          disabledBorder: FieldBorderStyles.dynamicBorder(
              hasError: hasError, hasFocus: hasFocus),
          focusedErrorBorder: FieldBorderStyles.errorBorder,
          errorBorder: FieldBorderStyles.errorBorder,
          border: FieldBorderStyles.dynamicBorder(
              hasError: hasError, hasFocus: hasFocus),
          suffix: suffix,
          isDense: true,
        );
}

class FieldBorderStyles {
  static const defaultBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorStyles.paleLilac),
  );

  static const errorBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorStyles.errorRed),
  );

  static const focusedBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorStyles.primaryBlue),
  );

  static UnderlineInputBorder dynamicBorder({bool hasError, bool hasFocus}) =>
      UnderlineInputBorder(
        borderSide: BorderSide(
            width: 2,
            color: ColorStyles.inputBorderColor(
                hasError: hasError, hasFocus: hasFocus)),
      );
}
