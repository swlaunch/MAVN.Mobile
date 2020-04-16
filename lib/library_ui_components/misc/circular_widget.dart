import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  const CircularWidget({
    @required this.child,
    @required this.size,
  });

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: Container(height: size, width: size, child: child),
      );
}
