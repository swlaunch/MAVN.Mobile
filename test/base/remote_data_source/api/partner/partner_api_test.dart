import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/partner_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_approved_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_rejected_request_model.dart';

import '../../../../helpers/mock_server_http_client.dart';
import '../../../../test_constants.dart';

PartnerApi _subject;

void main() {
  mockServerHttpClientTest('PartnerApi', (httpClient) {
    setUpAll(() {
      _subject = PartnerApi(httpClient);
    });

    group('pending payments', () {
      test('pending payment 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/partners/payments/response/pending.json');

        final response = await _subject.getPendingPayments(
            TestConstants.stubPageSize, TestConstants.stubCurrentPage);

        expect(response.pageSize, TestConstants.stubPageSize);
        expect(response.currentPage, TestConstants.stubCurrentPage);

        httpClient.assertGetRequest(
            path: PartnerApi.paymentsPathPending,
            queryParameters: {
              PartnerApi.paymentRequestListCurrentPage:
                  '${TestConstants.stubCurrentPage}',
              PartnerApi.paymentRequestListPageSize:
                  '${TestConstants.stubPageSize}',
            });
      });
    });

    test('completed requests 200', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/partners/payments/response/completed.json');

      final response = await _subject.getCompletedPayments(
          TestConstants.stubPageSize, TestConstants.stubCurrentPage);

      expect(response.pageSize, TestConstants.stubPageSize);
      expect(response.currentPage, TestConstants.stubCurrentPage);

      httpClient.assertGetRequest(
          path: PartnerApi.paymentsPathSucceeded,
          queryParameters: {
            PartnerApi.paymentRequestListCurrentPage:
                '${TestConstants.stubCurrentPage}',
            PartnerApi.paymentRequestListPageSize:
                '${TestConstants.stubPageSize}',
          });
    });

    test('failed requests 200', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/partners/payments/response/failed.json');

      final response = await _subject.getFailedPayments(
          TestConstants.stubPageSize, TestConstants.stubCurrentPage);

      expect(response.pageSize, TestConstants.stubPageSize);
      expect(response.currentPage, TestConstants.stubCurrentPage);

      httpClient.assertGetRequest(
          path: PartnerApi.paymentsPathFailed,
          queryParameters: {
            PartnerApi.paymentRequestListCurrentPage:
                '${TestConstants.stubCurrentPage}',
            PartnerApi.paymentRequestListPageSize:
                '${TestConstants.stubPageSize}',
          });
    });

    test('payment request 200', () async {
      httpClient.mockResponseFromFile(
          'test_resources/mock_data/partners/payments/response/by_id.json');

      final response =
          await _subject.getPaymentRequest(TestConstants.stubPaymentRequestId);

      expect(response.paymentRequestId, TestConstants.stubPaymentRequestId);

      httpClient
          .assertGetRequest(path: PartnerApi.paymentsPath, queryParameters: {
        PartnerApi.paymentRequestIdQueryParameterKey:
            '${TestConstants.stubPaymentRequestId}',
      });
    });

    group('approval', () {
      const _stubPaymentRequestApprovalModel = PaymentApprovedRequestModel(
        paymentRequestId: TestConstants.stubPaymentRequestId,
        sendingAmount: TestConstants.stubPaymentRequestTotalInToken,
      );

      test('approve transfer request - success 204', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/common/response/204.json');

        await _subject.approvePayment(_stubPaymentRequestApprovalModel);

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/partners/payments/request/approve_transfer_request.json',
          path: PartnerApi.paymentsPathApproval,
        );
      });
    });

    group('rejection', () {
      const _stubPaymentRequestRejectionModel = PaymentRejectedRequestModel(
        paymentRequestId: TestConstants.stubPaymentRequestId,
      );

      test('reject transfer request - success 204', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/common/response/204.json');

        await _subject.rejectPayment(_stubPaymentRequestRejectionModel);

        httpClient.assertPostRequestFromFile(
          'test_resources/mock_data/partners/payments/request/reject_transfer_request.json',
          path: PartnerApi.paymentsPathRejection,
        );
      });
    });

    group('partner messages', () {
      test('partner messages 200', () async {
        httpClient.mockResponseFromFile(
            'test_resources/mock_data/partners/messages/response/200.json');

        final response = await _subject
            .getPartnerMessage(TestConstants.stubPartnerMessageId);

        expect(response, TestConstants.stubPartnerMessage);

        httpClient.assertGetRequest(
            path: '${PartnerApi.messagesPath}',
            queryParameters: {
              PartnerApi.messageIdQueryParameterKey:
                  TestConstants.stubPartnerMessageId
            });
      });
    });
  });
}
