import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/email/email_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'email_confirmation_bloc_output.dart';

class EmailConfirmationBloc extends Bloc<EmailConfirmationState> {
  EmailConfirmationBloc(
    this._emailRepository,
    this._localSettingsRepository,
    this._exceptionToMessageMapper,
  );

  final EmailRepository _emailRepository;
  final LocalSettingsRepository _localSettingsRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  EmailConfirmationState initialState() =>
      EmailConfirmationUninitializedState();

  Future<void> storeVerificationCode(String code) async {
    await _localSettingsRepository.storeEmailVerificationCode(code);
    sendEvent(EmailConfirmationStoredKey());
  }

  Future<void> removeVerificationCode() =>
      _localSettingsRepository.removeEmailVerificationCode();

  Future<void> confirmEmail() async {
    setState(EmailConfirmationLoadingState());
    try {
      await _emailRepository.verifyEmail(
          verificationCode:
              _localSettingsRepository.getEmailVerificationCode());

      await removeVerificationCode();

      sendEvent(EmailConfirmationSuccessEvent());
    } on Exception catch (e) {
      await _mapErrorToState(e);
    }
  }

  Future<void> _mapErrorToState(Exception e) async {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is NetworkException) {
      setState(EmailConfirmationNetworkErrorState());
      return;
    }

    if (e is ServiceException) {
      switch (e.exceptionType) {
        case ServiceExceptionType.emailIsAlreadyVerified:
          sendEvent(EmailConfirmationAlreadyVerifiedEvent());
          await _localSettingsRepository.removeEmailVerificationCode();

          break;
        case ServiceExceptionType.verificationCodeDoesNotExist:
        case ServiceExceptionType.verificationCodeMismatch:
        case ServiceExceptionType.verificationCodeExpired:
          sendEvent(EmailConfirmationInvalidCodeEvent());
          break;
        default:
          setState(
              EmailConfirmationErrorState(error: errorMessage, canRetry: true));
          break;
      }
      return;
    }

    setState(EmailConfirmationErrorState(error: errorMessage, canRetry: true));
  }

  bool hasPendingEmailConfirmation() =>
      _localSettingsRepository.getEmailVerificationCode() != null;
}

EmailConfirmationBloc useEmailConfirmationBloc() =>
    ModuleProvider.of<AppModule>(useContext()).emailConfirmationBloc;
