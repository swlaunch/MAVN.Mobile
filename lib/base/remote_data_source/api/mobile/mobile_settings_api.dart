import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/response_model/mobile_settings_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class MobileSettingsApi extends BaseApi {
  MobileSettingsApi(HttpClient httpClient) : super(httpClient);

  static const String getMobileSettingsPath = '/mobile/settings';

  Future<MobileSettings> getSettings() =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<dynamic>(getMobileSettingsPath);
        return MobileSettings.fromJson(response.data);
      });
}
