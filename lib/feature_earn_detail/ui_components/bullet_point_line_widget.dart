import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';

class BulletPointLineWidget extends StatelessWidget {
  const BulletPointLineWidget({this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child:
                  DividerDecoration(color: ColorStyles.primaryDark, width: 8),
            ),
            const SizedBox(width: 24),
            Flexible(child: body),
          ],
        ),
      );
}
