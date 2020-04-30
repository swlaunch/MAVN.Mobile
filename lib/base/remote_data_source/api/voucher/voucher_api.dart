import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class VoucherApi extends BaseApi {
  VoucherApi(HttpClient httpClient) : super(httpClient);

  static const String vouchersPath = '/smartVouchers/campaigns';
  static const String voucherDetailsPath = '/smartVouchers/campaigns/search';

  //query params
  static const String queryParamCurrentPage = 'CurrentPage';
  static const String queryParamPageSize = 'PageSize';
  static const String queryParamId = 'id';

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

  Future<VoucherResponseModel> getVoucherDetailsById(String id) async =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient
            .get<Map<String, dynamic>>(voucherDetailsPath, queryParameters: {
          queryParamId: id,
        });
        return VoucherResponseModel.fromJson(response.data);
      });
}
