import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/home_shortcut_item.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class YourOffersShortcutWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);

    if (themeBlocState is ThemeSelectedState) {
      final theme = themeBlocState.theme;

      return HomeShortcutItemWidget(
        backgroundColor: theme.homeYourOffersBackground,
        text: useLocalizedStrings().yourOffers,
        onTap: router.switchToOffersTab,
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(SvgAssets.yourOffers)),
      );
    }

    return Container();
  }
}
