import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StandardSizedSvg extends StatelessWidget {
  const StandardSizedSvg(this.asset, {this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset(asset, color: color, height: 24, width: 24);
}
