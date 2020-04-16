import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';

class PaginatedPartnerPaymentsResponseModel {
  PaginatedPartnerPaymentsResponseModel({
    this.currentPage,
    this.pageSize,
    this.totalCount,
    this.paymentRequests,
  });

  PaginatedPartnerPaymentsResponseModel.fromJson(Map<String, dynamic> json)
      : currentPage = json['CurrentPage'],
        pageSize = json['PageSize'],
        totalCount = json['TotalCount'],
        paymentRequests = _mapPaymentRequests(json['PaymentRequests']);

  final int currentPage;
  final int pageSize;
  final int totalCount;
  final List<PaymentRequestResponseModel> paymentRequests;
}

class PartnerPaymentsResponseModel {
  const PartnerPaymentsResponseModel({
    this.paymentRequests,
  });

  PartnerPaymentsResponseModel.fromJson(json)
      : paymentRequests = _mapPaymentRequests(json);

  final List<PaymentRequestResponseModel> paymentRequests;
}

List<PaymentRequestResponseModel> _mapPaymentRequests(List<dynamic> json) =>
    json.map((json) => PaymentRequestResponseModel.fromJson(json)).toList();
