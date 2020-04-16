import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/bloc/hotel_welcome_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/di/hotel_welcome_di.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_hotel_welcome/bloc/hotel_welcome_bloc_output.dart';

class HotelWelcomeBloc extends Bloc<HotelWelcomeState> {
  HotelWelcomeBloc(
    this._partnerRepository,
    this._exceptionToMessageMapper,
  );

  final PartnerRepository _partnerRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  HotelWelcomeState initialState() => HotelWelcomeUninitializedState();

  Future<void> getPartnerMessage(String partnerMessageId) async {
    setState(HotelWelcomeLoadingState());
    try {
      final response =
          await _partnerRepository.getPartnerMessage(partnerMessageId);

      setState(HotelWelcomeLoadedState(
        partnerName: response.partnerName,
        heading: response.subject,
        message: response.message,
      ));
    } on Exception catch (e) {
      setState(HotelWelcomeErrorState(_exceptionToMessageMapper.map(e)));
    }
  }
}

HotelWelcomeBloc useHotelWelcomeBloc() =>
    ModuleProvider.of<HotelWelcomeModule>(useContext()).hotelWelcomeBloc;
