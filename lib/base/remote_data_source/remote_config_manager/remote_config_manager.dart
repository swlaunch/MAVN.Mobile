import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_analytics.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_keys.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:meta/meta.dart';

class RemoteConfigManager {
  RemoteConfigManager({
    @required this.remoteConfig,
    @required this.analyticsService,
    this.isReleaseMode = true,
  });

  static const cacheDurationDebug = Duration.zero;
  static const cacheDurationRelease = Duration(minutes: 15);

  final RemoteConfig remoteConfig;
  final AnalyticsService analyticsService;
  final bool isReleaseMode;

  Future<void> init() async {
    await remoteConfig
        .setConfigSettings(RemoteConfigSettings(debugMode: !isReleaseMode));

    await remoteConfig.setDefaults(<String, dynamic>{
      RemoteConfigKeys.isPoliciesCheckboxAboveButton: false,
    });
  }

  Future<void> fetchNewRemoteConfig() async {
    try {
      await remoteConfig.fetch(
        expiration: isReleaseMode ? cacheDurationRelease : cacheDurationDebug,
      );

      await remoteConfig.activateFetched();

      await analyticsService.logEvent(
          analyticsEvent: RemoteConfigFetchSuccessAnalyticsEvent(remoteConfig));
    } on FetchThrottledException catch (_) {
      // Ignored for now
    } catch (exception) {
      // Ignored for now
    }
  }

  bool readBool(String key) => remoteConfig.getBool(key);
}

RemoteConfigManager useRemoteConfigManager() =>
    ModuleProvider.of<AppModule>(useContext()).remoteConfigManager;
