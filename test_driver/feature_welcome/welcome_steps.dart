import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureWelcomeSteps = [
  GivenINavigateToTheLoginPage(),
  GivenINavigateToTheRegisterPage()
];

class GivenINavigateToTheLoginPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageSkipButton'));
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('welcomeSignInButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "LoginPage"');
}

class GivenINavigateToTheRegisterPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageSkipButton'));
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('welcomeCreateAccountButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "RegisterPage"');
}
