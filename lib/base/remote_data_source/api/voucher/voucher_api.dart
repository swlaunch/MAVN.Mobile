import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class VoucherApi extends BaseApi {
  VoucherApi(HttpClient httpClient) : super(httpClient);

  static const String vouchersPath = '/smartVouchers';
  static const String voucherDetailsPath = '$vouchersPath/voucherShortCode';

  //query params
  static const String queryParamCurrentPage = 'CurrentPage';
  static const String queryParamPageSize = 'PageSize';
  static const String queryParamShortCode = 'voucherShortCode';

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
    String shortCode,
  ) async =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient
            .get<Map<String, dynamic>>(voucherDetailsPath, queryParameters: {
          queryParamShortCode: shortCode,
        });
        return VoucherDetailsResponseModel.fromJson(response.data);
      });
}
