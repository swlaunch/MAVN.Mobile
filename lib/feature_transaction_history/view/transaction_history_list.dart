import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/transaction_history_mapper.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_header.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_item.dart';

class TransactionHistoryViewList extends HookWidget {
  const TransactionHistoryViewList({
    @required this.theme,
    this.transactionList = const [],
    Key key,
  }) : super(key: key);
  final BaseAppTheme theme;

  final List<Transaction> transactionList;

  @override
  Widget build(BuildContext context) {
    final transactionMapper = useTransactionMapper();
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final items = transactionMapper.mapTransactions(
        transactionList, tokenSymbol.value, context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildList(listItems: items),
    );
  }

  List<Widget> _buildList({List<TransactionItem> listItems}) =>
      listItems.map((e) {
        if (e is TransactionHeaderItem) {
          return TransactionHistoryHeader(
            item: e,
            theme: theme,
          );
        } else if (e is TransactionListItem) {
          return TransactionHistoryViewListItem(
            transactionListItem: e,
            theme: theme,
          );
        }
      }).toList();
}
