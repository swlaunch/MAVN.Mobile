import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/email/email_repository.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/di/email_verification_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationState> {
  EmailVerificationBloc(
    this._emailRepository,
    this._exceptionToMessageMapper,
  );

  final EmailRepository _emailRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  EmailVerificationState initialState() =>
      EmailVerificationUninitializedState();

  Future<void> sendVerificationEmail() async {
    setState(EmailVerificationLoadingState());
    try {
      await _emailRepository.sendVerificationEmail();
      setState(EmailVerificationSuccessState());
    } on Exception catch (e) {
      _getErrorStateFromException(e);
    }
  }

  void _getErrorStateFromException(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is NetworkException) {
      setState(EmailVerificationNetworkErrorState());
      return;
    }

    if (e is ServiceException) {
      switch (e.exceptionType) {
        case ServiceExceptionType.emailIsAlreadyVerified:
          sendEvent(EmailVerificationAlreadyVerifiedEvent());
          break;
        case ServiceExceptionType.reachedMaximumRequestForPeriod:
          setState(EmailVerificationErrorState(
              error: LazyLocalizedStrings
                  .emailVerificationExceededMaxAttemptsError));
          break;
        default:
          setState(EmailVerificationErrorState(error: errorMessage));
          break;
      }
      return;
    }

    setState(EmailVerificationErrorState(error: errorMessage));
  }
}

EmailVerificationBloc useEmailVerificationBloc() =>
    ModuleProvider.of<EmailVerificationModule>(useContext())
        .emailVerificationBloc;
