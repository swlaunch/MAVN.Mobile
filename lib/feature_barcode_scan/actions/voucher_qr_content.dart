import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/qr_content.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';
import 'package:tuple/tuple.dart';

class VoucherQrContent extends QrContent {
  VoucherQrContent(String data) : super(data);

  static const partnerIdKey = 'PId=';
  static const shortCodeKey = 'SC=';

  @override
  List<Tuple2> decode() {
    try {
      if (StringUtils.isNullOrEmpty(data)) {
        return [];
      }

      final parts = data.split(QrContent.separator);

      if (parts.isEmpty || parts.length < 2) {
        return [];
      }
      final startIndexPartnerId = parts[0]?.indexOf(QrContent.valueStart);
      final partnerId = parts?.first?.substring(
          startIndexPartnerId + QrContent.valueStart.length,
          parts?.first?.length);

      final startIndexVoucherCode = parts[1]?.indexOf(QrContent.valueStart);
      final endIndexVoucherCode = parts[1].length;

      final voucherCode = parts[1].substring(
          startIndexVoucherCode + QrContent.valueStart.length,
          endIndexVoucherCode);

      return [
        Tuple2(partnerIdKey, partnerId),
        Tuple2(shortCodeKey, voucherCode),
      ];
    } on Exception catch (_) {
      return [];
    }
  }
}
