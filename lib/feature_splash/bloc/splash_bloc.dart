import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/clear_secure_storage_use_case.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_splash/bloc/splash_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_splash/di/splash_module.dart';
import 'package:lykke_mobile_mavn/feature_splash/use_case/save_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SplashBloc extends Bloc<SplashState> {
  SplashBloc(
    this._localSettingsRepository,
    this._biometricBloc,
    this._saveMobileSettingsUseCase,
    this._routeAuthenticationUseCase,
    this._clearSecureStorageUseCase,
  );

  final LocalSettingsRepository _localSettingsRepository;
  final BiometricBloc _biometricBloc;
  final SaveMobileSettingsUseCase _saveMobileSettingsUseCase;
  final ClearSecureStorageUseCase _clearSecureStorageUseCase;
  final RouteAuthenticationUseCase _routeAuthenticationUseCase;

  @override
  SplashState initialState() => SplashUninitializedState();

  Future<void> initialize() async {
    if (_localSettingsRepository.isFirstRun() ?? true) {
      await _clearSecureStorageUseCase.execute();
      _localSettingsRepository.setIsFirstRun(value: false);
    }

    final _didSaveMobileSettings = await _saveMobileSettings();
    if (!_didSaveMobileSettings) return;

    final targetPage = await _routeAuthenticationUseCase.execute(
        endPage: RouteAuthenticationPage.signInWithPin);

    if (targetPage.page == RouteAuthenticationPage.signInWithPin &&
        _localSettingsRepository.getUserHasAcceptedBiometricAuthentication() &&
        await _attemptBiometricAuth()) {
      sendEvent(SplashRedirectToTargetPageEvent(
          const RouteAuthenticationTarget(RouteAuthenticationPage.home)));

      return;
    }

    sendEvent(SplashRedirectToTargetPageEvent(targetPage));
  }

  Future<bool> _attemptBiometricAuth() async {
    await _biometricBloc.tryUsingBiometricAuthentication();
    final biometricState = _biometricBloc.currentState;
    if (biometricState is BiometricAuthenticationSuccessState) {
      return true;
    }
    return false;
  }

  Future<bool> _saveMobileSettings() async {
    setState(SplashLoadingState());
    try {
      await _saveMobileSettingsUseCase.execute();
      setState(SplashSuccessState());
      return true;
    } on Exception catch (e) {
      if (e is NetworkException ||
          _localSettingsRepository.getMobileSettings() == null) {
        setState(_mapExceptionToErrorState(e));
        return false;
      }
      return true;
    }
  }
}

SplashBaseErrorState _mapExceptionToErrorState(Exception e) {
  if (e is NetworkException) {
    return SplashNetworkErrorState();
  }
  return SplashErrorState();
}

SplashBloc useSplashBloc() =>
    ModuleProvider.of<SplashModule>(useContext()).splashBloc
      .._biometricBloc.localizedStrings = useLocalizedStrings();
