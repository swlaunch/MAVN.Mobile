import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/initials_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/circular_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';

class VoucherTopSection extends HookWidget {
  VoucherTopSection({
    @required this.vendor,
    @required this.offerName,
    @required this.expirationDate,
  });

  final String vendor;
  final String offerName;
  final DateTime expirationDate;
  final DateFormat _dateFormatCurrentYear = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final expirationDateText = expirationDate != null
        ? localizedStrings
            .offerExpiresOn(_dateFormatCurrentYear.format(expirationDate))
        : localizedStrings.offerNoExpirationDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: NullSafeText(
            localizedStrings.availableAt(vendor),
            style: TextStyles.darkBodyBody2Black
                .copyWith(color: ColorStyles.shamrock),
          ),
        ),
        Row(
          children: <Widget>[
            CircularWidget(
              size: 60,
              child: InitialsWidget(
                initialsText: vendor,
                color: ColorStyles.resolutionBlue,
                textColor: ColorStyles.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NullSafeText(
                  offerName,
                  style: TextStyles.darkHeadersH3,
                ),
                const SizedBox(height: 8),
                NullSafeText(
                  expirationDateText,
                  style: TextStyles.darkBodyBody3Regular,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
