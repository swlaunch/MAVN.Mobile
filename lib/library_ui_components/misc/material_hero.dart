import 'package:flutter/material.dart';

///A [Hero] whose child is wrapped in [Material]
/// so that design does not change when in transition
class MaterialHero extends StatelessWidget {
  const MaterialHero({@required this.tag, @required this.child});

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) => Hero(
        tag: tag,
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      );
}
