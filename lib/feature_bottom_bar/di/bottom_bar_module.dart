import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/router/router_page_factory.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/analytics/bottom_bar_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class BottomBarModule extends Module {
  BottomBarAnalyticsManager get bottomBarAnalyticsManager => get();

  BottomBarPageBloc get bottomBarPageBloc => get();

  Widget get homePage => get(qualifierName: 'homePage');

  Widget get offersPage => get(qualifierName: 'offersPage');

  Widget get walletPage => get(qualifierName: 'walletPage');

  Widget get socialPage => get(qualifierName: 'socialPage');

  @override
  void provideInstances() {
    provideSingleton(() => BottomBarAnalyticsManager(get()));
    provideSingleton(() => BottomBarPageBloc(get(), get()));

    provideSingleton<Widget>(() => RouterPageFactory.getHomePage(),
        qualifierName: 'homePage');
    provideSingleton<Widget>(() => RouterPageFactory.getOffersPage(),
        qualifierName: 'offersPage');
    provideSingleton<Widget>(() => RouterPageFactory.getWalletPage(),
        qualifierName: 'walletPage');
    provideSingleton<Widget>(() => RouterPageFactory.getSocialPage(),
        qualifierName: 'socialPage');
  }
}
