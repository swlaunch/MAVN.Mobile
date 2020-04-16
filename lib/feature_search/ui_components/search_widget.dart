import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class SearchWidget extends HookWidget {
  const SearchWidget({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4),
        child: StandardSizedSvg(
          SvgAssets.search,
          color: color,
        ),
      );
}
