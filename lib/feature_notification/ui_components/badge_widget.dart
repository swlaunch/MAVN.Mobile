import 'package:flutter/material.dart';

///The little red circle we use as new notification indicator
class BadgeWidget extends StatelessWidget {
  const BadgeWidget({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
}
