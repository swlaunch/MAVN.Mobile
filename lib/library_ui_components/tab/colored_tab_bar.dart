import 'package:flutter/material.dart';

///Used to easily change the background color of a [TabBar]
class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({@required this.tabBar, this.tabColor});

  final Color tabColor;
  final TabBar tabBar;

  static const double _bottomPadding = 12;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(bottom: _bottomPadding),
        color: tabColor ?? Colors.transparent,
        child: Material(
          child: tabBar,
          type: MaterialType.transparency,
        ),
      );
}
