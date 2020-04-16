import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/unlocalized_strings.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class DebugMenuBanner extends HookWidget {
  const DebugMenuBanner({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final debugMenuState = useBlocState<DebugMenuState>(useDebugMenuBloc());

    if (debugMenuState.proxyUrl == null || debugMenuState.proxyUrl.isEmpty) {
      return Container();
    }

    return Banner(
      message: UnlocalizedStrings.proxyBannerMessage,
      location: BannerLocation.topStart,
      child: Container(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
