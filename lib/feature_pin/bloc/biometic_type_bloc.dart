import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/biometic_type_output.dart';
import 'package:lykke_mobile_mavn/feature_pin/di/pin_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import '../use_case/get_biometric_type_use_case.dart';

class BiometricTypeBloc extends Bloc<BiometricTypeState> {
  BiometricTypeBloc(this._useCase);

  final GetBiometricTypeUseCase _useCase;

  @override
  BiometricTypeState initialState() => BiometricTypeUninitializedState();

  Future<void> checkType() async {
    final biometricType = await _useCase.execute();
    final assets = _getAssets(biometricType);

    setState(BiometricTypeLoadedState(
      assetName: assets.assetName,
      label: assets.label,
    ));
  }

  _BiometricAssets _getAssets(BiometricType biometricType) {
    switch (biometricType) {
      case BiometricType.face:
        return _BiometricAssets(
          assetName: SvgAssets.iconFaceId,
          label: LazyLocalizedStrings.useFaceIDButton,
        );
      case BiometricType.fingerprint:
        return _BiometricAssets(
          assetName: SvgAssets.iconFingerPrint,
          label: LazyLocalizedStrings.useFingerprintButton,
        );
      default:
        return _BiometricAssets(
          assetName: SvgAssets.iconBiometrics,
          label: LazyLocalizedStrings.useBiometricButton,
        );
    }
  }
}

class _BiometricAssets {
  const _BiometricAssets({
    @required this.assetName,
    @required this.label,
  });

  final String assetName;
  final LocalizedStringBuilder label;
}

BiometricTypeBloc useBiometricTypeBloc() =>
    ModuleProvider.of<PinModule>(useContext()).biometricTypeBloc;
