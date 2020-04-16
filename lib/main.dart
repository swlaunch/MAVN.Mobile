import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/bloc/app_bloc.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';

void main({Environment selectedEnvironment = Environment.dev}) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Crashlytics.instance.enableInDevMode = true;

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() async {
    runApp(
      Provider.value(
        value: AppBloc(),
        child: App(environment: selectedEnvironment),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}
