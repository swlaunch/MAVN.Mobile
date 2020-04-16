import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  const NetworkImageWithPlaceholder({
    this.imageUrl,
    this.height,
    this.width = double.infinity,
    this.borderRadiusSize = 8,
  });

  final String imageUrl;
  final double height;
  final double width;
  final double borderRadiusSize;

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusSize),
      child: Container(
          width: width,
          height: height,
          child: imageUrl != null && imageUrl.isNotEmpty
              ? FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: ImageAssets.placeholder,
                  image: imageUrl,
                )
              : Image.asset(ImageAssets.placeholder, fit: BoxFit.cover)));
}
