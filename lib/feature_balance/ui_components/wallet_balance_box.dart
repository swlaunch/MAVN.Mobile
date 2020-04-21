import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

import 'balance_text.dart';

class WalletBalanceBox extends StatelessWidget {
  const WalletBalanceBox({
    @required this.balance,
    @required this.tokenSymbol,
    @required this.title,
    @required this.isLoading,
    @required this.theme,
    this.balanceInBaseCurrency,
    this.baseCurrencyCode,
  });

  final String balance;
  final String tokenSymbol;
  final String balanceInBaseCurrency;
  final String baseCurrencyCode;
  final String title;
  final bool isLoading;
  final BaseAppTheme theme;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.walletBoxGradientTop,
              theme.walletBoxGradientBottom,
            ],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: 140,
        child: isLoading
            ? const Spinner()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      StandardSizedSvg(SvgAssets.tokenLight,
                          color: ColorStyles.white),
                      const SizedBox(width: 4),
                      BalanceText(amount: balance),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (balanceInBaseCurrency != null)
                    _buildConversionRate(
                      context,
                      balanceInBaseCurrency,
                      baseCurrencyCode,
                      tokenSymbol,
                    ),
                ],
              ),
      );

  Widget _buildConversionRate(BuildContext context, String currencyCode,
      String amount, String tokenSymbol) {
    final decimalBalance = Decimal.tryParse(amount);
    final conversionText = decimalBalance != null &&
            decimalBalance.ceilToDouble() == 0
        ? LocalizedStrings.of(context).noTokensConversionRateText(tokenSymbol)
        : LocalizedStrings.of(context).conversionRate(currencyCode, amount);
    return NullSafeText(
      conversionText,
      style: TextStyles.balanceConversionText,
    );
  }
}
