import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/pin/pin_repository.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_base_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PinSignInBloc extends PinBlocBase {
  PinSignInBloc(
    this._pinRepository,
    this._exceptionToMessageMapper,
    GetMobileSettingsUseCase mobileSettings,
  )   : _maximumAttemptCount =
            mobileSettings.execute().pinCode.pinCodeMaximumAttemptCount,
        _warningAttemptCount =
            mobileSettings.execute().pinCode.pinCodeWarningAttemptCount,
        super(mobileSettings.execute().pinCode.pinCodeLength);

  final PinRepository _pinRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  bool get isSubmitVisible => true;

  int _attemptCount = 0;
  final int _maximumAttemptCount;
  final int _warningAttemptCount;

  int get _remainingAttemptCount => _maximumAttemptCount - _attemptCount;

  @override
  Future<void> onPassCodeChange() async {
    await super.onPassCodeChange();

    if (digits.length < digitsLimit) {
      return;
    }

    try {
      sendEvent(PinLoadingEvent());
      await _pinRepository.checkPin(digits);
      setState(PinSignInState());
      sendEvent(PinSignInEvent());
    } on Exception catch (exception) {
      digits.clear();

      if (exception is ServiceException &&
          exception.exceptionType == ServiceExceptionType.pinCodeMismatch) {
        _attemptCount += 1;

        if (_attemptCount >= _maximumAttemptCount) {
          setState(PinReachedMaximumAttemptsState());
          sendEvent(PinReachedMaximumAttemptsEvent());
          return;
        }

        if (_attemptCount >= _warningAttemptCount) {
          setState(PinErrorState(
            error: LazyLocalizedStrings.pinErrorRemainingAttempts(
                _remainingAttemptCount),
            isSubmitVisible: isSubmitVisible,
            isHidden: isHidden,
            digits: digits,
          ));

          return;
        }
      }

      setState(PinErrorState(
        error: _exceptionToMessageMapper.map(exception),
        isSubmitVisible: isSubmitVisible,
        isHidden: isHidden,
        digits: digits,
      ));
    } finally {
      sendEvent(PinLoadedEvent());
    }
  }
}

PinSignInBloc usePinSignInBloc() =>
    ModuleProvider.of<PinModule>(useContext()).pinSignInBloc;
