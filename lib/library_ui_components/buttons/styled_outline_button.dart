import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:throttling/throttling.dart';

class StyledOutlineButton extends StatelessWidget {
  const StyledOutlineButton({
    @required this.text,
    @required this.onTap,
    this.isLoading = false,
    this.useDarkTheme = false,
    this.throttleInterval,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isLoading;
  final Duration throttleInterval;
  final String text;
  final bool useDarkTheme;

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
        width: double.infinity,
        height: 48,
        child: OutlineButton(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: useDarkTheme
                ? TextStyles.darkButtonExtraBold.copyWith(
                    color: ColorStyles.shark,
                  )
                : TextStyles.lightButtonExtraBold,
          ),
          onPressed: _getOnTapFunction(),
          borderSide: BorderSide(
              color: useDarkTheme ? ColorStyles.shark : ColorStyles.white,
              width: 2),
          highlightedBorderColor: ColorStyles.shark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
}
