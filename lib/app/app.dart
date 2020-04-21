import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lykke_mobile_mavn/app/app_localizations_delegate.dart';
import 'package:lykke_mobile_mavn/app/bloc/app_bloc.dart';
import 'package:lykke_mobile_mavn/base/constants/configuration.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/debug_menu.dart';
import 'package:lykke_mobile_mavn/feature_splash/view/splash_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

enum Environment { dev, qa, staging, prod, automationIos, automationAndroid }

class App extends HookWidget {
  App({Environment environment = Environment.dev}) {
    App.environment = environment;
  }

  static bool get isReleaseMode =>
      const bool.fromEnvironment('dart.vm.product');

  static Environment environment;

  @override
  Widget build(BuildContext context) {
    final appBloc = useAppBloc();
    final appState = useBlocState<AppState>(appBloc);

    useEffect(() {
      appBloc.initializeApp(
        environment: environment,
        context: context,
      );
    }, [appBloc]);

    return Stack(
      textDirection: TextDirection.rtl,
      children: <Widget>[
        const SplashWidget(),
        if (appState is AppStateInitialized) _buildApp(appState: appState)
      ],
    );
  }

  Widget _buildApp({@required AppStateInitialized appState}) => ModuleProvider(
        module: appState.appModule,
        child: MaterialApp(
          home: DebugMenu(
            environment: environment,
            child: Stack(
              children: <Widget>[
                const SplashWidget(),
                MaterialApp(
                  key: const Key('app'),
                  title: _getAppTitle(),
                  localizationsDelegates: const [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: appSupportedLocales,
                  localeResolutionCallback: defaultLocaleResolution,
                  navigatorKey: appState.appModule.globalNavigatorStateKey,
                  navigatorObservers: [
                    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
                  ],
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: appState.rootPageWidget,
                  // Set up root page name for Firebase analytics
                  initialRoute: appState.rootPageName,
                  routes: {
                    '${appState.rootPageName}': (_) => appState.rootPageWidget
                  },
                ),
              ],
            ),
          ),
        ),
      );

  String _getAppTitle() {
    switch (App.environment) {
      case Environment.dev:
        return '${Configuration.appName} Dev';
      case Environment.qa:
        return '${Configuration.appName} Test';
      case Environment.automationIos:
        return '${Configuration.appName} Automation';
      case Environment.automationAndroid:
        return '${Configuration.appName} Automation';
      case Environment.staging:
        return '${Configuration.appName} Staging';
      case Environment.prod:
        return Configuration.appName;
    }

    return Configuration.appName;
  }
}

Locale defaultLocaleResolution(
        Locale currentLocale, Iterable<Locale> supportedLocales) =>
    supportedLocales.firstWhere(
        (locale) => currentLocale.languageCode == locale.languageCode,
        orElse: () => supportedLocales.first);
