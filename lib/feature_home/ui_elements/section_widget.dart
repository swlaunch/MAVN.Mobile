import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/circular_widget.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    @required this.child,
    @required this.circularWidget,
    @required this.title,
    @required this.subtitle,
  });

  final Widget child;
  final Widget circularWidget;
  final String title;

  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        color: ColorStyles.white,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Row(
                children: <Widget>[
                  CircularWidget(
                    child: circularWidget,
                    size: 40,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyles.darkBodyBody2BoldHigh,
                      ),
                      Text(
                        subtitle,
                        style: TextStyles.darkBodyBody4Regular,
                      )
                    ],
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      );
}
