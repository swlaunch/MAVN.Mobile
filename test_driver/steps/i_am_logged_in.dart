import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

class GivenIAmLoggedIn extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageSkipButton'));
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('welcomeSignInButton'));
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey('emailTextField'), 'valid@email.com');
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey('passwordTextField'), 'validPassword');
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('loginSubmitButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I am logged in');
}
