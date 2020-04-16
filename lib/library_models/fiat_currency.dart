import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/library_models/base_currency.dart';

class FiatCurrency extends BaseCurrency {
  FiatCurrency({
    @required double value,
    @required String assetSymbol,
  }) : super(
          value: value?.toString(),
          assetSymbol: assetSymbol,
        );

  String get withoutTrailingZeroesWithAsset {
    if (value == null) {
      return '';
    }
    return '$displayValueWithoutTrailingZeroes $assetSymbol';
  }
}
