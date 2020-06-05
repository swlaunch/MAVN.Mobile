import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({@required this.price});

  final FiatCurrency price;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: ColorStyles.resolutionBlue,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.all(4),
        width: 70,
        child: Text(
          '${price?.assetSymbol} ${price?.displayValueWithoutTrailingZeroes}',
          style: TextStyles.lightBodyBody3Regular,
        ),
      );
}
