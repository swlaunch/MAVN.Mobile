import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

void main() {
  group('Enum Mapper tests', () {
    test('mapping', () {
      final statusType = EnumMapper.mapFromString('pending',
          enumValues: WalletLinkingStatusType.values,
          defaultValue: WalletLinkingStatusType.notLinked);

      expect(WalletLinkingStatusType.pending, equals(statusType));
    });

    test('fallback to default', () {
      final statusType = EnumMapper.mapFromString('notAvailableType',
          enumValues: WalletLinkingStatusType.values,
          defaultValue: WalletLinkingStatusType.notLinked);

      expect(WalletLinkingStatusType.notLinked, equals(statusType));
    });
  });
}
