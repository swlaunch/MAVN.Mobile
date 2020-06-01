import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';

class CampaignAboutSection extends HookWidget {
  const CampaignAboutSection({@required this.about});

  final String about;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            useLocalizedStrings().about,
            style: TextStyles.darkHeadersH3,
          ),
          const SizedBox(height: 24),
          NullSafeText(
            about,
            style: TextStyles.darkBodyBody2Black
                .copyWith(color: ColorStyles.silverChalice),
          ),

          ///offset the bottom buttons
          const SizedBox(height: 100)
        ],
      );
}
