import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/voucher/voucher_repository.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/payment_url_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/di/voucher_details_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PaymentUrlBloc extends Bloc<PaymentUrlState> {
  PaymentUrlBloc(this._voucherRepository, this._exceptionToMessageMapper);

  final VoucherRepository _voucherRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  PaymentUrlState initialState() => PaymentUrlUninitializedState();

  Future<void> getPaymentUrl({@required String shortCode}) async {
    setState(PaymentUrlLoadingState());
    try {
      final purchaseVoucherResponse =
          await _voucherRepository.getPaymentUrl(shortCode: shortCode);

      //only disabling the loading
      setState(PaymentUrlLoadedState());
      //triggers flow
      sendEvent(
        PaymentUrlSuccessEvent(paymentUrl: purchaseVoucherResponse.paymentUrl),
      );
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(PaymentUrlNetworkErrorState());
      }
      setState(PaymentUrlErrorState(error: _exceptionToMessageMapper.map(e)));
    }
  }
}

PaymentUrlBloc usePaymentUrlBloc() =>
    ModuleProvider.of<VoucherDetailsModule>(useContext()).paymentUrlBloc;
