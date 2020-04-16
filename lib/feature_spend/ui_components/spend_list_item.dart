import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';

class SpendListItem extends StatelessWidget {
  const SpendListItem({
    @required this.offer,
    @required this.onTap,
    this.extraContent,
  });

  final SpendRule offer;
  final VoidCallback onTap;
  final Widget extraContent;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageWithPlaceholder(
                imageUrl: offer.imageUrl,
                height: 160,
              ),
              const SizedBox(height: 16),
              Text(offer.title, style: TextStyles.darkHeadersH3),
              const SizedBox(height: 8),
              Text(
                offer.description,
                style: TextStyles.darkBodyBody2RegularHigh,
                maxLines: 3,
                overflow: TextOverflow.fade,
              ),
              if (extraContent != null) extraContent
            ],
          ),
        ),
      );
}
