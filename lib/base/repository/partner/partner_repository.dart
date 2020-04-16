import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/partner_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_approved_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_rejected_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/partner_message_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payments_response_model.dart';

class PartnerRepository {
  PartnerRepository(this._partnerApi);

  static const itemsPerPage = 30;
  static const itemsPerPagePending = 10;

  final PartnerApi _partnerApi;

  Future<PaginatedPartnerPaymentsResponseModel> getPendingPayments(
          {int currentPage}) =>
      _partnerApi.getPendingPayments(itemsPerPagePending, currentPage);

  Future<PaginatedPartnerPaymentsResponseModel> getCompletedPayments(
          {int currentPage}) =>
      _partnerApi.getCompletedPayments(itemsPerPage, currentPage);

  Future<PaginatedPartnerPaymentsResponseModel> getFailedPayments(
          {int currentPage}) =>
      _partnerApi.getFailedPayments(itemsPerPage, currentPage);

  Future<PaymentRequestResponseModel> getPaymentRequestDetails(
          String paymentRequestId) =>
      _partnerApi.getPaymentRequest(paymentRequestId);

  Future<void> approvePayment(
          {String paymentRequestId, String sendingAmount}) =>
      _partnerApi.approvePayment(PaymentApprovedRequestModel(
          paymentRequestId: paymentRequestId, sendingAmount: sendingAmount));

  Future<void> rejectPayment({String paymentRequestId}) =>
      _partnerApi.rejectPayment(
          PaymentRejectedRequestModel(paymentRequestId: paymentRequestId));

  Future<PartnerMessageResponseModel> getPartnerMessage(
          String partnerMessageId) =>
      _partnerApi.getPartnerMessage(partnerMessageId);
}
