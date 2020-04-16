import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_approved_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/request_model/payment_rejected_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/partner_message_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payments_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class PartnerApi extends BaseApi {
  PartnerApi(HttpClient httpClient) : super(httpClient);

//region Paths
  static const String paymentsPath = '/partners/payments';
  static const String paymentsPathPending = '/partners/payments/pending';
  static const String paymentsPathSucceeded = '/partners/payments/succeeded';
  static const String paymentsPathFailed = '/partners/payments/failed';
  static const String paymentsPathApproval = '/partners/payments/approval';
  static const String paymentsPathRejection = '/partners/payments/rejection';
  static const String messagesPath = '/partners/messages';

//endregion
//region Query parameters
  static const String paymentRequestIdQueryParameterKey = 'PaymentRequestId';
  static const String paymentRequestListCurrentPage = 'CurrentPage';
  static const String paymentRequestListPageSize = 'PageSize';
  static const String messageIdQueryParameterKey = 'partnerMessageId';

//endregion
  Future<PaginatedPartnerPaymentsResponseModel> getPendingPayments(
          int pageSize, int currentPage) =>
      _getPaginatedPartnerPayments(pageSize, currentPage, paymentsPathPending);

  Future<PaginatedPartnerPaymentsResponseModel> getCompletedPayments(
          int pageSize, int currentPage) =>
      _getPaginatedPartnerPayments(
          pageSize, currentPage, paymentsPathSucceeded);

  Future<PaginatedPartnerPaymentsResponseModel> getFailedPayments(
          int pageSize, int currentPage) =>
      _getPaginatedPartnerPayments(pageSize, currentPage, paymentsPathFailed);

  Future<PaymentRequestResponseModel> getPaymentRequest(
          String paymentRequestId) =>
      exceptionHandledHttpClientRequest(() async {
        final paymentResponse = await httpClient.get(paymentsPath,
            queryParameters: {
              paymentRequestIdQueryParameterKey: paymentRequestId
            });

        return PaymentRequestResponseModel.fromJson(paymentResponse.data);
      });

  Future<void> approvePayment(
          PaymentApprovedRequestModel paymentApprovedRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          paymentsPathApproval,
          data: paymentApprovedRequestModel.toJson(),
        );
      });

  Future<void> rejectPayment(
          PaymentRejectedRequestModel paymentRejectedRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          paymentsPathRejection,
          data: paymentRejectedRequestModel.toJson(),
        );
      });

  Future<PaginatedPartnerPaymentsResponseModel> _getPaginatedPartnerPayments(
          int pageSize, int currentPage, String path) =>
      exceptionHandledHttpClientRequest(() async {
        final paymentsResponse = await httpClient.get(path, queryParameters: {
          paymentRequestListCurrentPage: currentPage,
          paymentRequestListPageSize: pageSize,
        });

        return PaginatedPartnerPaymentsResponseModel.fromJson(
            paymentsResponse.data);
      });

  Future<PartnerMessageResponseModel> getPartnerMessage(
    String partnerMessageId,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        final messageResponse = await httpClient.get<dynamic>(messagesPath,
            queryParameters: {messageIdQueryParameterKey: partnerMessageId});

        return PartnerMessageResponseModel.fromJson(messageResponse.data);
      });
}
