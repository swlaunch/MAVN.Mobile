import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureReferralListSteps = [
  GivenIHaveSomeReferrals(),
  GivenINavigateToThePageReferralListPage(),
  GivenTokenExpiredForReferralListRequest(),
  GivenReferralListRequestWillTimeout(),
];

class GivenIHaveSomeReferrals
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    // No Step execution required because MockServerDispatcher already mocks
    // happy paths
  }

  @override
  RegExp get pattern => RegExp(r'I have some referrals');
}

class GivenINavigateToThePageReferralListPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await world.driver.scrollIntoView(
      find.byValueKey('goToReferralListPageButton'),
    );
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('goToReferralListPageButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "ReferralListPage"');
}

class GivenTokenExpiredForReferralListRequest
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/referrals/leads',
      filePath: 'test_resources/mock_data/referrals/leads/response/200.json',
      method: 'get',
      statusCode: 401,
    );
  }

  @override
  RegExp get pattern =>
      RegExp(r'token expired for the get referral list request');
}

class GivenReferralListRequestWillTimeout
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
      uriPath: '/referrals/leads',
      filePath: 'test_resources/mock_data/referrals/leads/response/200.json',
      method: 'get',
      statusCode: 200,
      willTimeout: true,
    );
  }

  @override
  RegExp get pattern => RegExp(r'the get referral list request will timeout');
}
