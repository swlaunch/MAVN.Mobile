import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/voucher/voucher_repository.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TransferVoucherBloc extends Bloc<TransferVoucherState> {
  TransferVoucherBloc(
    this._voucherRepository,
    this._exceptionToMessageMapper,
  );

  final VoucherRepository _voucherRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  TransferVoucherState initialState() => TransferVoucherUninitializedState();

  Future<void> transferVoucher(
      {String receiverEmail, String voucherShortCode}) async {
    setState(TransferVoucherLoadingState());

    try {
      await _voucherRepository.transferVoucher(
        receiverEmail: receiverEmail?.trim(),
        shortCode: voucherShortCode,
      );

      sendEvent(TransferVoucherSuccessEvent());
    } on Exception catch (e) {
      setState(_mapExceptionToErrorState(e));
    }
  }

  TransferVoucherState _mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      return TransferVoucherNetworkErrorState();
    }
    final errorMessage = _exceptionToMessageMapper.map(e);

    return TransferVoucherErrorState(errorMessage);
  }
}

TransferVoucherBloc useTransferVoucherBloc() =>
    ModuleProvider.of<AppModule>(useContext()).transferVoucherBloc;
