import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/sme/sme_repository.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/bloc/invalidate_voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_sme_invalidate_voucher/di/sme_invalidate_voucher_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class InvalidateVoucherBloc extends Bloc<InvalidateVoucherState> {
  InvalidateVoucherBloc(this._smeRepository, this._exceptionToMessageMapper);

  final SmeRepository _smeRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  InvalidateVoucherState initialState() =>
      InvalidateVoucherUninitializedState();

  Future<void> invalidateVoucher({
    @required String voucherShortCode,
    @required String voucherValidationCode,
  }) async {
    setState(InvalidateVoucherLoadingState());
    try {
      await _smeRepository.invalidateVoucher(
        voucherShortCode: voucherShortCode,
        validationCode: voucherValidationCode,
      );

      setState(InvalidateVoucherLoadedState());
      sendEvent(InvalidateVoucherSuccessEvent());
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(InvalidateVoucherNetworkErrorState());
      }
      setState(
          InvalidateVoucherErrorState(error: _exceptionToMessageMapper.map(e)));
    }
  }
}

InvalidateVoucherBloc useInvalidateVoucherBloc() =>
    ModuleProvider.of<SmeInvalidateVoucherModule>(useContext())
        .invalidateVoucherBloc;
