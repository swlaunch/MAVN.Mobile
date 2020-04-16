import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/flutter_with_mock_server_world.dart';

final List featureP2pTransactionSteps = [
  GivenINavigateToTheTransactionFormPage(),
  GivenTransactionSubmissionWillBeSuccessful(),
  GivenTransactionSubmissionError(),
  GivenINavigateToTheTransactionSuccessPage(),
  GivenTransactionSubmissionWillTimeOut(),
  GivenIFillAllTransactionFormDataCorrectly()
];

class GivenINavigateToTheTransactionFormPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('walletTab'));
    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('goToTransactionFormPageButton'));
  }

  @override
  RegExp get pattern => RegExp(r'I navigate to the page "TransactionFormPage"');
}

class GivenTransactionSubmissionWillBeSuccessful
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    // No Step execution required because MockServerDispatcher already mocks
    // happy paths
  }

  @override
  RegExp get pattern => RegExp(r'transaction submission will be successful');
}

class GivenTransactionSubmissionError
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
        uriPath: '/wallets/transfer',
        method: 'post',
        filePath: 'test_resources/mock_data/common_error_responses/'
            '400_unknown_error.json',
        statusCode: 400);
  }

  @override
  RegExp get pattern => RegExp(r'transaction submission will return an error');
}

class GivenTransactionSubmissionWillTimeOut
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    world.enqueueMockResponseFromFileForUriPath(
        uriPath: '/wallets/transfer',
        method: 'post',
        filePath: 'test_resources/mock_data/p2p_transactions/response/200.json',
        statusCode: 204,
        willTimeout: true);
  }

  @override
  RegExp get pattern =>
      RegExp(r'the transaction submission request will timeout');
}

class GivenINavigateToTheTransactionSuccessPage
    extends GivenWithWorld<FlutterWithMockServerWorld> {
  @override
  Future<void> executeStep() async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey('walletTab'));

    await FlutterDriverUtils.tap(
        world.driver, find.byValueKey('goToTransactionFormPageButton'));

    await _fillFormFieldsCorrectly(world.driver);

    await world.driver.tap(find.byValueKey('transactionFormSendButton'));
  }

  @override
  RegExp get pattern =>
      RegExp(r'I navigate to the page "TransactionSuccessPage"');
}

class GivenIFillAllTransactionFormDataCorrectly
    extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    await _fillFormFieldsCorrectly(world.driver);
  }

  @override
  RegExp get pattern => RegExp(
        r'I fill all transaction form data correctly',
      );
}

Future<void> _fillFormFieldsCorrectly(FlutterDriver driver) async {
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('walletAddressTextField'), 'jane@doe.com');
  await FlutterDriverUtils.enterText(
      driver, find.byValueKey('amountTextField'), '10');
}
