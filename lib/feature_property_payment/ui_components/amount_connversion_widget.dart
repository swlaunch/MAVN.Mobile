import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class AmountConversionWidget extends HookWidget {
  const AmountConversionWidget({
    @required this.amountTextEditingController,
    @required this.rate,
    @required this.currencyName,
  });

  final TextEditingController amountTextEditingController;
  final Decimal rate;
  final String currencyName;

  @override
  Widget build(BuildContext context) {
    useListenable(amountTextEditingController);

    return Text(
      _getConversionRateText(),
      style: TextStyles.darkBodyBody4Regular,
    );
  }

  String _getConversionRateText() {
    if (rate == null) {
      return '';
    }

    final amount = StringUtils.isNullOrWhitespace(
            amountTextEditingController?.text)
        ? Decimal.zero
        : NumberFormatter.tryParseDecimal(amountTextEditingController?.text);

    return useLocalizedStrings().propertyPaymentConversionHolder(
      NumberFormatter.toCommaSeparatedStringFromDecimal(
          (amount ?? Decimal.zero) * rate),
      currencyName,
    );
  }
}
