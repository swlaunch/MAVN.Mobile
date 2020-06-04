import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class QrContent {
  QrContent(this.data);

  final String data;
}

extension SmeLinkingValues on QrContent {
  List<String> parseCodes() {
    try {
      if (StringUtils.isNullOrEmpty(data)) {
        return [];
      }
      const codeStart = '=';
      const splitCharacter = '&';

      final parts = data.split(splitCharacter);

      if (parts.isEmpty || parts.length < 2) {
        return [];
      }
      final startIndexPartnerCode = parts[0]?.indexOf(codeStart);
      final partnerCode = parts?.first?.substring(
          startIndexPartnerCode + codeStart.length, parts?.first?.length);

      final startIndexLinkCode = parts[1]?.indexOf(codeStart);
      final endIndexLinkCode = parts[1].length;

      final linkingCode = parts[1]
          .substring(startIndexLinkCode + codeStart.length, endIndexLinkCode);
      return [
        partnerCode,
        linkingCode,
      ];
    } on Exception catch (_) {
      return [];
    }
  }
}
