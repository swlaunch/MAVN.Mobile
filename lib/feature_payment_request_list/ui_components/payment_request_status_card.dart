import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class PaymentRequestStatusCard extends HookWidget {
  const PaymentRequestStatusCard(this.paymentRequest, this.onTap);

  final PaymentRequestResponseModel paymentRequest;
  final Function(PaymentRequestResponseModel paymentRequestResponseModel) onTap;

  static final DateFormat _dateFormatCurrentYear = DateFormat('dd MMMM, HH:mm');
  static final DateFormat _dateFormatOtherYear =
      DateFormat('dd MMMM yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    final dateTimeManager = useDateTimeManager();

    return SelectListItem(
      onTap: () {
        if (onTap != null) {
          onTap(paymentRequest);
        }
      },
      valueKey: Key(paymentRequest.paymentRequestId),
      child: Container(
        color: ColorStyles.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecipient(),
                _buildStatus(),
              ],
            ),
            const SizedBox(height: 16),
            _buildSendingAmount(),
            const SizedBox(height: 16),
            _buildTotalBill(),
            const SizedBox(height: 8),
            _buildDate(dateTimeManager),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipient() => Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (paymentRequest.partnerName != null)
              _buildInfoLine(
                key: useLocalizedStrings()
                    .transferRequestStatusCardRecipientLabel
                    .toUpperCase(),
                value: paymentRequest.partnerName,
              ),
            Text(
              useLocalizedStrings().transferRequestStatusCardRecipientIdLabel(
                  paymentRequest.paymentRequestId),
              style: TextStyles.darkBodyBody3RegularHigh,
            ),
          ],
        ),
      );

  Widget _buildStatus() {
    if (paymentRequest.status == PaymentRequestStatus.completed) {
      return const StandardSizedSvg(SvgAssets.success);
    }

    final isErrorStatus = [
      PaymentRequestStatus.requestExpired,
      PaymentRequestStatus.paymentExpired,
      PaymentRequestStatus.failed,
      PaymentRequestStatus.cancelled
    ].contains(paymentRequest.status);

    return Container(
      child: Row(
        children: <Widget>[
          _buildNonSuccessStatusCircleIndicator(),
          Text(_toLocalizedStatus(paymentRequest.status).toUpperCase(),
              style: isErrorStatus
                  ? TextStyles.inputLabelBoldError
                  : TextStyles.darkInputLabelBold),
        ],
      ),
    );
  }

  Widget _buildNonSuccessStatusCircleIndicator() => Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorStyles.errorRed,
        ),
      );

  Widget _buildSendingAmount() =>
      paymentRequest.sendingAmountInToken.value != null
          ? _buildInfoLine(
              key: useLocalizedStrings()
                  .transferRequestStatusCardSendingAmountLabel
                  .toUpperCase(),
              value: paymentRequest.sendingAmountInToken.value,
            )
          : Container();

  Widget _buildTotalBill() => _buildInfoLine(
        key: useLocalizedStrings()
            .transferRequestStatusCardTotalBillLabel
            .toUpperCase(),
        value: '${paymentRequest.totalInToken.displayValueWithSymbol} '
            // ignore: lines_longer_than_80_chars
            '(${NumberFormatter.toFormattedStringFromDouble(paymentRequest.totalInCurrency)} '
            '${paymentRequest.currencyCode})',
      );

  Widget _buildDate(DateTimeManager dateTimeManager) {
    final now = dateTimeManager.now;
    final dateFormat = now.year ==
            dateTimeManager.toLocal(DateTime.parse(paymentRequest.date)).year
        ? _dateFormatCurrentYear
        : _dateFormatOtherYear;

    return Container(
      child: Text(
        dateFormat.format(
            dateTimeManager.toLocal(DateTime.parse(paymentRequest.date))),
        style: TextStyles.darkBodyBody4Regular,
      ),
    );
  }

  Widget _buildInfoLine({String key, String value}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(key.toUpperCase(), style: TextStyles.inputLabelBoldGrey),
          const SizedBox(height: 4),
          Text(value, style: TextStyles.darkBodyBody1Bold),
        ],
      );

  static String _toLocalizedStatus(PaymentRequestStatus status) {
    switch (status) {
      case PaymentRequestStatus.pending:
        return useLocalizedStrings().transferRequestStatusCardStatusPending;
      case PaymentRequestStatus.confirmed:
        return useLocalizedStrings().transferRequestStatusCardStatusConfirmed;
      case PaymentRequestStatus.completed:
        return useLocalizedStrings().transferRequestStatusCardStatusCompleted;
      case PaymentRequestStatus.cancelled:
        return useLocalizedStrings().transferRequestStatusCardStatusCancelled;
      case PaymentRequestStatus.failed:
        return useLocalizedStrings().transferRequestStatusCardStatusFailed;
      case PaymentRequestStatus.requestExpired:
      case PaymentRequestStatus.paymentExpired:
        return useLocalizedStrings().transferRequestStatusCardStatusExpired;
    }
  }
}
