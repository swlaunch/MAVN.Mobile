import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

import 'divider_decoration.dart';

class MainPageTitle extends StatelessWidget {
  const MainPageTitle({this.title, this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyles.darkHeaderTitle),
            if (subtitle != null)
              Text(subtitle, style: TextStyles.darkBodyBody1Regular),
            const SizedBox(height: 16),
            const DividerDecoration(color: ColorStyles.primaryDark),
          ],
        ),
      );
}
