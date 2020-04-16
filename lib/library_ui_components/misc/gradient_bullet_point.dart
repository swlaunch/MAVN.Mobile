import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/gradient_styles.dart';

class GradientBulletPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: GradientStyles.bronzeGradient,
        ),
        child: const SizedBox(width: 8, height: 4),
      );
}
