import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:throttling/throttling.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    @required this.text,
    @required this.onTap,
    this.buttonKey,
    this.isLoading = false,
    this.isLight = false,
    this.isFullWidth = true,
    this.height = 48,
    this.padding,
    this.throttleInterval,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final String text;
  final Key buttonKey;
  final bool isLight;
  final double height;
  final bool isFullWidth;
  final EdgeInsetsGeometry padding;
  final Duration throttleInterval;

  VoidCallback _getOnTapFunction() {
    if (isLoading) {
      return null;
    }

    if (throttleInterval != null) {
      final throttler = Throttling(duration: throttleInterval);
      return () => throttler.throttle(onTap);
    }

    return onTap;
  }

  @override
  Widget build(BuildContext context) => Container(
        width: isFullWidth ? double.infinity : null,
        height: height,
        child: RaisedButton(
          padding: padding,
          key: buttonKey,
          child: isLoading
              ? Container(
                  width: 20,
                  height: 20,
                  child: const Spinner(color: ColorStyles.primaryBlue),
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: isLight
                      ? TextStyles.darkButtonExtraBold
                      : TextStyles.lightButtonExtraBold,
                ),
          onPressed: _getOnTapFunction(),
          color: isLight ? Colors.white : ColorStyles.primaryDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      );
}
