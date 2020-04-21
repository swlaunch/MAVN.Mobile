import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/di/payment_request_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';

class PaymentRequestDetailsBloc extends Bloc<PaymentRequestDetailsState> {
  PaymentRequestDetailsBloc(this._partnerRepository);

  final PartnerRepository _partnerRepository;

  @override
  PaymentRequestDetailsState initialState() =>
      PaymentRequestDetailsUninitializedState();

  Future<void> getPaymentRequest({String paymentRequestId}) async {
    setState(PaymentRequestDetailsLoadingState());

    try {
      final payment =
          await _partnerRepository.getPaymentRequestDetails(paymentRequestId);
      sendEvent(PaymentRequestDetailsLoadedEvent(payment: payment));
      setState(PaymentRequestDetailsLoadedState(payment: payment));
    } on Exception catch (e) {
      setState(_mapExceptionToErrorState(e));
    }
  }

  PaymentRequestDetailsState _mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      return PaymentRequestDetailsErrorState(
        errorTitle: LazyLocalizedStrings.networkErrorTitle,
        errorSubtitle: LazyLocalizedStrings.networkError,
        iconAsset: SvgAssets.networkError,
      );
    }
    return PaymentRequestDetailsErrorState(
      errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
      errorSubtitle: LazyLocalizedStrings.transferRequestGenericError,
      iconAsset: SvgAssets.genericError,
    );
  }
}

PaymentRequestDetailsBloc usePaymentRequestDetailsBloc() =>
    ModuleProvider.of<PaymentRequestModule>(useContext())
        .paymentRequestDetailsBloc;
