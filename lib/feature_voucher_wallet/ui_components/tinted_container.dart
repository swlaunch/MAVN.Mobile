import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';

class TintedContainer extends StatelessWidget {
  const TintedContainer({
    @required this.child,
    @required this.imageUrl,
    this.color = Colors.white,
  });

  final Color color;
  final String imageUrl;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
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
              color: color.withOpacity(0.6),
              child: child,
            ),
          )
        ],
      );
}
