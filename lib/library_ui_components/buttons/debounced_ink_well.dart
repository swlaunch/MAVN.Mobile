import 'package:flutter/material.dart';
import 'package:throttling/throttling.dart';

class DebouncedInkWell extends StatelessWidget {
  const DebouncedInkWell({
    this.child,
    this.onTap,
    this.throttleInterval,
  });

  final Widget child;
  final VoidCallback onTap;
  final Duration throttleInterval;

  VoidCallback _getOnTapFunction() {
    if (throttleInterval != null) {
      final throttler = Throttling(duration: throttleInterval);
      return () => throttler.throttle(onTap);
    }

    return onTap;
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: _getOnTapFunction(),
        child: child,
      );
}
