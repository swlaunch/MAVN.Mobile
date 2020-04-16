import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureRegisterSteps = [
  GivenUserAlreadyExists(),
  GivenUserIsAvailable(),
  GivenEmailHasInvalidFormat(),
  GivenPasswordHasInvalidFormat(),
  GivenRegisterRequestWillTimeout(),
  GivenRegistrationSuccess(),
];

class GivenUserIsAvailable
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    // No Step execution required because MockServerDispatcher already mocks
    // happy paths
  }

  @override
  RegExp get pattern => RegExp(r'user {String} is available for register');
}

class GivenUserAlreadyExists
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/customers/register',
      method: 'post',
      filePath: 'test_resources/mock_data/register/response/'
          '400_login_already_in_use.json',
      statusCode: 400,
    );
  }

  @override
  RegExp get pattern => RegExp(r'user {String} already exists for register');
}

class GivenEmailHasInvalidFormat
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/customers/register',
      method: 'post',
      filePath: 'test_resources/mock_data/common_error_responses'
          '/400_invalid_email_format.json',
      statusCode: 400,
    );
  }

  @override
  RegExp get pattern =>
      RegExp(r'email {string} has invalid format for register');
}

class GivenPasswordHasInvalidFormat
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/customers/register',
      method: 'post',
      filePath: 'test_resources/mock_data/common_error_responses'
          '/400_invalid_password_format.json',
      statusCode: 400,
    );
  }

  @override
  RegExp get pattern =>
      RegExp(r'password {string} has invalid format for register');
}

class GivenRegisterRequestWillTimeout
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/customers/register',
      method: 'post',
      filePath: 'test_resources/mock_data/register/response/200.json',
      statusCode: 200,
      willTimeout: true,
    );
  }

  @override
  RegExp get pattern => RegExp(r'the register request will timeout');
}

class GivenRegistrationSuccess
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('welcomeCreateAccountButton'));
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey('emailTextField'), 'valid@email.com');
    await FlutterDriverUtils.enterText(
        world.driver, find.byValueKey('passwordTextField'), 'validPassword');
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('registerSubmitButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I successfully registered a new account');
}
