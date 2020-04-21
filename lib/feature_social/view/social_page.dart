import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class SocialPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = useThemeBloc();
    final themeState = useBlocState(themeBloc);

    if (themeState is! ThemeSelectedState) {
      return Container();
    }

    final theme = (themeState as ThemeSelectedState).theme;
    return Scaffold(
      backgroundColor: theme.appBackground,
      appBar: AppBar(
        title: Text(
          useLocalizedStrings().socialPageTitle,
          style: TextStyles.h1PageHeader,
        ),
        backgroundColor: theme.appBarBackground,
        elevation: 0,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Column(
                children: <Widget>[
                  Image(
                      image: AssetImage(ImageAssets.comingSoon),
                      fit: BoxFit.contain),
                  AutoSizeText(
                    useLocalizedStrings().socialPageComingSoon,
                    style: TextStyles.darkHeadersH2,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
