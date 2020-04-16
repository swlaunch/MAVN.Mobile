import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_keys.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';

class RemoteConfigFetchSuccessAnalyticsEvent extends AnalyticsEvent {
  RemoteConfigFetchSuccessAnalyticsEvent(this._remoteConfig)
      : super(
          success: true,
          eventName: 'remote_config_loaded',
        );

  final RemoteConfig _remoteConfig;

  @override
  Map<String, dynamic> get eventParametersMap => super.eventParametersMap
    ..addAll({
      '${RemoteConfigKeys.isPoliciesCheckboxAboveButton}':
          _remoteConfig.getBool(RemoteConfigKeys.isPoliciesCheckboxAboveButton)
    });
}
