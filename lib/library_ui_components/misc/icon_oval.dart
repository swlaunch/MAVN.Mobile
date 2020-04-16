import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class IconOval extends StatelessWidget {
  const IconOval({this.iconAsset, this.child, Key key}) : super(key: key);

  final String iconAsset;
  final Widget child;

  Widget _buildContent() {
    if (iconAsset != null) {
      return SvgPicture.asset(
        iconAsset,
        width: 40,
        height: 40,
        color: ColorStyles.slateGrey,
      );
    }

    if (child != null) {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 144,
        height: 144,
        decoration: const BoxDecoration(
          color: ColorStyles.paleLilac,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildContent(),
        ),
      );
}
