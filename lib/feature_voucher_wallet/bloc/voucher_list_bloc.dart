import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/voucher/voucher_repository.dart';
import 'package:lykke_mobile_mavn/feature_voucher_wallet/di/voucher_wallet_page_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherListBloc
    extends GenericListBloc<VoucherListResponseModel, VoucherResponseModel> {
  VoucherListBloc(this._voucherRepository)
      : super(genericErrorSubtitle: LazyLocalizedStrings.defaultGenericError);

  final VoucherRepository _voucherRepository;

  @override
  List<VoucherResponseModel> getDataFromResponse(
          VoucherListResponseModel response) =>
      response.vouchers;

  @override
  int getTotalCount(VoucherListResponseModel response) => response.totalCount;

  @override
  Future<VoucherListResponseModel> loadData(int page) =>
      _voucherRepository.getVouchers(currentPage: page);
}

VoucherListBloc useVoucherListBloc() =>
    ModuleProvider.of<VoucherWalletModule>(useContext()).voucherListBloc;
