import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class TransactionButton extends StatelessWidget {
  const TransactionButton({
    this.valueKey,
    this.iconBackgroundColor,
    this.icon,
    this.title,
    this.description,
    this.onTap,
    this.trailingWidget,
    this.titleTextStyle = TextStyles.darkHeadersH3,
  });

  TransactionButton.simple({
    this.valueKey,
    this.iconBackgroundColor,
    this.icon,
    this.title,
    String description = '',
    this.onTap,
    this.trailingWidget,
    this.titleTextStyle = TextStyles.darkHeadersH3,
  }) : description = Text(
          description,
          key: const Key('transactionButtonDescription'),
          style: TextStyles.darkBodyBody4Regular,
        );

  final ValueKey valueKey;
  final Color iconBackgroundColor;
  final Widget icon;
  final String title;
  final Widget description;
  final VoidCallback onTap;
  final TextStyle titleTextStyle;
  final Widget trailingWidget;

  @override
  Widget build(BuildContext context) => InkWell(
        key: valueKey,
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: iconBackgroundColor,
              ),
              margin: const EdgeInsets.only(right: 20),
              child: icon,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: titleTextStyle,
                    ),
                    if (description != null) description,
                  ],
                ),
              ),
            ),
            if (trailingWidget != null) trailingWidget
          ],
        ),
      );
}
