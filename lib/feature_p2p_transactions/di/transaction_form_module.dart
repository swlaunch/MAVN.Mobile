import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/analytics/transaction_form_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TransactionFormModule extends Module {
  TransactionFormBloc get transactionFormBloc => get();

  TransactionFormAnalyticsManager get transactionFormAnalyticsManager => get();

  @override
  void provideInstances() {
    // AnalyticsManager
    provideSingleton(() => TransactionFormAnalyticsManager(get()));

    // Barcode Scan Manager
    provideSingleton(() => BarcodeScanManager());

    // Bloc
    provideSingleton(() => TransactionFormBloc(get(), get(), get(), get()));
  }
}
