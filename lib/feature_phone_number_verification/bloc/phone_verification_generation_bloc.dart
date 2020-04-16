import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/phone/phone_repository.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/di/phone_number_verification_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PhoneVerificationGenerationBloc
    extends Bloc<PhoneVerificationGenerationState> {
  PhoneVerificationGenerationBloc(this._phoneRepository);

  final PhoneRepository _phoneRepository;

  @override
  PhoneVerificationGenerationState initialState() =>
      PhoneVerificationGenerationUninitializedState();

  Future<void> sendVerificationMessage() async {
    setState(PhoneVerificationGenerationLoadingState());
    try {
      await _phoneRepository.sendVerification();
      sendEvent(PhoneVerificationGenerationSentSmsEvent());
      setState(PhoneVerificationGenerationSuccessState());
    } on Exception catch (e) {
      _mapExceptionToErrorState(e);
    }
  }

  void _mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      setState(PhoneVerificationGenerationNetworkErrorState());
      return;
    }

    if (e is ServiceException) {
      switch (e.exceptionType) {
        case ServiceExceptionType.phoneIsAlreadyVerified:
          sendEvent(PhoneVerificationGenerationAlreadyVerifiedErrorEvent());
          break;
        case ServiceExceptionType.reachedMaximumRequestForPeriod:
          setState(PhoneVerificationGenerationErrorState(
              errorMessage:
                  LocalizedStrings.emailVerificationExceededMaxAttemptsError));
          break;
        default:
          setState(PhoneVerificationGenerationErrorState(
              errorMessage:
                  LocalizedStrings.phoneNumberVerificationCodeNotSentError));
          break;
      }
      return;
    }

    setState(PhoneVerificationGenerationErrorState(
        errorMessage:
            LocalizedStrings.phoneNumberVerificationCodeNotSentError));
  }
}

PhoneVerificationGenerationBloc usePhoneVerificationGenerationBloc() =>
    ModuleProvider.of<PhoneNumberVerificationModule>(useContext())
        .phoneVerificationGenerationBloc;
