import 'package:flutter/material.dart';

class DividerDecoration extends StatelessWidget {
  const DividerDecoration({
    this.color,
    this.width = 26,
    this.height = 4,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, width: width, color: color ?? Colors.white);
}
