import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';

class SmallTokenIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        SvgAssets.tokenLight,
        height: 12,
        width: 12,
      );
}
