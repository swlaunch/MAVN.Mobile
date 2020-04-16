import 'package:decimal/decimal.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Number formatter tests', () {
    test('toTokenCurrencyString', () async {
      [
        [12.3456, '12.34'],
        [10.0, '10.00'],
        [10.1234, '10.12'],
        [10555.3456, '10,555.34'],
        [10111555.3456, '10,111,555.34'],
        [0.0, '0.00'],
        [0.0001, '0.00'],
        [0.0012, '0.00'],
        [0.0123, '0.01'],
        [0.1234, '0.12'],
        [1.2345, '1.23'],
        [1.0, '1.00'],
        [123.0, '123.00'],
        [123.4, '123.40'],
        [123.4567, '123.45'],
        [null, '-']
      ].forEach((values) => expect(
            NumberFormatter.toFormattedStringFromDouble(values[0]),
            values[1],
          ));
    });

    test('toFormattedStringFromDecimal', () async {
      [
        ['12.345678901234567890123456789', '12.345678901234567890123456789'],
        [
          '1234.345678901234567890123456789',
          '1,234.345678901234567890123456789'
        ],
        ['1234', '1,234'],
        ['-12.345678901234567890123456789', '-12.345678901234567890123456789'],
        [
          '-1234.345678901234567890123456789',
          '-1,234.345678901234567890123456789'
        ],
        ['-1234', '-1,234'],
        ['0', '0'],
      ].forEach((values) {
        final decimal = Decimal.parse(values[0]);
        expect(
          NumberFormatter.toCommaSeparatedStringFromDecimal(decimal),
          values[1],
        );
      });
    });

    test('tryParseDouble', () async {
      [
        ['12.34567', 12.34567],
        ['12,3456.7', 123456.7],
        [null, null],
        ['abc', null],
      ].forEach((values) {
        expect(
          NumberFormatter.tryParseDouble(values[0]),
          values[1],
        );
      });
    });

    test('toPercentStringFromDouble', () async {
      [
        [12.34567, '12.34567%'],
        [12.345, '12.345%'],
        [12.34, '12.34%'],
        [12.000, '12%'],
        [12.100, '12.1%'],
        [12.00, '12%'],
        [12.0, '12%'],
        [12.toDouble(), '12%'],
      ].forEach((values) {
        expect(
          NumberFormatter.toPercentStringFromDouble(values[0]),
          values[1],
        );
      });
    });

    test('splitFormattedAmountToFractions', () async {
      [
        ['12.3456', const Tuple2('12', '3456')],
        ['12.34', const Tuple2('12', '34')],
        ['12.3', const Tuple2('12', '3')],
        ['12', const Tuple2('12', null)],
        ['', const Tuple2('', null)],
        ['12,12', const Tuple2('12,12', null)],
        ['12,12.000', const Tuple2('12,12', '000')],
        [null, const Tuple2(null, null)],
        ['test', const Tuple2('test', null)],
      ].forEach((values) {
        expect(
          NumberFormatter.splitFormattedAmountToFractions(values[0]),
          values[1],
        );
      });
    });
  });
}
