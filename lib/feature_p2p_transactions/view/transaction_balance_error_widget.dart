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
              LocalizedStrings.of(context).couldNotLoadBalanceError,
              style: TextStyles.darkBodyBody1Bold,
            ),
            const SizedBox(height: 24),
            _buildRetryButton(context),
          ],
        ),
      );

  Widget _buildRetryButton(BuildContext context) => Container(
        width: double.infinity,
        height: 48,
        child: RaisedButton(
          key: const Key('balanceErrorRetryButton'),
          child: Text(LocalizedStrings.of(context).retryButton,
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
