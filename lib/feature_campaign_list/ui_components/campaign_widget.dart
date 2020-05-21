import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/price_tag.dart';

class CampaignWidget extends StatelessWidget {
  const CampaignWidget({
    @required this.title,
    @required this.imageUrl,
    @required this.price,
  });

  final String title;
  final String imageUrl;
  final FiatCurrency price;

  static const double _cardBorderRadius = 10;
  static const double cardHeight = 150;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cardBorderRadius),
              child: Container(
                width: double.infinity,
                height: cardHeight,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        child: NetworkImageWithPlaceholder(
                          imageUrl: imageUrl,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: ColorStyles.resolutionBlue.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyles.lightHeadersH2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(right: 0, top: 16, child: PriceTag(price: price)),
        ],
      );
}
