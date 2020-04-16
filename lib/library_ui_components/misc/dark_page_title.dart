import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';

class DarkPageTitle extends StatelessWidget {
  const DarkPageTitle({@required this.pageTitle});

  final String pageTitle;

  @override
  Widget build(context) => Container(
        width: double.infinity,
        color: ColorStyles.primaryDark,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pageTitle, style: TextStyles.lightHeadersH2),
              const SizedBox(height: 12),
              const DividerDecoration(),
              const SizedBox(height: 32)
            ],
          ),
        ),
      );
}
