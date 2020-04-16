import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    @required this.title,
    this.assetIconLeading,
    this.assetIconTrailing,
    this.assetIconTrailingAlignedToTitle = false,
    this.iconLeadingSize = 24,
    this.iconTrailingSize = 24,
    this.logo = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final String title;
  final String assetIconLeading;
  final String assetIconTrailing;
  final double iconLeadingSize;
  final double iconTrailingSize;
  final bool assetIconTrailingAlignedToTitle;
  final bool logo;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: padding,
                child: Heading(
                  title,
                  icon: assetIconLeading,
                  iconSize: iconLeadingSize,
                  endContentAlignedToTitle: assetIconTrailingAlignedToTitle,
                  endContent: assetIconTrailing != null
                      ? SvgPicture.asset(assetIconTrailing,
                          width: iconTrailingSize, height: iconTrailingSize)
                      : null,
                ))
          ]);
}
