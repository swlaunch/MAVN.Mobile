import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    @required this.text,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 48,
        child: RaisedButton(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyles.lightButtonExtraBold,
          ),
          onPressed: onTap,
          color: ColorStyles.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: ColorStyles.white, width: 2),
          ),
        ),
      );
}
