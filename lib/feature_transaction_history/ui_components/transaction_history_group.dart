import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_item.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_list_item.dart';

class TransactionGroup extends TransactionItem {
  TransactionGroup(this.items);

  List<TransactionListItem> items;
}

class TransactionHistoryGroupWidget extends StatelessWidget {
  const TransactionHistoryGroupWidget({
    @required this.group,
    Key key,
  }) : super(key: key);

  final TransactionGroup group;
  static const _cardBorderRadius = 15.0;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.none,
        shadowColor: ColorStyles.cloudyBlue.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
        ),
        elevation: 5,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, position) => TransactionHistoryListItemWidget(
            transactionListItem: group.items[position],
          ),
          separatorBuilder: (context, position) =>
              Divider(color: ColorStyles.silver),
          itemCount: group.items.length,
        ),
      );
}
