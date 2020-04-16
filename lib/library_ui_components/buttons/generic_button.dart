import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class GenericButton extends StatelessWidget {
  const GenericButton({
    @required this.text,
    @required this.onTap,
    this.valueKey,
    this.iconAsset,
    this.iconColor = ColorStyles.charcoalGrey,
    this.height = 48,
    this.width = double.infinity,
    this.color = ColorStyles.white,
    this.textStyle = TextStyles.darkButtonText,
  });

  final String text;
  final VoidCallback onTap;
  final ValueKey valueKey;
  final String iconAsset;
  final Color iconColor;
  final double height;
  final double width;
  final Color color;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        child: RaisedButton(
          key: valueKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (iconAsset != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: StandardSizedSvg(
                    iconAsset,
                    color: iconColor,
                  ),
                ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ],
          ),
          onPressed: onTap,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
}
