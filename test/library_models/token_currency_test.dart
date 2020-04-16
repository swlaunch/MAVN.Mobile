import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:test/test.dart';

void main() {
  group('Number formatter tests', () {
    test('toStringWithSymbol', () async {
      expect(
        const TokenCurrency(value: '123.654', assetSymbol: 'ABC')
            .displayValueWithSymbol,
        '123.654 ABC',
      );
    });
  });
}
