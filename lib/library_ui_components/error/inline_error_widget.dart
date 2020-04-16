import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class InlineErrorWidget extends StatelessWidget {
  const InlineErrorWidget({
    this.errorMessage,
    this.keyValue,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.only(bottom: 16),
  });

  final String errorMessage;
  final String keyValue;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        alignment: alignment,
        padding: padding,
        child: Text(
          errorMessage,
          key: Key(keyValue),
          style: TextStyles.errorTextBold,
        ),
      );
}
