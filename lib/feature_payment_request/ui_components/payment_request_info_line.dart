import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class PaymentRequestInfoLine extends StatelessWidget {
  const PaymentRequestInfoLine({this.pairKey, this.pairValue});

  final String pairKey;
  final String pairValue;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pairKey?.toUpperCase() ?? '',
                style: TextStyles.darkInputLabelBold.copyWith(
                    color: ColorStyles.charcoalGrey.withOpacity(0.6))),
            const SizedBox(height: 4),
            Text(pairValue ?? '', style: TextStyles.darkBodyBody1Bold),
          ],
        ),
      );
}
