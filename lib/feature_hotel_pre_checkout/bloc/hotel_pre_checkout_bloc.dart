import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/bloc/hotel_pre_checkout_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/di/hotel_pre_checkout_di.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/bloc/hotel_pre_checkout_bloc_output.dart';

class HotelPreCheckoutBloc extends Bloc<HotelPreCheckoutState> {
  HotelPreCheckoutBloc(
    this._partnerRepository,
    this._exceptionToMessageMapper,
  );

  final PartnerRepository _partnerRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  HotelPreCheckoutState initialState() => HotelPreCheckoutUninitializedState();

  Future<void> getHotelPreCheckoutDetails(String paymentId) async {
    setState(HotelPreCheckoutLoadingState());
    try {
      final paymentDetails =
          await _partnerRepository.getPaymentRequestDetails(paymentId);

      setState(HotelPreCheckoutLoadedState(
          partnerName: paymentDetails.partnerName,
          message: paymentDetails.paymentInfo));
    } on Exception catch (e) {
      setState(HotelPreCheckoutErrorState(_exceptionToMessageMapper.map(e)));
    }
  }
}

HotelPreCheckoutBloc useHotelPreCheckoutBloc() =>
    ModuleProvider.of<HotelPreCheckoutModule>(useContext())
        .hotelPreCheckoutBloc;
