import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class SingleButtonDialog extends HookWidget {
  const SingleButtonDialog({
    @required this.title,
    @required this.content,
    @required this.buttonText,
    @required this.onTap,
  });

  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        width: 312,
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorStyles.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.darkHeadersH3),
            const SizedBox(height: 8),
            Text(content, style: TextStyles.darkBodyBody2RegularHigh),
            FlatButton(
              padding: const EdgeInsets.all(0),
              onPressed: onTap,
              child: Text(
                buttonText,
                style: TextStyles.linksTextLinkBold,
              ),
            ),
          ],
        ),
      );
}
