import 'package:flutter/cupertino.dart';

class HomeScreenSection extends StatelessWidget {
  const HomeScreenSection({
    @required this.child,
    @required this.backgroundColor,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: child,
      );
}
