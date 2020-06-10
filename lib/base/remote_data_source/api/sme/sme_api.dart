import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/request_model/invalidate_voucher_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/request_model/sme_linking_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class SmeApi extends BaseApi {
  SmeApi(HttpClient httpClient) : super(httpClient);

  static const String partnerLinking = '/partnersLinking';
  static const String voucherUsage = '/smartVouchers/usage';

  Future<void> linkSmeAccount(SmeLinkingRequestModel smeLinkingRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          partnerLinking,
          data: smeLinkingRequestModel.toJson(),
        );
      });

  Future<void> invalidateVoucher(
          InvalidateVoucherRequestModel invalidateVoucherRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          voucherUsage,
          data: invalidateVoucherRequestModel.toJson(),
        );
      });
}
