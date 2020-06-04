import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/scan_barcode_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class BarcodeScanModule extends Module {
  BarcodeScanBloc get barcodeScanBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => BarcodeScanManager());

    provideSingleton(() => BarcodeScanBloc(get()));
  }
}
