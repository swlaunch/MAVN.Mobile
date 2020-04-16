import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeShortcutItemWidget extends HookWidget {
  const HomeShortcutItemWidget({
    @required this.child,
    @required this.backgroundColor,
    @required this.text,
    @required this.onTap,
  });

  final Widget child;
  final Color backgroundColor;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 120,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(13.5)),
                ),
                child: child,
              ),
              const SizedBox(height: 12),
              Text(text)
            ],
          ),
        ),
      );
}
