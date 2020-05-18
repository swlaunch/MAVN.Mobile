import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/campaign/campaign_repository.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/di/voucher_purchase_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherPurchaseBloc extends Bloc<VoucherPurchaseState> {
  VoucherPurchaseBloc(this._voucherRepository, this._exceptionToMessageMapper);

  final CampaignRepository _voucherRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  VoucherPurchaseState initialState() => VoucherPurchaseUninitializedState();

  Future<void> purchaseVoucher({@required String campaignId}) async {
    setState(VoucherPurchaseLoadingState());
    try {
      final purchaseVoucherResponse =
          await _voucherRepository.purchaseVoucher(id: campaignId);

      //only disabling the loading
      setState(VoucherPurchaseLoadedState());
      //triggers flow
      sendEvent(
        VoucherPurchaseSuccessEvent(
          paymentUrl: purchaseVoucherResponse.paymentUrl,
        ),
      );
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(VoucherPurchaseNetworkErrorState());
      }
      setState(
          VoucherPurchaseErrorState(error: _exceptionToMessageMapper.map(e)));
    }
  }
}

VoucherPurchaseBloc useVoucherPurchaseBloc() =>
    ModuleProvider.of<VoucherPurchaseModule>(useContext()).voucherPurchaseBloc;
