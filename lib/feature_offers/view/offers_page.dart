import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_earn/view/earn_rule_list_page.dart';
import 'package:lykke_mobile_mavn/feature_spend/view/spend_rule_list_page.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class OffersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);
    if (themeBlocState is! ThemeSelectedState) {
      return Container();
    }
    final theme = (themeBlocState as ThemeSelectedState).theme;
    return DefaultTabController(
      //TODO add initial index
      length: 2,
      child: Scaffold(
          backgroundColor: theme.appBackground,
          appBar: AppBar(
            backgroundColor: theme.appBarBackground,
            title: Text(useLocalizedStrings().offers,
                style: TextStyles.h1PageHeader),
            bottom: TabBar(
              indicatorColor: theme.tabBarIndicator,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    useLocalizedStrings().earn.toUpperCase(),
                    style: TextStyles.darkBodyBody2Regular
                        .copyWith(color: theme.tabBarIndicator),
                  ),
                ),
                Tab(
                  child: Text(
                    useLocalizedStrings().redeem.toUpperCase(),
                    style: TextStyles.darkBodyBody2Regular
                        .copyWith(color: theme.tabBarIndicator),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      EarnRuleListPage(),
                      SpendRuleListPage(),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
