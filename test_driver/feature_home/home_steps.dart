import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureHomeSteps = [
  GivenIHaveABalance(),
  GivenINavigateToThePageHomePage(),
  GivenTokenExpiredForBalanceRequest(),
  GivenBalanceRequestWillTimeout(),
];

class GivenIHaveABalance extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    // No Step execution required because MockServerDispatcher already mocks
    // happy paths
  }

  @override
  RegExp get pattern => RegExp(r'I have a balance');
}

class GivenINavigateToThePageHomePage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    // No Step execution required because after logging in we are already on the
    // HomePage
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "HomePage"');
}

class GivenTokenExpiredForBalanceRequest
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/wallets/customer',
      filePath: 'test_resources/mock_data/wallets/customer/response/200.json',
      method: 'get',
      statusCode: 401,
    );
  }

  @override
  RegExp get pattern => RegExp(r'token expired for balance request');
}

class GivenBalanceRequestWillTimeout
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/wallets/customer',
      filePath: 'test_resources/mock_data/wallets/customer/response/200.json',
      method: 'get',
      statusCode: 200,
      willTimeout: true,
    );
  }

  @override
  RegExp get pattern => RegExp(r'the balance request will timeout');
}
