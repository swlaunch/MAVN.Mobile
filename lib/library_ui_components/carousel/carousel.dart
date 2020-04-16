import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({
    this.children,
    this.startPadding = 0,
  });

  final Iterable<Widget> children;
  final double startPadding;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: startPadding),
              ...children,
            ],
          ),
        ),
      );
}
