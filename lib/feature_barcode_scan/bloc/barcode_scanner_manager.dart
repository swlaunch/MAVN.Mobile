import 'package:barcode_scan/barcode_scan.dart';

class BarcodeScanManager {
  Future<String> startScan() => BarcodeScanner.scan();
}
