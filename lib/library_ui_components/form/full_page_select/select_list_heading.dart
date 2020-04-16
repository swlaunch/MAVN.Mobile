import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class SelectListHeading extends StatelessWidget {
  const SelectListHeading(this.text);

  final String text;

  @override
  Widget build(context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyles.darkBodyBody1Bold,
            ),
            Container(
              height: 4,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 6),
              child: Container(width: 12, color: ColorStyles.primaryDark),
            ),
          ],
        ),
      );
}
