import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_approved_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_rejected_request_model.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('PartnerRepository tests', () {
    final _mockPartnerApi = MockPartnerApi();
    final _subject = PartnerRepository(_mockPartnerApi);

    setUp(() {
      reset(_mockPartnerApi);
    });

    test('getPendingPayments', () {
      _subject.getPendingPayments(currentPage: TestConstants.stubCurrentPage);

      verify(_mockPartnerApi.getPendingPayments(
              TestConstants.stubPendingPageSize, TestConstants.stubCurrentPage))
          .called(1);
    });

    test('getCompletedPayments', () {
      _subject.getCompletedPayments(currentPage: TestConstants.stubCurrentPage);

      verify(_mockPartnerApi.getCompletedPayments(
              TestConstants.stubPageSize, TestConstants.stubCurrentPage))
          .called(1);
    });

    test('getFailedPayments', () {
      _subject.getFailedPayments(currentPage: TestConstants.stubCurrentPage);

      verify(_mockPartnerApi.getFailedPayments(
              TestConstants.stubPageSize, TestConstants.stubCurrentPage))
          .called(1);
    });

    test('get by id', () {
      _subject.getPaymentRequestDetails(TestConstants.stubPaymentRequestId);

      verify(_mockPartnerApi
              .getPaymentRequest(TestConstants.stubPaymentRequestId))
          .called(1);
    });

    test('approve payment request', () async {
      await _subject.approvePayment(
          paymentRequestId: TestConstants.stubPaymentRequestId,
          sendingAmount: TestConstants.stubPaymentRequestTotalInToken);

      final PaymentApprovedRequestModel capturedApprovalRequestModel =
          verify(_mockPartnerApi.approvePayment(captureAny)).captured[0];

      expect(capturedApprovalRequestModel.paymentRequestId,
          TestConstants.stubPaymentRequestId);
      expect(capturedApprovalRequestModel.sendingAmount,
          TestConstants.stubPaymentRequestTotalInToken);
    });

    test('reject payment request', () async {
      await _subject.rejectPayment(
        paymentRequestId: TestConstants.stubPaymentRequestId,
      );

      final PaymentRejectedRequestModel capturedRejectRequestModel =
          verify(_mockPartnerApi.rejectPayment(captureAny)).captured[0];

      expect(capturedRejectRequestModel.paymentRequestId,
          TestConstants.stubPaymentRequestId);
    });

    test('get partner message', () async {
      await _subject.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      );

      final String capturedPartnerMessageId =
          verify(_mockPartnerApi.getPartnerMessage(captureAny)).captured[0];

      expect(capturedPartnerMessageId, TestConstants.stubPartnerMessageId);
    });
  });
}
