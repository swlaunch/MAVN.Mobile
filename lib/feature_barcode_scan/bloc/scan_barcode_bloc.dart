import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/scan_barcode_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/di/barcode_scan_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class BarcodeScanBloc extends Bloc<BarcodeScanState> {
  BarcodeScanBloc(this._barcodeScanManager);

  final BarcodeScanManager _barcodeScanManager;

  @override
  BarcodeScanState initialState() => BarcodeScanUninitializedState();

  Future<void> startScan() async {
    setState(BarcodeScanUninitializedState());
    try {
      final scanResult = await _barcodeScanManager.startScan();
      final barcode = scanResult;
      sendEvent(BarcodeScanSuccessEvent(barcode));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(BarcodeScanPermissionErrorState(
            LazyLocalizedStrings.barcodeScanPermissionError));
      } else {
        setState(BarcodeScanErrorState(LazyLocalizedStrings.barcodeScanError));
      }
    } on FormatException {
      // back button case, should be ignored in the flow
    } catch (e) {
      setState(BarcodeScanErrorState(LazyLocalizedStrings.barcodeScanError));
    }
  }
}

BarcodeScanBloc useBarcodeScanBloc() =>
    ModuleProvider.of<BarcodeScanModule>(useContext()).barcodeScanBloc;
