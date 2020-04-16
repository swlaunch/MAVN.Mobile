import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class GenericChip extends StatelessWidget {
  const GenericChip({
    @required this.chipContentWidget,
    this.iconSize,
  });

  final Widget chipContentWidget;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (chipContentWidget != null) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorStyles.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: ColorStyles.shadow,
              blurRadius: 2,
            )
          ],
        ),
        child: chipContentWidget,
      );
    }
    return Container();
  }
}
