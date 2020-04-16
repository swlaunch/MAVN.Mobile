import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'file.dart';

void initScreenshots() {
  WidgetsApp.debugAllowBannerOverride = false;

  FontLoader('Quicksand')
    ..addFont(getFontByteData('assets/fonts/quicksand/Quicksand-Light.ttf'))
    ..addFont(getFontByteData('assets/fonts/quicksand/Quicksand-Regular.ttf'))
    ..addFont(getFontByteData('assets/fonts/quicksand/Quicksand-SemiBold.ttf'))
    ..addFont(getFontByteData('assets/fonts/quicksand/Quicksand-Bold.ttf'))
    ..load();
}

Future<void> thenWidgetShouldMatchScreenshot(
  WidgetTester widgetTester,
  Finder finder,
  String screenshotName, {
  double width = 412,
  double height = 732,
}) async {
  WidgetsBinding.instance.renderView.configuration = TestViewConfiguration(
    size: Size(width, height),
  );

  await widgetTester.pump();
  await expectLater(
    finder,
    matchesGoldenFile(
        'screenshots/${Platform.operatingSystem}/$screenshotName.png'),
  );
}
