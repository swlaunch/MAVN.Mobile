import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';

class TokenIcon extends StatelessWidget {
  const TokenIcon({
    this.color,
    this.size = 16,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(SvgAssets.token,
      color: color, height: size, width: size);
}
