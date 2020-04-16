import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/p2p_transaction_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/request_model/payment_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/wallet_api.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

WalletApi _subject;

void main() {
  mockServerHttpClientTest('WalletApi', (httpClient) {
    setUpAll(() {
      _subject = WalletApi(httpClient);
    });

    group('get wallet', () {
      test('get customer wallet success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/wallets/customer/response/200.json');

        final response = await _subject.getWallet();

        expect(response.balance.displayValueWithSymbol,
            TestConstants.stubTokenCurrency.displayValueWithSymbol);
        expect(response.balance.value, TestConstants.stubTokenCurrency.value);
        expect(response.balance.assetSymbol,
            TestConstants.stubTokenCurrency.assetSymbol);

        httpClient.assertGetRequest(path: '/wallets/customer');
      });

      test('get customer wallet error - 401 unauthorized', () async {
        httpClient.mockResponse(null, statusCode: 401);

        await expectLater(
          () => _subject.getWallet(),
          throwsA(predicate((e) =>
              e is DioError &&
              e.type == DioErrorType.RESPONSE &&
              e.message == 'Http status error [401]')),
        );

        httpClient.assertGetRequest(path: '/wallets/customer');
      });
    });

    group('post transaction', () {
      test('post transaction success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/p2p_transactions/response/200.json');

        final response = await _subject.postTransaction(
            P2pTransactionRequestModel(TestConstants.stubEmail,
                TestConstants.stubValidTransactionAmount));

        expect(response.transactionId, TestConstants.stubTransactionId);

        httpClient.assertPostRequest(path: '/wallets/transfer');
      });

      test('p2p transaction 400 target receiver not found', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/p2p_transactions/response/400_target_receiver_not_found.json',
            statusCode: 400);

        await expectLater(
            () => _subject.postTransaction(P2pTransactionRequestModel(
                TestConstants.stubEmail,
                TestConstants.stubValidTransactionAmount)),
            throwsA(
              const ServiceException(
                ServiceExceptionType.targetCustomerNotFound,
                message: 'The Receiver does not exist',
              ),
            ));

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/p2p_transactions/request/full.json',
          path: '/wallets/transfer',
        );
      });
    });

    group('post payment transfer', () {
      test('post payment transfer success 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/payment_transfer/response/200.json');

        await _subject.postPaymentTransfer(PaymentTransferRequestModel(
            campaignId: TestConstants.stubCampaignId,
            invoiceId: TestConstants.stubInvoiceId,
            amount: TestConstants.stubValidTransactionAmount));

        httpClient.assertPostRequest(path: '/wallets/payment-transfer');
      });
    });

    group('unlink external wallet', () {
      test('unlink current external - wallet success', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/wallets/link_request/response/delete/200.json');

        await _subject.unlinkExternalWallet();

        httpClient.assertDeleteRequest(path: '/wallets/linkRequest');
      });

      test('unlink current external wallet - bad request', () async {
        httpClient.mockResponseFromFile(
          'test_resources/mock_data/wallets/link_request/response/delete/400.json',
          statusCode: 400,
        );

        await expectLater(
            () => _subject.unlinkExternalWallet(),
            throwsA(
              const ServiceException(
                ServiceExceptionType.linkingRequestDoesNotExist,
                message: 'The wallet linking request does not exist',
              ),
            ));

        httpClient.assertDeleteRequest(path: '/wallets/linkRequest');
      });
    });
  });
}
