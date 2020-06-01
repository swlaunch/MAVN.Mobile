import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class FloatingBackButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    return FloatingActionButton(
      onPressed: router.maybePop,
      backgroundColor: ColorStyles.froly,
      child: RotatedBox(
        quarterTurns: 2,
        child: StandardSizedSvg(SvgAssets.arrow, color: ColorStyles.white),
      ),
    );
  }
}
