import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/analytics/transaction_form_analytics_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

AnalyticsService _mockAnalyticsService = MockAnalyticsService();

TransactionFormAnalyticsManager _subject =
    TransactionFormAnalyticsManager(_mockAnalyticsService);

AnalyticsEvent _capturedAnalyticsEvent;

const String transferTokensFeature = 'transfer_tokens';

void main() {
  group('TransactionFormAnalyticsManager tests', () {
    test('transferFormStarted', () async {
      await _subject.transferFormStarted();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'transfer_form_started');
      expect(_capturedAnalyticsEvent.feature, transferTokensFeature);
    });

    test('transferFormScanQrCodeTap', () async {
      await _subject.transferFormScanQrCodeTap();

      _thenAnalyticsServiceCalled();

      expect(
          _capturedAnalyticsEvent.eventName, 'transfer_form_scan_qr_code_tap');
      expect(_capturedAnalyticsEvent.feature, transferTokensFeature);
    });

    test('transferFormSubmit', () async {
      await _subject.transferFormSubmit();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'transfer_form_submit');
      expect(_capturedAnalyticsEvent.feature, transferTokensFeature);
    });

    test('Transaction finished successfully', () async {
      await _subject.transactionDone();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'transfer_api_success');
      expect(_capturedAnalyticsEvent.feature, transferTokensFeature);
    });

    test('Transaction finished failed', () async {
      await _subject.transactionFailed();

      _thenAnalyticsServiceCalled();

      expect(_capturedAnalyticsEvent.eventName, 'transfer_api_failed');
      expect(_capturedAnalyticsEvent.feature, transferTokensFeature);
    });
  });
}

/// THEN ///

void _thenAnalyticsServiceCalled() {
  final verificationResult = verify(_mockAnalyticsService.logEvent(
      analyticsEvent: captureAnyNamed('analyticsEvent')));
  expect(verificationResult.callCount, 1);
  _capturedAnalyticsEvent = verificationResult.captured[0] as AnalyticsEvent;
}
