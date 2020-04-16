import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureLoginSteps = [
  GivenUserExists(),
  GivenUserDoesNotExists(),
  GivenEmailHasInvalidFormat(),
  GivenPasswordHasInvalidFormat(),
  GivenLoginRequestWillTimeout()
];

class GivenUserExists
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    // No Step execution required because MockServerDispatcher already mocks
    // happy paths
  }

  @override
  RegExp get pattern => RegExp(r'user {String} exists for login');
}

class GivenUserDoesNotExists
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/auth/login',
      method: 'post',
      filePath: 'test_resources/mock_data/login/response/'
          '400_invalid_credentials.json',
      statusCode: 400,
    );
  }

  @override
  RegExp get pattern => RegExp(r'user {String} does not exist for login');
}

class GivenEmailHasInvalidFormat
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/auth/login',
      method: 'post',
      filePath: 'test_resources/mock_data/common_error_responses'
          '/400_invalid_email_format.json',
      statusCode: 400,
    );
  }

  @override
  RegExp get pattern => RegExp(r'email {string} has invalid format for login');
}

class GivenPasswordHasInvalidFormat
    extends Given1WithWorld<String, FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep(String input) async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/auth/login',
      method: 'post',
      filePath: 'test_resources/mock_data/common_error_responses'
          '/400_invalid_password_format.json',
      statusCode: 400,
    );
  }

  @override
  RegExp get pattern =>
      RegExp(r'password {string} has invalid format for login');
}

class GivenLoginRequestWillTimeout
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/auth/login',
      method: 'post',
      filePath: 'test_resources/mock_data/login/response/'
          '/200.json',
      statusCode: 200,
      willTimeout: true,
    );
  }

  @override
  RegExp get pattern => RegExp(r'the login request will timeout');
}
