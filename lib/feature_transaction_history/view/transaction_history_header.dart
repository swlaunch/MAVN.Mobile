import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_item.dart';

class TransactionHeaderItem extends TransactionItem {
  TransactionHeaderItem({@required this.text, @required this.amount});

  final String text;
  final String amount;
}

class TransactionHistoryHeader extends StatelessWidget {
  const TransactionHistoryHeader({
    @required this.item,
    @required this.theme,
    Key key,
  }) : super(key: key);

  final TransactionHeaderItem item;
  final BaseAppTheme theme;
  @override
  Widget build(BuildContext context) => Container(
        color: theme.appBackground,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              item.text,
              style: TextStyles.darkBodyBody4Regular,
            ),
            Text(
              item.amount,
              style: TextStyles.darkBodyBody4Regular,
            ),
          ],
        ),
      );
}
