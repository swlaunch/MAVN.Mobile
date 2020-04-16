import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';
import 'package:tuple/tuple.dart';

class BalanceText extends StatelessWidget {
  BalanceText({
    @required String amount,
    Key key,
  })  : _amountAsFractions =
            NumberFormatter.splitFormattedAmountToFractions(amount ?? ''),
        super(key: key);

  final Tuple2<String, String> _amountAsFractions;

  @override
  Widget build(BuildContext context) => AutoSizeText.rich(
        TextSpan(
          children: [
            TextSpan(text: _amountAsFractions.item1 ?? ''),
            if (!StringUtils.isNullOrEmpty(_amountAsFractions.item2))
              TextSpan(
                text: '.${_amountAsFractions.item2}',
                style: TextStyles.lightHeadersH2,
              ),
          ],
        ),
        key: const Key('balanceText'),
        style: TextStyles.lightHeadersH1,
        maxLines: 1,
      );
}
