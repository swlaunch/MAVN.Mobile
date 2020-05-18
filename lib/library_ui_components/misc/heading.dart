import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';

class Heading extends StatelessWidget {
  const Heading(
    this.text, {
    this.icon,
    this.iconSize = 24,
    this.currentStep,
    this.totalSteps,
    this.endContent,
    this.endContentAlignedToTitle = false,
    this.rowAlignment = CrossAxisAlignment.center,
    this.invert = false,
    this.dividerTopSpacing = 12,
  });

  final String text;
  final String icon;
  final double iconSize;
  final String currentStep;
  final String totalSteps;
  final Widget endContent;
  final bool endContentAlignedToTitle;
  final CrossAxisAlignment rowAlignment;
  final bool invert;
  final double dividerTopSpacing;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: rowAlignment,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (icon != null) _buildIcon(),
                      _buildTitle(),
                      if (endContent != null && endContentAlignedToTitle)
                        endContent
                    ],
                  ),
                  SizedBox(height: dividerTopSpacing),
                  Row(
                    children: <Widget>[
                      DividerDecoration(
                        color: invert
                            ? ColorStyles.white
                            : ColorStyles.primaryDark,
                      ),
                      if (currentStep != null && totalSteps != null)
                        _buildStepInfo(context),
                    ],
                  ),
                ],
              ),
            ),
            if (endContent != null && !endContentAlignedToTitle) endContent,
          ],
        ),
      );

  Widget _buildIcon() => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SvgPicture.asset(
          icon,
          width: iconSize,
          height: iconSize,
          color: invert ? ColorStyles.white : ColorStyles.primaryDark,
        ),
      );

  Widget _buildTitle() => Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style:
                invert ? TextStyles.lightHeadersH2 : TextStyles.darkHeadersH2,
            textAlign: TextAlign.left,
          ),
        ),
      );

  Widget _buildStepInfo(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          LocalizedStrings.of(context).stepOf(currentStep, totalSteps),
          style: TextStyles.darkBodyBody3RegularHigh,
        ),
      );
}
