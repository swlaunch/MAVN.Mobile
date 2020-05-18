import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_header.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_item.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/date_time_utils.dart';

class TransactionHistoryMapper {
  static final DateFormat _dateFormatCurrentYearHeader =
      DateFormat('EEEE, dd MMMM');
  static final DateFormat _dateFormatOtherYearHeader =
      DateFormat('EEEE, dd MMMM, yyyy');

  static final DateFormat _dateFormatCurrentYearItem =
      DateFormat('dd MMMM, HH:mm');
  static final DateFormat _dateFormatOtherYearItem =
      DateFormat('dd MMMM yyyy, HH:mm');

  static const _plusSign = '+';
  static const _minusSign = '-';

  final _debitOperations = [
    TransactionType.sendTransfer,
    TransactionType.paymentTransfer,
    TransactionType.partnerPayment,
    TransactionType.referralStake,
    TransactionType.walletLinkingFee,
    TransactionType.transferToPublicFee,
    TransactionType.linkedWalletSendTransfer,
    TransactionType.voucherPurchasePayment,
  ];

  ///Returns a list of items for the list (transactions and headers)
  List<TransactionItem> mapTransactions(
    List<Transaction> transactions,
    final String tokenSymbol,
    BuildContext context,
  ) {
    DateTime groupDate;
    final mappedTransactions = <TransactionItem>[];
    for (int i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];

      if (transaction.type == null) {
        continue;
      }

      final transactionDateTime =
          DateTime.parse(transactions[i].date).toLocal();

      if (groupDate == null ||
          !DateTimeUtils.isSameDate(groupDate, transactionDateTime)) {
        groupDate = transactionDateTime;
        mappedTransactions.add(_getHeader(
          context,
          groupDate: groupDate,
          transactions: transactions,
          tokenSymbol: tokenSymbol,
        ));
      }
      mappedTransactions.add(_getTransactionItem(transactions[i], tokenSymbol));
    }
    return mappedTransactions;
  }

  ///Returns a header for the specified date
  TransactionHeaderItem _getHeader(
    BuildContext context, {
    DateTime groupDate,
    List<Transaction> transactions,
    String tokenSymbol,
  }) {
    final dateFormat = DateTime.now().year == groupDate.year
        ? _dateFormatCurrentYearHeader
        : _dateFormatOtherYearHeader;

    final transactionsForDate = transactions.where((element) =>
        DateTimeUtils.isSameDate(
            groupDate, DateTime.parse(element.date).toLocal()));

    final amountForDate = transactionsForDate
        .map((e) => _getAmount(e))
        .reduce((value, element) => value += element);
    final sign = amountForDate > Decimal.zero ? _plusSign : _minusSign;

    final formattedAmount = '$sign $tokenSymbol ${amountForDate.abs()}';
    return TransactionHeaderItem(
      text: DateTimeUtils.getDescriptiveDate(
        dateTime: groupDate,
        dateFormat: dateFormat,
        currentDateTime: DateTime.now(),
      ).localize(context),
      amount: formattedAmount,
    );
  }

  ///Converts a [Transaction] to [TransactionListItem]
  TransactionListItem _getTransactionItem(
      Transaction transaction, String tokenSymbol) {
    final formattedDate = _getTransactionFormattedDate(transaction);

    final amount = _getAmount(transaction);
    final sign = amount > Decimal.zero ? _plusSign : _minusSign;
    final formattedAmount = '$sign $tokenSymbol ${transaction.amount}';

    switch (transaction.type) {
      case TransactionType.sendTransfer:
        return TransactionListItem(
          transaction: transaction,
          title: transaction.otherSideCustomerEmail != null
              ? LazyLocalizedStrings.to(transaction.otherSideCustomerEmail)
              : LocalizedStringBuilder.empty(),
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.receiveTransfer:
        return TransactionListItem(
          transaction: transaction,
          title: transaction.otherSideCustomerEmail != null
              ? LazyLocalizedStrings.from(transaction.otherSideCustomerEmail)
              : LocalizedStringBuilder.empty(),
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.bonusReward:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings.walletPageTransactionHistoryRewardType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          subtitle: LocalizedStringBuilder.custom(transaction.actionRule),
          transactionType: transaction.type,
        );
      case TransactionType.paymentTransfer:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings.walletPageTransactionHistoryPaymentType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
          subtitle: LocalizedStringBuilder.custom(transaction.instalmentName),
        );
      case TransactionType.paymentTransferRefund:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings.walletPageTransactionHistoryRefundType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
          subtitle: LocalizedStringBuilder.custom(transaction.instalmentName),
        );
      case TransactionType.partnerPayment:
        return TransactionListItem(
          transaction: transaction,
          title: LocalizedStringBuilder.custom(transaction.partnerName),
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.partnerPaymentRefund:
        return TransactionListItem(
          transaction: transaction,
          title: LocalizedStringBuilder.custom(transaction.partnerName),
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
          subtitle: LazyLocalizedStrings.walletPageTransactionHistoryRefundType,
        );
      case TransactionType.referralStake:
        return TransactionListItem(
          transaction: transaction,
          title: LocalizedStringBuilder.custom(transaction.actionRule),
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.releasedReferralStake:
        return TransactionListItem(
          transaction: transaction,
          title: LocalizedStringBuilder.custom(transaction.actionRule),
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.walletLinkingFee:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings
              .walletPageTransactionHistoryWalletLinkingType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );

      case TransactionType.transferToPublicFee:
        return TransactionListItem(
          transaction: transaction,
          title:
              LazyLocalizedStrings.walletPageTransactionHistoryTransferFeeType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.linkedWalletSendTransfer:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings
              .walletPageTransactionHistoryTransferToExternalType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.linkedWalletReceiveTransfer:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings
              .walletPageTransactionHistoryTransferFromExternalType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
        );
      case TransactionType.voucherPurchasePayment:
        return TransactionListItem(
          transaction: transaction,
          title: LazyLocalizedStrings
              .walletPageTransactionHistoryVoucherPurchaseType,
          amount: formattedAmount,
          formattedDate: formattedDate,
          transactionType: transaction.type,
          subtitle: LocalizedStringBuilder.custom(transaction.actionRule),
        );
    }
  }

  String _getTransactionFormattedDate(Transaction transaction) {
    final transactionDate = DateTime.parse(transaction.date).toLocal();
    final dateFormat = DateTime.now().year == transactionDate.year
        ? _dateFormatCurrentYearItem
        : _dateFormatOtherYearItem;
    return dateFormat.format(transactionDate);
  }

  Decimal _getAmount(Transaction transaction) {
    final amount = Decimal.tryParse(transaction.amount);
    if (_debitOperations.contains(transaction.type)) {
      return amount * Decimal.fromInt(-1);
    }
    return amount;
  }
}

TransactionHistoryMapper useTransactionMapper() =>
    ModuleProvider.of<WalletPageModule>(useContext()).transactionMapper;
