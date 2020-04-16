import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_analytics.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

RemoteConfig _mockRemoteConfig;
AnalyticsService _mockAnalyticsService;
RemoteConfigManager subject;

void main() {
  group('RemoteConfigManager tests', () {
    setUp(() {
      _mockRemoteConfig = MockRemoteConfig();
      _mockAnalyticsService = MockAnalyticsService();
    });

    test('init, isReleaseMode = true', () async {
      subject = RemoteConfigManager(
        remoteConfig: _mockRemoteConfig,
        analyticsService: _mockAnalyticsService,
        isReleaseMode: true,
      );

      await subject.init();

      final setSettingsCall =
          verify(_mockRemoteConfig.setConfigSettings(captureAny));
      expect(setSettingsCall.callCount, 1);
      expect(
        (setSettingsCall.captured[0] as RemoteConfigSettings).debugMode,
        false,
      );

      final setDefaultsCall = verify(_mockRemoteConfig.setDefaults(captureAny));
      expect(setDefaultsCall.callCount, 1);
      final defaultsCapturedMap =
          setDefaultsCall.captured[0] as Map<String, dynamic>;
      expect(defaultsCapturedMap['is_policies_checkbox_above_button'], false);
    });

    test('init, isReleaseMode = false', () async {
      subject = RemoteConfigManager(
        remoteConfig: _mockRemoteConfig,
        analyticsService: _mockAnalyticsService,
        isReleaseMode: false,
      );

      await subject.init();

      final setSettingsCall =
          verify(_mockRemoteConfig.setConfigSettings(captureAny));
      expect(setSettingsCall.callCount, 1);
      expect(
        (setSettingsCall.captured[0] as RemoteConfigSettings).debugMode,
        true,
      );

      final setDefaultsCall = verify(_mockRemoteConfig.setDefaults(captureAny));
      expect(setDefaultsCall.callCount, 1);
      final defaultsCapturedMap =
          setDefaultsCall.captured[0] as Map<String, dynamic>;
      expect(defaultsCapturedMap['is_policies_checkbox_above_button'], false);
    });

    test('fetchNewRemoteConfig, isReleaseMode = true', () async {
      subject = RemoteConfigManager(
        remoteConfig: _mockRemoteConfig,
        analyticsService: _mockAnalyticsService,
        isReleaseMode: true,
      );

      when(_mockRemoteConfig.getBool('is_policies_checkbox_above_button'))
          .thenReturn(true);

      await subject.fetchNewRemoteConfig();

      verify(_mockRemoteConfig.fetch(expiration: const Duration(minutes: 15)))
          .called(1);
      verify(_mockRemoteConfig.activateFetched()).called(1);

      final analyticsLogCall = verify(_mockAnalyticsService.logEvent(
          analyticsEvent: captureAnyNamed('analyticsEvent')));
      expect(analyticsLogCall.callCount, 1);
      final capturedAnalyticsEvent = analyticsLogCall.captured[0]
          as RemoteConfigFetchSuccessAnalyticsEvent;
      expect(capturedAnalyticsEvent.success, true);
      expect(capturedAnalyticsEvent.eventName, 'remote_config_loaded');
      expect(capturedAnalyticsEvent.eventParametersMap, {
        'success': 1,
        'is_policies_checkbox_above_button': true,
      });
    });

    test('fetchNewRemoteConfig, isReleaseMode = false', () async {
      subject = RemoteConfigManager(
        remoteConfig: _mockRemoteConfig,
        analyticsService: _mockAnalyticsService,
        isReleaseMode: false,
      );

      when(_mockRemoteConfig.getBool('is_policies_checkbox_above_button'))
          .thenReturn(false);

      await subject.fetchNewRemoteConfig();

      verify(_mockRemoteConfig.fetch(expiration: Duration.zero)).called(1);
      verify(_mockRemoteConfig.activateFetched()).called(1);

      final analyticsLogCall = verify(_mockAnalyticsService.logEvent(
          analyticsEvent: captureAnyNamed('analyticsEvent')));
      expect(analyticsLogCall.callCount, 1);
      final capturedAnalyticsEvent = analyticsLogCall.captured[0]
          as RemoteConfigFetchSuccessAnalyticsEvent;
      expect(capturedAnalyticsEvent.eventName, 'remote_config_loaded');
      expect(capturedAnalyticsEvent.eventParametersMap, {
        'success': 1,
        'is_policies_checkbox_above_button': false,
      });
    });

    test('readBool', () async {
      subject = RemoteConfigManager(
        remoteConfig: _mockRemoteConfig,
        analyticsService: _mockAnalyticsService,
        isReleaseMode: true,
      );

      when(_mockRemoteConfig.getBool(TestConstants.stubKey)).thenReturn(true);
      expect(subject.readBool(TestConstants.stubKey), true);

      when(_mockRemoteConfig.getBool(TestConstants.stubKey)).thenReturn(false);
      expect(subject.readBool(TestConstants.stubKey), false);
    });
  });
}
