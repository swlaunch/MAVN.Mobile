import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/initials_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/circular_widget.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

abstract class TransactionItem {}

class TransactionListItem extends TransactionItem {
  TransactionListItem({
    @required this.title,
    @required this.amount,
    @required this.transactionType,
    @required this.formattedDate,
    @required this.transaction,
    this.subtitle,
  });

  final LocalizedStringBuilder title;
  final String amount;
  final TransactionType transactionType;
  final Transaction transaction;
  final String formattedDate;
  final LocalizedStringBuilder subtitle;
}

class TransactionHistoryViewListItem extends StatelessWidget {
  const TransactionHistoryViewListItem({
    @required this.transactionListItem,
    @required this.theme,
    Key key,
  }) : super(key: key);
  final TransactionListItem transactionListItem;
  final BaseAppTheme theme;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircularWidget(
              size: 40,
              child: _buildLeading(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (!StringUtils.isNullOrWhitespace(
                        transactionListItem?.title?.localize(context)))
                      Text(
                        transactionListItem.title?.localize(context),
                        style: TextStyles.darkBodyBody2Regular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (!StringUtils.isNullOrWhitespace(
                        transactionListItem?.subtitle?.localize(context)))
                      Text(
                        transactionListItem.subtitle?.localize(context),
                        style: TextStyles.darkBodyBody3Regular,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (transactionListItem.formattedDate != null) _buildDate()
                  ],
                ),
              ),
            ),
            _buildAmount(),
          ],
        ),
      );

  Row _buildAmount() => Row(
        children: <Widget>[
          Text(
            transactionListItem.amount,
            style: TextStyles.transactionHistoryAmount,
          ),
        ],
      );

//TODO return leading
  Widget _buildLeading() {
    switch (transactionListItem.transactionType) {
      case TransactionType.sendTransfer:

      case TransactionType.receiveTransfer:
        return InitialsWidget(
            initialsText:
                transactionListItem.transaction.otherSideCustomerName);

      default:
        return Container(width: 40);
    }
  }

  Widget _buildDate() => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          transactionListItem.formattedDate,
          style: TextStyles.darkBodyBody3RegularHigh,
        ),
      );
}
