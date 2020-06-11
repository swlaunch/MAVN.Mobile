import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';

class BaseCurrency {
  const BaseCurrency({
    @required this.value,
    @required this.assetSymbol,
  });

  final String value;
  final String assetSymbol;

  String get displayValueWithSymbol {
    if (value == null) {
      return '';
    }
    final asset = assetSymbol ?? '';
    return '$displayValueWithoutTrailingZeroes $asset';
  }

  String get displayValueWithoutTrailingZeroes {
    if (value == null) {
      return '';
    }
    return NumberFormatter.trimDecimalZeros(value);
  }

  Decimal get decimalValue {
    if (value == null) {
      return Decimal.fromInt(0);
    }

    return NumberFormatter.tryParseDecimal(value) ?? Decimal.zero;
  }

  double get doubleValue => NumberFormatter.tryParseDouble(value);

  String get nonCommaSeparatedValue {
    if (value == null) {
      return null;
    }

    return value.replaceAll(',', '');
  }
}
