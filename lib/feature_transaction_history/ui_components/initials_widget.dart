import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class InitialsWidget extends StatelessWidget {
  const InitialsWidget({
    @required this.initialsText,
    this.color = ColorStyles.white,
    this.textColor = ColorStyles.charcoalGrey,
    this.fontSize = 12,
  });

  final String initialsText;
  final Color color;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final initials = StringUtils.isNullOrWhitespace(initialsText)
        ? ''
        : initialsText
            .split(' ')
            .map((s) => s.substring(0, 1).toUpperCase())
            .join();
    return Container(
      color: color,
      child: Center(
        child: Text(
          initials,
          style: TextStyles.darkBodyBody3Bold.copyWith(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
