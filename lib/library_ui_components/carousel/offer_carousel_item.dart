import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';

class OfferCarouselItem extends StatelessWidget {
  const OfferCarouselItem({
    key,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  static const int _titleMaxLines = 2;

  @override
  Widget build(BuildContext context) => Container(
        width: 120,
        margin: const EdgeInsets.only(right: 22, top: 22, bottom: 22),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.redAccent.withOpacity(0.7),
                      BlendMode.modulate,
                    ),
                    child: NetworkImageWithPlaceholder(
                      imageUrl: imageUrl,
                      borderRadiusSize: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (title != null)
                Container(
                  height: _titleMaxLines *
                      TextStyles.darkBodyBody3Regular.fontSize *
                      TextStyles.darkBodyBody3Regular.height *
                      MediaQuery.of(context).textScaleFactor,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyles.darkBodyBody3Regular,
                    maxLines: _titleMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 8),
              if (subtitle != null)
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyles.darkBodyBody3RegularHigh,
                  maxLines: _titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      );
}
