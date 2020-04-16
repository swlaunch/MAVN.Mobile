import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/response_model/mobile_settings_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class GetMobileSettingsUseCase {
  GetMobileSettingsUseCase(this._localSettingsRepository);

  final LocalSettingsRepository _localSettingsRepository;

  MobileSettings execute() => _localSettingsRepository.getMobileSettings();
}

GetMobileSettingsUseCase useGetMobileSettingsUseCase(BuildContext context) =>
    ModuleProvider.of<AppModule>(context).getMobileSettingsUseCase;
