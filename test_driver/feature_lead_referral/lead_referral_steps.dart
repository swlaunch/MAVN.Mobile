import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../feature_country_code/country_code_steps.dart';
import '../worlds/flutter_with_mock_server_world.dart';

final List featureLeadReferralSteps = [
  GivenINavigateToTheLeadReferralPage(),
  GivenLeadReferralSubmissionWillBeSuccessful(),
  GivenLeadReferralSubmissionError(),
  GivenINavigateToTheLeadReferralSuccessPage(),
  GivenLeadReferralSubmissionWillTimeOut(),
  GivenITapOnTheCountryCodeWidget(),
  GivenITapOneCountryCode(),
  GivenIHaveSelectedACountryCode(),
  GivenIFillAllLeadReferralFormDataCorrectly()
];

class GivenINavigateToTheLeadReferralPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('goToLeadReferralPageButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "LeadReferralPage"');
}

class GivenLeadReferralSubmissionWillBeSuccessful
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    // No Step execution required because MockServerDispatcher already mocks
    // happy paths
  }

  @override
  RegExp get pattern => RegExp(r'lead referral submission will be successful');
}

class GivenLeadReferralSubmissionError
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
        uriPath: '/referrals/lead',
        method: 'post',
        filePath: 'test_resources/mock_data/common_error_responses/'
            '400_unknown_error.json',
        statusCode: 400);
  }

  @override
  RegExp get pattern =>
      RegExp(r'lead referral submission will return an error');
}

class GivenLeadReferralSubmissionWillTimeOut
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
        uriPath: '/referrals/lead',
        method: 'post',
        filePath: 'test_resources/mock_data/referrals/lead/response/204.json',
        statusCode: 204,
        willTimeout: true);
  }

  @override
  RegExp get pattern => RegExp(r'the referral submission request will timeout');
}

class GivenINavigateToTheLeadReferralSuccessPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('goToLeadReferralPageButton'));

    await _fillFormFieldsCorrectly(world.driver);

    await world.driver.scrollIntoView(find.byValueKey('submitButton'));
    await world.driver.tap(find.byValueKey('submitButton'));
  }

  @override
  RegExp get pattern =>
      RegExp(r'I navigate to the page "LeadReferralSuccessPage"');
}

class GivenIFillAllLeadReferralFormDataCorrectly
    extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    await _fillFormFieldsCorrectly(world.driver);
  }

  @override
  RegExp get pattern => RegExp(
        r'I fill all lead referral form data correctly',
      );
}

Future<void> _fillFormFieldsCorrectly(FlutterDriver driver) async {
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('firstNameTextField'), 'John');
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('lastNameTextField'), 'Doe');
  await FlutterDriverUtils.tap(driver, find.byType('CountryCodeWidget'));

  await FlutterDriverUtils.tap(driver, find.byValueKey('0'));
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('phoneTextField'), '0123456789');
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('emailTextField'), 'john@doe.com');

  await driver.scrollIntoView(find.byValueKey('noteTextField'));
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('noteTextField'), 'some note');
}
