import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class TransactionBalanceErrorWidget extends StatelessWidget {
  const TransactionBalanceErrorWidget({this.onRetryTap});

  final VoidCallback onRetryTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
        child: Column(
          children: <Widget>[
            Text(
              LocalizedStrings.couldNotLoadBalanceError,
              style: TextStyles.darkBodyBody1Bold,
            ),
            const SizedBox(height: 24),
            _buildRetryButton(),
          ],
        ),
      );

  Widget _buildRetryButton() => Container(
        width: double.infinity,
        height: 48,
        child: RaisedButton(
          key: const Key('balanceErrorRetryButton'),
          child: Text(LocalizedStrings.retryButton,
              style: TextStyles.darkButtonExtraBold),
          onPressed: onRetryTap,
          color: ColorStyles.white,
          textColor: ColorStyles.primaryDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: ColorStyles.primaryDark)),
        ),
      );
}
