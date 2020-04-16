import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/has_pin_use_case.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class UserVerificationBloc extends Bloc {
  UserVerificationBloc(
    this.biometricBloc,
    this.router,
    this.localSettingsRepository,
    this.hasPinUseCase,
    this.localAuthentication,
  );

  final Router router;
  final BiometricBloc biometricBloc;
  final LocalSettingsRepository localSettingsRepository;
  final HasPinUseCase hasPinUseCase;
  final LocalAuthentication localAuthentication;

  @override
  BlocState initialState() => null;

  Future<bool> _attemptBiometricAuth() async {
    await biometricBloc.clear();
    await biometricBloc.doAuthenticate();
    final biometricState = biometricBloc.currentState;
    return biometricState is BiometricAuthenticationSuccessState;
  }

  Future<void> verify({
    VoidCallback onSuccess,
    VoidCallback onFailure,
    VoidCallback onCouldNotVerify,
  }) async {
    final shouldUseBiometrics = await localAuthentication.canCheckBiometrics &&
        localSettingsRepository.getUserHasAcceptedBiometricAuthentication();

    if (shouldUseBiometrics) {
      if (await _attemptBiometricAuth()) {
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure();
      }

      return;
    }

    if (await hasPinUseCase.execute()) {
      final result = await router.pushPinVerificationPage();

      if (result == true) {
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure();
      }

      return;
    }

    if (onCouldNotVerify != null) onCouldNotVerify();
  }
}

UserVerificationBloc useUserVerificationBloc() =>
    ModuleProvider.of<AppModule>(useContext()).userVerificationBloc;
