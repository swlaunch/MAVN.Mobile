import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class Spinner extends StatelessWidget {
  const Spinner({Key key, this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? ColorStyles.primaryDark,
        ),
      );
}
