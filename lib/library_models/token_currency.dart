import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/library_models/base_currency.dart';

class TokenCurrency extends BaseCurrency {
  const TokenCurrency({
    @required String value,
    String assetSymbol,
  }) : super(
          value: value,
          assetSymbol: assetSymbol,
        );
}
