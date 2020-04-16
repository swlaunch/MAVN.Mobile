import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class PageCloseButton extends HookWidget {
  const PageCloseButton({
    @required this.onTap,
    this.color = ColorStyles.primaryDark,
  });

  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        height: 32,
        alignment: Alignment.topRight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('pageCloseButton'),
            borderRadius: BorderRadius.circular(45),
            onTap: onTap,
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: Icon(Icons.close, color: color),
            ),
          ),
        ),
      );
}
