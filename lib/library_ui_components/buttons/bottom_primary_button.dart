import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';

///A Container that contains a [PrimaryButton]
///to be positioned at the bottom of the screen.
///Can be used in [Stack] only.
class BottomPrimaryButton extends StatelessWidget {
  const BottomPrimaryButton({
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

  @override
  Widget build(BuildContext context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: ColorStyles.alabaster,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: PrimaryButton(
            text: text,
            onTap: onTap,
            buttonKey: buttonKey,
            isLoading: isLoading,
            isLight: isLight,
            isFullWidth: isFullWidth,
            height: height,
            padding: padding,
            throttleInterval: throttleInterval,
          ),
        ),
      );
}
