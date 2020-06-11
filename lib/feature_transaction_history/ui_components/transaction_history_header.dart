import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_item.dart';

class TransactionHeader extends TransactionItem {
  TransactionHeader({@required this.text});

  final String text;
}

class TransactionHistoryHeaderWidget extends StatelessWidget {
  const TransactionHistoryHeaderWidget({
    @required this.item,
    Key key,
  }) : super(key: key);

  final TransactionHeader item;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(
          item.text,
          style: TextStyles.transactionHistoryHeader,
        ),
      );
}
