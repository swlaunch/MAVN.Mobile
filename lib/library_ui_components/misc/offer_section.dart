import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class OfferSection extends StatelessWidget {
  const OfferSection({
    this.asset,
    this.title,
    this.details,
    this.body,
    Key key,
  }) : super(key: key);

  final String asset;
  final String title;
  final String details;
  final Widget body;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StandardSizedSvg(asset),
                  const SizedBox(width: 12),
                  Text(title, style: TextStyles.offerListItemTitle),
                  if (details != null)
                    Text(details, style: TextStyles.darkBodyBody2RegularHigh),
                ]),
          ),
          body
        ]),
      );
}
