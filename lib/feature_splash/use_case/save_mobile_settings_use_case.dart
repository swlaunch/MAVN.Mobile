import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/mobile/mobile_repository.dart';

class SaveMobileSettingsUseCase {
  SaveMobileSettingsUseCase(
    this._mobileSettingsRepository,
    this._localSettingsRepository,
  );

  final MobileSettingsRepository _mobileSettingsRepository;
  final LocalSettingsRepository _localSettingsRepository;

  Future<void> execute() async {
    final _mobileSettingsResponse =
        await _mobileSettingsRepository.getSettings();
    await _localSettingsRepository.storeMobileSettings(_mobileSettingsResponse);
  }
}
