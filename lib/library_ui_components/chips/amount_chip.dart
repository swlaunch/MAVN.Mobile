import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/chips/generic_chip.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';

class AmountChip extends StatelessWidget {
  const AmountChip({
    @required this.amount,
    @required this.showAsterisk,
    this.textStyle = TextStyles.darkHeadersH2,
    Key key,
  }) : super(key: key);
  final bool showAsterisk;
  final String amount;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => GenericChip(
        chipContentWidget: _buildChipContent(
          amount: amount,
          showAsterisk: showAsterisk,
          textStyle: textStyle,
        ),
      );

  Widget _buildChipContent({
    @required String amount,
    @required bool showAsterisk,
    TextStyle textStyle,
  }) {
    if (amount == null) {
      return null;
    }
    return TokenAmountWithIcon(
      NumberFormatter.trimDecimalZeros(amount),
      textStyle: textStyle,
      showAsterisk: showAsterisk,
    );
  }
}
