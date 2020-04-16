import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/phone/phone_repository.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/di/phone_number_verification_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PhoneNumberVerificationBloc extends Bloc<PhoneNumberVerificationState> {
  PhoneNumberVerificationBloc(
    this._phoneRepository,
    this._localSettingsRepository,
    this._exceptionToMessageMapper,
  );

  static const int codeLength = 4;

  final PhoneRepository _phoneRepository;
  final LocalSettingsRepository _localSettingsRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  PhoneNumberVerificationState initialState() =>
      PhoneNumberVerificationUninitializedState();

  Future<void> verify({String verificationCode}) async {
    if (verificationCode.length != codeLength) {
      setState(PhoneNumberVerificationErrorState(
          errorMessage:
              LocalizedStrings.phoneNumberVerificationInvalidCodeError));
      return;
    }
    setState(PhoneNumberVerificationLoadingState());
    try {
      await _phoneRepository.verifyPhone(verificationCode: verificationCode);
      await _localSettingsRepository.setUserVerified(isVerified: true);
      sendEvent(PhoneNumberVerifiedEvent());
      setState(PhoneNumberVerifiedState());
    } on Exception catch (e) {
      _mapExceptionToErrorState(e);
    }
  }

  void _mapExceptionToErrorState(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is NetworkException) {
      setState(PhoneNumberVerificationNetworkErrorState());
      return;
    }

    if (e is ServiceException &&
        e.exceptionType == ServiceExceptionType.phoneIsAlreadyVerified) {
      sendEvent(PhoneNumberVerificationAlreadyVerifiedErrorEvent());
      return;
    }

    setState(PhoneNumberVerificationErrorState(errorMessage: errorMessage));
  }
}

PhoneNumberVerificationBloc usePhoneNumberVerificationBloc() =>
    ModuleProvider.of<PhoneNumberVerificationModule>(useContext())
        .phoneNumberVerificationBloc;
