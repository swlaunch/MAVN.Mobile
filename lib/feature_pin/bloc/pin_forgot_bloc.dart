import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PinForgotBloc {
  PinForgotBloc(this._sharedPreferencesManager);

  final SharedPreferencesManager _sharedPreferencesManager;

  Future<void> resetPinPassCode() async {
    await _sharedPreferencesManager.writeBool(
        key: SharedPreferencesKeys.forgottenPin, value: true);
  }
}

PinForgotBloc usePinForgotBloc() =>
    ModuleProvider.of<PinModule>(useContext()).pinForgotBloc;
