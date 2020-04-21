import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/di/payment_request_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc_output.dart';

class PaymentRequestBloc extends Bloc<PaymentRequestState> {
  PaymentRequestBloc(
    this._partnerRepository,
    this._exceptionToMessageMapper,
  );

  final PartnerRepository _partnerRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  PaymentRequestState initialState() => PaymentRequestUninitializedState();

  Future<void> approvePaymentRequest(
      {String paymentRequestId, String sendingAmount}) async {
    setState(PaymentRequestLoadingState());

    try {
      await _partnerRepository.approvePayment(
        paymentRequestId: paymentRequestId,
        sendingAmount: sendingAmount,
      );
      sendEvent(PaymentRequestApprovedSuccessEvent());
    } on Exception catch (e) {
      setState(_mapExceptionToErrorState(e));
    }
  }

  Future<void> rejectPaymentRequest({String paymentRequestId}) async {
    setState(PaymentRequestLoadingState());

    try {
      await _partnerRepository.rejectPayment(
          paymentRequestId: paymentRequestId);
      sendEvent(PaymentRequestRejectedSuccessEvent());
    } on Exception catch (e) {
      setState(_mapExceptionToErrorState(e));
    }
  }

  PaymentRequestState _mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      return PaymentRequestErrorState(
        errorTitle: LazyLocalizedStrings.networkErrorTitle,
        errorSubtitle: LazyLocalizedStrings.networkError,
        iconAsset: SvgAssets.networkError,
      );
    }
    if (e is ServiceException) {
      return PaymentRequestInlineErrorState(
          error: _mapServiceExceptionToErrorMessage(e));
    }
    return PaymentRequestErrorState(
      errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
      errorSubtitle: LazyLocalizedStrings.transferRequestGenericError,
      iconAsset: SvgAssets.genericError,
    );
  }

  LocalizedStringBuilder _mapServiceExceptionToErrorMessage(
      ServiceException e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    switch (e.exceptionType) {
      case ServiceExceptionType.customerWalletBlocked:
        sendEvent(PaymentRequestWalletDisabledEvent());
        return errorMessage;
      case ServiceExceptionType.paymentIsNotInACorrectStatusToBeUpdated:
        sendEvent(PaymentRequestExpiredEvent());
        return errorMessage;
      default:
        return errorMessage;
    }
  }
}

PaymentRequestBloc usePaymentRequestBloc() =>
    ModuleProvider.of<PaymentRequestModule>(useContext()).paymentRequestBloc;
