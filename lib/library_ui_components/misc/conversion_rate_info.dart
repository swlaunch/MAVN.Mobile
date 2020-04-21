import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';

class ConversionRateInfo extends HookWidget {
  const ConversionRateInfo({
    @required this.amountTextEditingController,
    @required this.rate,
    @required this.currencyName,
    this.buildSuffix,
  });

  final TextEditingController amountTextEditingController;
  final Decimal rate;
  final String currencyName;
  final String Function(Decimal) buildSuffix;

  String _buildConversionRateText(String tokenSymbol) {
    final parts = <String>[];

    if (rate == null) {
      return '';
    }

    final amount = amountTextEditingController?.text == null
        ? null
        : NumberFormatter.tryParseDecimal(amountTextEditingController.text);

    if (amount != null) {
      parts.add(useLocalizedStrings().currencyConversionLabel(
            NumberFormatter.toCommaSeparatedStringFromDecimal(amount),
            tokenSymbol,
            NumberFormatter.toCommaSeparatedStringFromDecimal(amount * rate),
            currencyName,
          ) +
          _buildSuffix(amount));
    }

    parts.add(useLocalizedStrings().currencyConversionLabel(
          '1',
          tokenSymbol,
          rate.toString(),
          currencyName,
        ) +
        _buildSuffix(amount));

    return parts.join(' | ');
  }

  String _buildSuffix(Decimal amount) =>
      buildSuffix == null ? '' : buildSuffix(amount);

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    useListenable(amountTextEditingController);

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _buildConversionRateText(tokenSymbol.value),
        style: TextStyles.darkBodyBody4Regular,
      ),
    );
  }
}
