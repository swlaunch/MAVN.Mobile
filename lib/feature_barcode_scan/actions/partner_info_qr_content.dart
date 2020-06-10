import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/qr_content.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';
import 'package:tuple/tuple.dart';

class PartnerInfoQrContent extends QrContent {
  PartnerInfoQrContent(String data) : super(data);

  static const partnerCodeKey = 'PartnerCode';
  static const linkingCodeKey = 'LinkingCode';

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
      final startIndexPartnerCode = parts[0]?.indexOf(QrContent.valueStart);
      final partnerCode = parts?.first?.substring(
          startIndexPartnerCode + QrContent.valueStart.length,
          parts?.first?.length);

      final startIndexLinkCode = parts[1]?.indexOf(QrContent.valueStart);
      final endIndexLinkCode = parts[1].length;

      final linkingCode = parts[1].substring(
          startIndexLinkCode + QrContent.valueStart.length, endIndexLinkCode);

      return [
        Tuple2(partnerCodeKey, partnerCode),
        Tuple2(linkingCodeKey, linkingCode),
      ];
    } on Exception catch (_) {
      return [];
    }
  }
}
