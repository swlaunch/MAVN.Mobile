import 'package:flutter/cupertino.dart';

class FieldPadding extends StatelessWidget {
  const FieldPadding(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: child,
      );
}
