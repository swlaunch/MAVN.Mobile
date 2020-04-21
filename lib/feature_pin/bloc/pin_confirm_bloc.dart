import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/pin/pin_repository.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_base_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PinConfirmBloc extends PinBlocBase {
  PinConfirmBloc(
    this._pinRepository,
    this._exceptionToMessageMapper,
    GetMobileSettingsUseCase mobileSettings,
  ) : super(mobileSettings.execute().pinCode.pinCodeLength);

  final PinRepository _pinRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  List<int> _initialDigits = [];

  /// Set initial pass code in case it's empty
  // ignore: avoid_setters_without_getters
  set initialDigits(List<int> initialDigits) {
    if (_initialDigits.isEmpty) {
      _initialDigits = initialDigits;
    }
  }

  @override
  bool get isSubmitVisible => _digitsDoMatch;

  bool get _digitsDoMatch => listEquals(_initialDigits, digits);

  @override
  Future<void> onPassCodeChange() {
    super.onPassCodeChange();

    if (digits.length == digitsLimit && !_digitsDoMatch) {
      setState(PinErrorState(
        error: LazyLocalizedStrings.pinErrorDoesNotMatch,
        isSubmitVisible: isSubmitVisible,
        isHidden: isHidden,
        digits: digits,
      ));
    }
  }

  Future<void> storePin() async {
    sendEvent(PinLoadingEvent());
    setState(PinLoadingState());

    try {
      await _pinRepository.setPin(digits);
    } catch (e) {
      setState(PinErrorState(
        error: _exceptionToMessageMapper.map(e),
        isSubmitVisible: isSubmitVisible,
        isHidden: isHidden,
        digits: digits,
      ));

      return;
    } finally {
      sendEvent(PinLoadedEvent());
    }

    setState(PinStoredState());
    sendEvent(PinStoredEvent());
  }
}

PinConfirmBloc usePinConfirmBloc() =>
    ModuleProvider.of<PinModule>(useContext()).pinConfirmBloc;
