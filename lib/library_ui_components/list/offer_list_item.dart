import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';

class OfferListItem extends StatelessWidget {
  const OfferListItem({
    Key key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.onTap,
    this.chip,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget chip;

  // calculate the image ratio to match the design
  static const double imageRatio = 360 / 125;

  static const double earnTitleTopPadding = 8;
  static const double spendTitleTopPadding = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      child: NetworkImageWithPlaceholder(
                        imageUrl: imageUrl,
                        borderRadiusSize: 0,
                      ),
                      aspectRatio: imageRatio,
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
                Positioned(
                  left: 24,
                  bottom: 0,
                  child: chip,
                ),
              ],
            ),
            SizedBox(
                height:
                    chip != null ? earnTitleTopPadding : spendTitleTopPadding),
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  title,
                  style: TextStyles.offerListItemTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                child: Text(
                  subtitle,
                  style: TextStyles.darkBodyBody3Regular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      );
}
