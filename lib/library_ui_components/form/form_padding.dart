import 'package:flutter/cupertino.dart';

class FormPadding extends StatelessWidget {
  const FormPadding({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
        child: child,
      );
}
