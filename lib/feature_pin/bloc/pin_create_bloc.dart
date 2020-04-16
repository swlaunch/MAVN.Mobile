import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_base_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PinCreateBloc extends PinBlocBase {
  PinCreateBloc(GetMobileSettingsUseCase mobileSettings)
      : super(mobileSettings.execute().pinCode.pinCodeLength);

  @override
  bool get isSubmitVisible => digits.length == digitsLimit;
}

PinCreateBloc usePinCreateBloc() =>
    ModuleProvider.of<PinModule>(useContext()).pinCreateBloc;
