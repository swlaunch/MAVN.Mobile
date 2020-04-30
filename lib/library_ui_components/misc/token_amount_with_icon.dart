import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class TokenAmountWithIcon extends StatelessWidget {
  const TokenAmountWithIcon(
    this.tokenAmount, {
    this.textStyle = TextStyles.body1BoldDarkHigh,
    this.showAsterisk = false,
    Key key,
  }) : super(key: key);

  final String tokenAmount;
  final TextStyle textStyle;
  final bool showAsterisk;

  @override
  Widget build(BuildContext context) {
    final formattedAmount =
        showAsterisk == true ? '$tokenAmount*' : tokenAmount;
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Spacer(flex: 7),
                Flexible(
                  flex: 23,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      child: SvgPicture.asset(
                        SvgAssets.token,
                        fit: BoxFit.contain,
                        height: 0,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 5),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              formattedAmount,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
