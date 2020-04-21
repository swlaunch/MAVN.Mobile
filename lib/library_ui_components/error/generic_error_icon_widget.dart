import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class GenericErrorIconWidget extends StatelessWidget {
  const GenericErrorIconWidget({
    @required this.errorKey,
    @required this.title,
    @required this.text,
    @required this.onRetryTap,
    this.icon,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.buttonText,
  });

  final Key errorKey;
  final String title;
  final String text;
  final VoidCallback onRetryTap;
  final String icon;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String buttonText;

  @override
  Widget build(BuildContext context) => Container(
        key: errorKey,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: ColorStyles.charcoalGrey,
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (icon != null)
                  StandardSizedSvg(
                    icon,
                    color: Colors.white,
                  ),
                if (icon != null) const SizedBox(width: 14),
                Flexible(
                  child: Text(title,
                      key: const Key('errorWidgetIconTitle'),
                      style: TextStyles.lightHeadersH3),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                child: Text(text,
                    key: const Key('errorWidgetIconDetails'),
                    style: TextStyles.lightBody4Bold)),
            RaisedButton(
              key: const Key('genericErrorIconWidgetRetryButton'),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                (buttonText ?? LocalizedStrings.of(context).retryButton)
                    .toUpperCase(),
                style: TextStyles.linksTextLinkSmallBold,
              ),
              onPressed: onRetryTap,
            )
          ],
        ),
      );
}
