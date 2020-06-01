import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/voucher/voucher_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'cancel_voucher_bloc_state.dart';

class CancelVoucherBloc extends Bloc<CancelVoucherState> {
  CancelVoucherBloc(this._voucherRepository, this._exceptionToMessageMapper);

  final VoucherRepository _voucherRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  CancelVoucherState initialState() => CancelVoucherUninitializedState();

  Future<void> cancelVoucher({@required String shortCode}) async {
    setState(CancelVoucherLoadingState());
    try {
      await _voucherRepository.cancelVoucher(shortCode: shortCode);

      //only disabling the loading
      setState(CancelVoucherLoadedState());
      //triggers flow
      sendEvent(CancelVoucherSuccessEvent());
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(CancelVoucherNetworkErrorState());
      }
      setState(
          CancelVoucherErrorState(error: _exceptionToMessageMapper.map(e)));
    }
  }
}

CancelVoucherBloc useCancelVoucherBloc() =>
    ModuleProvider.of<AppModule>(useContext()).cancelVoucherBloc;
