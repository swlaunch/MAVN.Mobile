import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/request_model/cancel_voucher_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/response_model/voucher_purchase_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/request_model/voucher_transfer_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class VoucherApi extends BaseApi {
  VoucherApi(HttpClient httpClient) : super(httpClient);

  static const String vouchersPath = '/smartVouchers';
  static const String voucherDetailsPath = '$vouchersPath/voucherShortCode';
  static const String paymentUrl = '$vouchersPath/paymentUrl';
  static const String cancelVoucherPath = '$vouchersPath/cancelReservation';
  static const String transfer = '$vouchersPath/transfer';

  //query params
  static const String queryParamCurrentPage = 'CurrentPage';
  static const String queryParamPageSize = 'PageSize';
  static const String queryParamVoucherShortCode = 'voucherShortCode';
  static const String queryParamShortCode = 'shortCode';

  Future<VoucherListResponseModel> getVouchers(
    int pageSize,
    int currentPage,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient
            .get<Map<String, dynamic>>(vouchersPath, queryParameters: {
          queryParamCurrentPage: currentPage,
          queryParamPageSize: pageSize,
        });
        return VoucherListResponseModel.fromJson(response.data);
      });

  Future<VoucherDetailsResponseModel> getVoucherDetailsByShortCode(
          String shortCode) async =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient
            .get<Map<String, dynamic>>(voucherDetailsPath, queryParameters: {
          queryParamVoucherShortCode: shortCode,
        });
        return VoucherDetailsResponseModel.fromJson(response.data);
      });

  Future<VoucherPurchaseResponseModel> getPaymentUrl(String shortCode) async =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient
            .get<Map<String, dynamic>>(paymentUrl, queryParameters: {
          queryParamShortCode: shortCode,
        });
        return VoucherPurchaseResponseModel.fromJson(response.data);
      });

  Future<void> cancelVoucher(
    CancelVoucherRequestModel model,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post(
          cancelVoucherPath,
          data: model.toJson(),
        );
      });

  Future<void> transferVoucher(
    VoucherTransferRequestModel model,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post(
          transfer,
          data: model.toJson(),
        );
      });
}
