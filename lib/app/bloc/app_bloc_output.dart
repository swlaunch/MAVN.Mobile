import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class AppState extends BlocState {}

class AppStateInitializing extends AppState {}

class AppStateInitialized extends AppState {
  AppStateInitialized({
    @required this.appModule,
    @required this.rootPageWidget,
    @required this.rootPageName,
  });

  final AppModule appModule;
  final Widget rootPageWidget;
  final String rootPageName;
}
