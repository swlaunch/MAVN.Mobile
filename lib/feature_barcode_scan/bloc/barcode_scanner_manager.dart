import 'package:barcode_scan/barcode_scan.dart';

class BarcodeScanManager {
  Future<ScanResult> startScan() => BarcodeScanner.scan();
}
