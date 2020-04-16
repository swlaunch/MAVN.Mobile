import 'package:flutter/material.dart';

class NullSafeText extends StatelessWidget {
  const NullSafeText(this.text, {this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Text(
        text ?? '',
        style: style,
      );
}
