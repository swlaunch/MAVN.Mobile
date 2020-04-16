import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({this.title, this.leadingWidget});

  final String title;
  final Widget leadingWidget;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            leadingWidget,
            const SizedBox(width: 12),
            Text(
              title?.toUpperCase(),
              style: TextStyles.inputLabelBoldGrey,
            )
          ],
        ),
      );
}
