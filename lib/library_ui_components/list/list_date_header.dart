import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class ListDateHeader extends StatelessWidget {
  const ListDateHeader({
    @required this.text,
    Key key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        color: ColorStyles.offWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            text.toUpperCase(),
            style: TextStyles.darkBodyBody4Regular,
          ),
        ),
      );
}
