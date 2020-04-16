import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureOnboardingSteps = [
  GivenINavigateToTheWelcomePage(),
  GivenIGoToTheLastOnboardingPage()
];

class GivenINavigateToTheWelcomePage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageSkipButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "WelcomePage"');
}

class GivenIGoToTheLastOnboardingPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageNextButton'));
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageNextButton'));
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('onboardingPageNextButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I go to the last onboarding page');
}
