import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class CustomBackButton extends HookWidget {
  const CustomBackButton({this.color = ColorStyles.primaryDark});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('backButton'),
        borderRadius: BorderRadius.circular(45),
        onTap: router.maybePop,
        child: Container(
          height: 48,
          width: 48,
          alignment: Alignment.center,
          child: RotatedBox(
            quarterTurns: 2,
            child: StandardSizedSvg(SvgAssets.arrow, color: color),
          ),
        ),
      ),
    );
  }
}
