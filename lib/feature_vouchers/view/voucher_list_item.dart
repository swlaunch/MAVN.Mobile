import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/copy_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';

class VoucherListItemView extends StatelessWidget {
  const VoucherListItemView(this.voucherListItem);

  final VoucherListVoucher voucherListItem;

  @override
  Widget build(BuildContext context) => Container(
        color: ColorStyles.white,
        padding: const EdgeInsets.all(24),
        child: CopyWidget(
          copyText: voucherListItem.voucher.code,
          toastMessage: LocalizedStrings.of(context).voucherCopied,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NullSafeText(
                voucherListItem.voucher.code,
                style: TextStyles.darkBodyBody2RegularHigh,
              ),
              NullSafeText(
                voucherListItem.subtitle,
                style: TextStyles.darkBodyBody4Regular,
              ),
              const SizedBox(height: 8),
              NullSafeText(
                voucherListItem.formattedDate,
                style: TextStyles.darkBodyBody3RegularHigh,
              )
            ],
          ),
        ),
      );
}

abstract class VoucherListItem {}

class VoucherListVoucher extends VoucherListItem {
  VoucherListVoucher(
    this.voucher,
    this.subtitle,
    this.formattedDate,
  );

  final VoucherResponseModel voucher;
  final String subtitle;
  final String formattedDate;
}

class VoucherListDate extends VoucherListItem {
  VoucherListDate(this.formattedDate);
  final String formattedDate;
}
