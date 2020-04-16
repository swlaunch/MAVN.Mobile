import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/icon_oval.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    this.title,
    this.text,
    this.asset,
    this.image,
    Key key,
  }) : super(key: key);

  final String title;
  final String text;
  final String asset;
  final Widget image;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (asset != null) IconOval(iconAsset: asset),
            if (image != null) image,
            const SizedBox(height: 24),
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  style: TextStyles.darkBodyBody1Bold,
                  textAlign: TextAlign.center,
                ),
              ),
            if (text != null)
              Text(
                text,
                style: TextStyles.darkBodyBody1Regular,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
}
