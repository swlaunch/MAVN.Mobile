import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_group.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_header.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_item.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_list_item.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/date_time_utils.dart';

class TransactionHistoryMapper {
  static final DateFormat _dateFormatCurrentYearHeader = DateFormat('d MMMM');
  static final DateFormat _dateFormatOtherYearHeader =
      DateFormat('d MMMM, yyyy');

  static final DateFormat _dateFormatTime = DateFormat('h:mm a');

  ///Returns a list of items for the list (transactions and headers)
  List<TransactionItem> mapTransactions(
    List<Transaction> transactions,
    BuildContext context,
  ) {
    DateTime groupDate;
    final transactionItems = <TransactionItem>[];
    final mappedTransactions = <TransactionListItem>[];
    for (var i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];

      if (transaction.type == null) {
        continue;
      }

      final transactionDateTime =
          DateTime.parse(transactions[i].date).toLocal();

      if (groupDate == null ||
          !DateTimeUtils.isSameDate(groupDate, transactionDateTime)) {
        groupDate = transactionDateTime;
        final transactionsForGroup =
            List<TransactionListItem>.from(mappedTransactions);
        if (transactionsForGroup.isNotEmpty) {
          transactionItems.add(TransactionGroup(transactionsForGroup));
        }
        transactionItems.add(_getHeader(
          context,
          groupDate: groupDate,
        ));
        mappedTransactions.clear();
      }
      mappedTransactions.add(_getTransactionItem(transactions[i], context));
    }

    ///add for last day since it's skipped in the loop
    transactionItems.add(TransactionGroup(mappedTransactions));
    return transactionItems;
  }

  ///Returns a header for the specified date
  TransactionHeader _getHeader(
    BuildContext context, {
    DateTime groupDate,
  }) {
    final dateFormat = DateTime.now().year == groupDate.year
        ? _dateFormatCurrentYearHeader
        : _dateFormatOtherYearHeader;

    return TransactionHeader(
      text: DateTimeUtils.getDescriptiveDate(
        dateTime: groupDate,
        dateFormat: dateFormat,
        currentDateTime: DateTime.now(),
      ).localize(context),
    );
  }

  ///Converts a [Transaction] to [TransactionListItem]
  TransactionListItem _getTransactionItem(
    Transaction transaction,
    BuildContext context,
  ) =>
      TransactionListItem(
        operation: _getOperation(transaction, context),
        campaignName: transaction.campaignName,
        partnerName: transaction.partnerName,
        time: _getTransactionFormattedDate(transaction),
        amount: transaction.price.displayValueWithSymbol,
        transactionType: transaction.type,
      );

  String _getOperation(
    Transaction transaction,
    BuildContext context,
  ) {
    switch (transaction.type) {
      case TransactionType.smartVoucherTransferSend:
        return transaction.otherSideCustomerEmail != null
            ? LocalizedStrings.of(context)
                .sendTo(transaction.otherSideCustomerEmail)
            : '';
      case TransactionType.smartVoucherTransferReceive:
        return transaction.otherSideCustomerEmail != null
            ? LocalizedStrings.of(context)
                .receiveFrom(transaction.otherSideCustomerEmail)
            : '';
      case TransactionType.smartVoucherPayment:
        return LocalizedStrings.of(context).purchase;
      case TransactionType.smartVoucherUse:
        return LocalizedStrings.of(context).use;
    }
  }

  String _getTransactionFormattedDate(Transaction transaction) {
    final transactionDate = DateTime.parse(transaction.date).toLocal();
    return _dateFormatTime.format(transactionDate);
  }
}

TransactionHistoryMapper useTransactionMapper() =>
    ModuleProvider.of<WalletPageModule>(useContext()).transactionMapper;
