import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

class GivenITapOnTheCountryCodeWidget
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byType('CountryCodeWidget'));
  }

  @override
  RegExp get pattern => RegExp(r'I tap the CountryCodeWidget');
}

class GivenITapOneCountryCode
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('0'));
  }

  @override
  RegExp get pattern => RegExp(r'I tap one country code');
}

class GivenIHaveSelectedACountryCode
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byType('CountryCodeWidget'));

    await FlutterDriverUtils.tap(world.driver, find.byValueKey('0'));
  }

  @override
  RegExp get pattern => RegExp(r'I select a country code');
}
