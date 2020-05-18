import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/analytics/transaction_form_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/di/transaction_form_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TransactionFormBloc extends Bloc<TransactionFormState> {
  TransactionFormBloc(
    this._walletRepository,
    this._analyticsManager,
    this._barcodeScanManager,
    this._exceptionToMessageMapper,
  );

  final WalletRepository _walletRepository;
  final TransactionFormAnalyticsManager _analyticsManager;
  final BarcodeScanManager _barcodeScanManager;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  TransactionFormState initialState() => TransactionFormUninitializedState();

  Future<void> postTransaction({String walletAddress, String amount}) async {
    setState(TransactionFormLoadingState());

    try {
      await _walletRepository.postTransaction(
        walletAddress: walletAddress?.trim(),
        amount: amount,
      );
      await _analyticsManager.transactionDone();

      sendEvent(TransactionFormSuccessEvent());
    } on Exception catch (e) {
      await _analyticsManager.transactionFailed();

      setState(_mapExceptionToErrorState(e));
    }
  }

  TransactionFormState _mapExceptionToErrorState(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is ServiceException) {
      if (e.exceptionType ==
          ServiceExceptionType.transferSourceCustomerWalletBlocked) {
        sendEvent(TransactionFormWalletDisabledEvent());
      }
      return TransactionFormInlineErrorState(errorMessage);
    }

    return TransactionFormErrorState(errorMessage);
  }

  Future<void> startScan() async {
    setState(BarcodeUninitializedState());
    try {
      final String barcode = await _barcodeScanManager.startScan();
      sendEvent(BarcodeScanSuccessEvent(barcode));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(BarcodeScanPermissionErrorState(
            LazyLocalizedStrings.barcodeScanPermissionError));
      } else {
        setState(BarcodeScanErrorState(LazyLocalizedStrings.barcodeScanError));
      }
    } on FormatException {
      // back button case, should be ignored in the flow
    } catch (e) {
      setState(BarcodeScanErrorState(LazyLocalizedStrings.barcodeScanError));
    }
  }
}

TransactionFormBloc useTransactionFormBloc() =>
    ModuleProvider.of<TransactionFormModule>(useContext()).transactionFormBloc;
