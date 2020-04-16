import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/app.dart';

import 'debug_menu_banner.dart';
import 'debug_menu_drawer.dart';

class DebugMenu extends StatelessWidget {
  const DebugMenu({
    Key key,
    this.child,
    this.environment,
  }) : super(key: key);

  final Widget child;
  final Environment environment;

  @override
  Widget build(BuildContext context) {
    if (environment == Environment.prod || environment == Environment.staging) {
      return Container(child: child);
    }

    return Stack(
      children: <Widget>[
        Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            body: child,
            drawer: DebugMenuDrawer()),
        const DebugMenuBanner()
      ],
    );
  }
}
