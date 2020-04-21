import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/di/voucher_list_module.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/view/voucher_list_item.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/date_time_utils.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

class VoucherToItemMapper {
  VoucherToItemMapper(this._dateTimeManager, this._getMobileSettingsUseCase);

  final DateTimeManager _dateTimeManager;
  final GetMobileSettingsUseCase _getMobileSettingsUseCase;

  ///returns a list of items for the list (vouchers and date headers)
  List<VoucherListItem> mapVouchers(
      BuildContext context, List<VoucherResponseModel> vouchers) {
    final baseCurrency = _getMobileSettingsUseCase.execute()?.baseCurrency;
    DateTime groupDate;
    final mappedVouchers = <VoucherListItem>[];
    for (int i = 0; i < vouchers.length; i++) {
      final voucher = vouchers[i];
      final voucherLocalDate = voucher.purchaseDate.toLocal();

      if (!DateTimeUtils.isSameDate(groupDate, voucherLocalDate)) {
        groupDate = voucherLocalDate;

        mappedVouchers.add(_getVoucherListDate(context, groupDate));
      }

      final formattedDate =
          _dateTimeManager.formatBasedOnYear(voucherLocalDate);
      mappedVouchers.add(VoucherListVoucher(
          voucher, _getVoucherSubtitle(voucher, baseCurrency), formattedDate));
    }
    return mappedVouchers;
  }

  VoucherListDate _getVoucherListDate(BuildContext context, DateTime date) {
    final formattedDate = DateTimeUtils.getDescriptiveDate(
      dateTime: date,
      dateFormat: _dateTimeManager.getDateFormatBasedOnYear(date),
      currentDateTime: _dateTimeManager.now,
    ).localize(context);
    return VoucherListDate(formattedDate);
  }

  String _getVoucherSubtitle(
      VoucherResponseModel voucher, String baseCurrency) {
    final voucherPrice = '${voucher.priceBaseCurrency} $baseCurrency';

    if (!StringUtils.isNullOrEmpty(voucher.spendRuleName)) {
      return '${voucher.spendRuleName} $voucherPrice';
    }
    return voucherPrice;
  }
}

VoucherToItemMapper useVoucherMapper() =>
    ModuleProvider.of<VoucherListModule>(useContext()).voucherMapper;
