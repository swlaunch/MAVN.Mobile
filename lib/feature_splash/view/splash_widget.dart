import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';

class SplashWidget extends HookWidget {
  const SplashWidget();

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        children: [
          const Spacer(flex: 1),
          SvgPicture.asset(SvgAssets.splashLogo),
          const Spacer(flex: 2),
        ],
      ));
}
