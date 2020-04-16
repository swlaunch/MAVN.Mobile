import 'dart:io';

import 'package:lykke_mobile_mavn/feature_pin/bloc/biometic_type_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_confirm_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_create_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_forgot_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_sign_in_bloc.dart';
import 'package:lykke_mobile_mavn/feature_pin/use_case/get_biometric_type_use_case.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PinModule extends Module {
  PinCreateBloc get pinCreateBloc => get();

  PinConfirmBloc get pinConfirmBloc => get();

  PinSignInBloc get pinSignInBloc => get();

  PinForgotBloc get pinForgotBloc => get();

  GetBiometricTypeUseCase get getBiometricTypeUseCase => get();

  BiometricTypeBloc get biometricTypeBloc => get();

  @override
  void provideInstances() {
    // Bloc
    provideSingleton(() => PinCreateBloc(get()));
    provideSingleton(() => PinConfirmBloc(get(), get(), get()));
    provideSingleton(() => PinSignInBloc(get(), get(), get()));
    provideSingleton(() => PinForgotBloc(get()));
    provideSingleton(
        () => GetBiometricTypeUseCase(get(), isIOS: Platform.isIOS));
    provideSingleton(() => BiometricTypeBloc(get()));
  }
}
