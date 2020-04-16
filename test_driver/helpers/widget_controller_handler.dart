import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:pedantic/pedantic.dart';

// NOTE: ONLY IMPORT THIS FILE IN THE FLUTTER DRIVER "APP" FILE,
// DON'T IMPORT IT IN ANY "TEST" FILE.
// Reason: this file imports material.dart which should never be imported in a
// Flutter Driver test file because Flutter Driver  doesn't know about the
// Flutter framework so you'll get a lot of  errors
// (e.g. Error: Not found: 'dart:ui')

LiveWidgetController _widgetController;

Future<String> widgetControllerHandler(
  String message,
) async {
  _widgetController = LiveWidgetController(WidgetsBinding.instance);

  if (message == 'resetAppState') {
    await _resetAppState();
  }

  return message;
}

Future<void> _resetAppState() async {
  final router = _getRouter()..popToRoot();

  // We need to pop and replace all routes so we can reset the app state by
  // automatically cleaning up bloc and module state in the onDispose methods
  // of BlocProvider and ModuleProvider
  unawaited(router.replacePage(Container(
    child: const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Resetting application',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontStyle: FontStyle.italic),
        ),
      ),
    ),
  )));
  await _widgetController.pump(const Duration(milliseconds: 500));

  unawaited(router.pushOnboardingPage());
  await _widgetController.pump(const Duration(milliseconds: 500));
}

Router _getRouter() =>
    (_widgetController.widget(find.byType(typeOf<ModuleProvider<AppModule>>()))
            as ModuleProvider<AppModule>)
        .module
        .router;

Type typeOf<T>() => T;
