import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/di/transaction_form_module.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TransactionFormAnalyticsManager {
  TransactionFormAnalyticsManager(this._analyticsService);

  final AnalyticsService _analyticsService;

  Future<void> transferFormStarted() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'transfer_form_started',
          feature: Feature.transferTokens,
        ),
      );

  Future<void> transferFormScanQrCodeTap() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'transfer_form_scan_qr_code_tap',
          feature: Feature.transferTokens,
        ),
      );

  Future<void> transferFormSubmit() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'transfer_form_submit',
          feature: Feature.transferTokens,
        ),
      );

  Future<void> transactionDone() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'transfer_api_success',
          feature: Feature.transferTokens,
          success: true,
        ),
      );

  Future<void> transactionFailed() => _analyticsService.logEvent(
        analyticsEvent: AnalyticsEvent(
          eventName: 'transfer_api_failed',
          feature: Feature.transferTokens,
          success: false,
        ),
      );
}

TransactionFormAnalyticsManager useTransactionFormAnalyticsManager() =>
    ModuleProvider.of<TransactionFormModule>(useContext())
        .transactionFormAnalyticsManager;
