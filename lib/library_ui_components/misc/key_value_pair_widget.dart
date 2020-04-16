import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class KeyValuePairWidget extends StatelessWidget {
  const KeyValuePairWidget({
    this.pairKey,
    this.pairValue,
    this.valueStyle = TextStyles.darkInputTextBold,
  });

  final String pairKey;
  final String pairValue;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(pairKey?.toUpperCase(), style: TextStyles.darkInputLabelBold),
          const SizedBox(height: 8),
          Text(pairValue, style: valueStyle),
        ],
      );
}
