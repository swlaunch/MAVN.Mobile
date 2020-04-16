import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

import 'divider_decoration.dart';

class TabPageTitle extends StatelessWidget {
  const TabPageTitle({
    this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) => Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyles.darkHeadersH2,
                ),
                const SizedBox(height: 12),
                const DividerDecoration(color: ColorStyles.primaryDark),
              ]),
        ),
      );
}
