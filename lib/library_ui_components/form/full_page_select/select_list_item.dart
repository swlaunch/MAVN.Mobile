import 'package:flutter/material.dart';

class SelectListItem extends StatelessWidget {
  const SelectListItem({
    @required this.child,
    @required this.valueKey,
    @required this.onTap,
    this.padding = const EdgeInsets.all(0),
  });

  final Widget child;
  final Key valueKey;
  final VoidCallback onTap;
  final EdgeInsets padding;

  @override
  Widget build(context) => InkWell(
        onTap: onTap,
        child: Container(
          key: valueKey,
          width: double.infinity,
          padding: padding,
          child: child,
        ),
      );
}
