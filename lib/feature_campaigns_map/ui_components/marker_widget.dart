import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class MarkerWidget extends StatelessWidget {
  static const double _size = 40;

  @override
  Widget build(BuildContext context) => Container(
        height: _size,
        width: _size,
        decoration: BoxDecoration(
          color: ColorStyles.white,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ColorStyles.froly,
            shape: BoxShape.circle,
          ),
        ),
      );
}
