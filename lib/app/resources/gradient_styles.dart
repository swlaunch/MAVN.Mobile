import 'dart:ui';

import 'package:flutter/material.dart';

import 'color_styles.dart';

class GradientStyles {
  GradientStyles._();

  static const bronzeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      ColorStyles.veryLightBrown,
      ColorStyles.bronze1,
    ],
    tileMode: TileMode.clamp,
  );
}
