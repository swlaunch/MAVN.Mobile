import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/request_model/sme_linking_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class SmeApi extends BaseApi {
  SmeApi(HttpClient httpClient) : super(httpClient);

  static const String partnerLinking = '/partnersLinking';

  Future<void> linkSmeAccount(SmeLinkingRequestModel smeLinkingRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          partnerLinking,
          data: smeLinkingRequestModel.toJson(),
        );
      });
}
