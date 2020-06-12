import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/scaled_down_svg.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class TransactionListItem {
  TransactionListItem({
    this.operation,
    this.amount,
    this.campaignName,
    this.partnerName,
    this.transactionType,
    this.time,
  });

  final String operation;
  final String amount;
  final String campaignName;
  final String partnerName;
  final TransactionType transactionType;
  final String time;
}

class TransactionHistoryListItemWidget extends StatelessWidget {
  const TransactionHistoryListItemWidget({
    @required this.transactionListItem,
    Key key,
  }) : super(key: key);
  final TransactionListItem transactionListItem;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _buildLeading(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!StringUtils.isNullOrWhitespace(
                      transactionListItem?.operation))
                    Text(
                      transactionListItem.operation,
                      style: TextStyles.transactionHistoryOperation
                          .copyWith(color: _getOperationTextColor()),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  if (!StringUtils.isNullOrWhitespace(
                      transactionListItem?.campaignName))
                    Text(
                      transactionListItem.campaignName,
                      style: TextStyles.transactionHistoryCampaign,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      if (!StringUtils.isNullOrWhitespace(
                          transactionListItem?.partnerName))
                        Flexible(
                          child: Text(
                            transactionListItem.partnerName,
                            style: TextStyles.transactionHistoryPartner,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (!StringUtils.isNullOrWhitespace(
                              transactionListItem?.partnerName) &&
                          transactionListItem.time != null)
                        Text(
                          ' | ',
                          style: TextStyles.transactionHistoryPartner,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (transactionListItem.time != null)
                        Flexible(
                          child: Text(
                            transactionListItem.time,
                            style: TextStyles.transactionHistoryPartner,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            _buildAmount(),
          ],
        ),
      );

  Widget _buildAmount() => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          transactionListItem.amount,
          style: TextStyles.transactionHistoryAmount,
        ),
      );

  Widget _buildLeading() => Container(
        height: 40,
        width: 40,
        child: ScaledDownSvg(asset: SvgAssets.voucher),
        decoration: BoxDecoration(
          color: ColorStyles.wildSand,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      );

  Color _getOperationTextColor() {
    switch (transactionListItem.transactionType) {
      case TransactionType.smartVoucherPayment:
        return ColorStyles.apple;
      case TransactionType.smartVoucherUse:
        return ColorStyles.pictonBlue;
      case TransactionType.smartVoucherTransferSend:
      case TransactionType.smartVoucherTransferReceive:
        return ColorStyles.manatee;
    }
  }
}
