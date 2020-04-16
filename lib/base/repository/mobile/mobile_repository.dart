import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/mobile_settings_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/response_model/mobile_settings_response_model.dart';

class MobileSettingsRepository {
  MobileSettingsRepository(this._mobileApi);

  final MobileSettingsApi _mobileApi;

  Future<MobileSettings> getSettings() => _mobileApi.getSettings();
}
