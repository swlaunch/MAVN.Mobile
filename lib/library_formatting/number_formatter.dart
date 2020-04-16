import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class NumberFormatter {
  //todo: use the user's locale for number formatting. This is currently fixed
  // to support the backend returning number strings in a en_US format.
  static const locale = 'en_US';

  // formatting fiat currency
  static String toFormattedStringFromDouble(double amount) {
    if (amount == null) {
      return '-';
    }
    return _toDelimitedString(_to2decimalPlaces(amount));
  }

  static double _to2decimalPlaces(double amount) =>
      (amount * 100).floorToDouble() / 100;

  static String _toDelimitedString(double amount) =>
      NumberFormat('#,##0.00', locale).format(amount);

  // formatting token
  static String toCommaSeparatedStringFromDecimal(Decimal amount) {
    if (amount == null) {
      return '-';
    }

    final integerParts = amount.toString().split('.');

    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';

    final integerResult =
        integerParts.removeAt(0).replaceAllMapped(reg, mathFunc);

    return [integerResult, ...integerParts].join('.');
  }

  //TODO : Find a way of replacing the separator for locales that do not use a
  // comma separator.
  static Decimal tryParseDecimal(String value) =>
      Decimal.tryParse(value.replaceAll(',', ''));

  static double tryParseDouble(String value) {
    if (value == null) {
      // ignore: avoid_returning_null
      return null;
    }
    return double.tryParse(value.replaceAll(',', ''));
  }

  ///
  /// Removes the zeros and decimal dot at the end of the String,
  /// or returns the String itself in case this does not apply to it
  ///
  static String trimDecimalZeros(String s) {
    final parts = s.split('.');
    final fractionPart =
        parts.isNotEmpty && parts.length == 2 ? parts[1] : null;
    if (fractionPart == null) {
      return s;
    }

    if (fractionPart.replaceAll('0', '') == '') {
      return parts.first;
    }
    return s;
  }

  static String toPercentStringFromDouble(double num) {
    final formattedNumber = trimDecimalZeros(num.toString());

    return '$formattedNumber%';
  }

  /// Split the given [formattedAmount], as '.' is used for a decimal delimiter.
  /// Example: '12,123.000' will be split to Tuple2('12,123, '000')
  static Tuple2<String, String> splitFormattedAmountToFractions(
      String formattedAmount) {
    if (formattedAmount == null) {
      return const Tuple2(null, null);
    }

    final fractions = formattedAmount.split('.');

    if (fractions.isEmpty) {
      return const Tuple2(null, null);
    }

    if (fractions.length == 1) {
      return Tuple2(fractions.first, null);
    }

    return Tuple2(fractions[0], fractions[1]);
  }
}
