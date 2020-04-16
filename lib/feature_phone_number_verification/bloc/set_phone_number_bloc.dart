import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/phone/phone_repository.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/di/phone_number_verification_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SetPhoneNumberBloc extends Bloc<SetPhoneNumberState> {
  SetPhoneNumberBloc(
    this._phoneRepository,
    this._exceptionToMessageMapper,
  );

  final PhoneRepository _phoneRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  SetPhoneNumberState initialState() => SetPhoneNumberUninitializedState();

  Future<void> setPhoneNumber({
    String phoneNumber,
    int countryPhoneCodeId,
  }) async {
    setState(SetPhoneNumberLoadingState());

    try {
      await _phoneRepository.setPhoneNumber(
          phoneNumber: phoneNumber.trim(),
          countryPhoneCodeId: countryPhoneCodeId);
      sendEvent(SetPhoneNumberEvent());
      setState(SetPhoneNumberSuccessState());
    } on Exception catch (e) {
      setState(_mapErrorToState(e));
    }
  }

  SetPhoneNumberBaseErrorState _mapErrorToState(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is ServiceException &&
        e.exceptionType == ServiceExceptionType.phoneAlreadyExists) {
      return SetPhoneNumberInlineErrorState(errorMessage: errorMessage);
    }
    if (e is NetworkException) {
      return SetPhoneNumberNetworkErrorState();
    }
    return SetPhoneNumberErrorState(errorMessage: errorMessage);
  }
}

SetPhoneNumberBloc useSetPhoneNumberBloc() =>
    ModuleProvider.of<PhoneNumberVerificationModule>(useContext())
        .setPhoneNumberBloc;
