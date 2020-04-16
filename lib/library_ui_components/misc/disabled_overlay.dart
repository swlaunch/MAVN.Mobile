import 'package:flutter/material.dart';

class DisabledOverlay extends StatelessWidget {
  const DisabledOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Positioned.fill(child: Container(color: Colors.white60));
}
