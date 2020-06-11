import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScaledDownSvg extends StatelessWidget {
  const ScaledDownSvg({
    @required this.asset,
    this.color,
    Key key,
    this.height = 12,
    this.width = 12,
  }) : super(key: key);

  final String asset;
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        asset,
        height: height,
        width: width,
        color: color,
        fit: BoxFit.scaleDown,
      );
}
