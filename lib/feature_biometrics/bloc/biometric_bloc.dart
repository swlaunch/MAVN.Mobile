import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/error_codes.dart' as auth_error_codes;
import 'package:local_auth/local_auth.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'biometric_bloc_output.dart';

const countMaxBiometricsRejections = 3;

class BiometricBloc extends Bloc<BiometricState> {
  BiometricBloc(this._localSettingsRepository, this._localAuthentication,
      this._userRepository, this._loginBloc);

  final LocalSettingsRepository _localSettingsRepository;
  final LocalAuthentication _localAuthentication;
  final UserRepository _userRepository;
  final LoginBloc _loginBloc;

  // Need provide manually
  LocalizedStrings localizedStrings;

  @override
  BiometricState initialState() => BiometricUninitializedState();

  Future<void> tryUsingBiometricAuthentication() async {
    //if the app is returning from the plugin pop up, do not restart the flow
    if (currentState is BiometricAuthenticatingState) return;

    final hasBiometricCapabilities =
        await _localAuthentication.canCheckBiometrics;

    final hasEnabledBiometrics =
        _localSettingsRepository.getUserHasAcceptedBiometricAuthentication();

    if (!hasBiometricCapabilities && !hasEnabledBiometrics) {
      _neverAskForAuthenticationAgain();
      return;
    }

    if (hasEnabledBiometrics) {
      await doAuthenticate();
    } else if (_shouldAskUserToEnableBiometrics()) {
      setState(BiometricRequirePermissionState());
    } else {
      setState(BiometricCannotAuthenticateState());
      sendEvent(BiometricAuthenticationWillNotAuthenticateEvent());
    }
  }

  Future<void> tryUsingBiometricAuthenticationWithAgreedPermission() async {
    await clear();

    await setBiometricAuthenticationPermission(hasAgreed: true);

    await tryUsingBiometricAuthentication();
  }

  Future<bool> shouldAskUserToEnableBiometrics() async =>
      await _localAuthentication.canCheckBiometrics &&
      !_localSettingsRepository.getUserHasAcceptedBiometricAuthentication() &&
      _shouldAskUserToEnableBiometrics();

  Future<bool> get isBiometricEnabled async {
    if (!_localSettingsRepository.getUserHasAcceptedBiometricAuthentication()) {
      return false;
    }

    final availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();

    return availableBiometrics.isNotEmpty;
  }

  Future<void> doAuthenticate() async {
    try {
      if (currentState is! BiometricUninitializedState &&
          currentState is! BiometricRequirePermissionState &&
          currentState is! BiometricAuthenticationFailedState) return;
      setState(BiometricAuthenticatingState());
      if (!await _userRepository.hasBeenPreviouslyLoggedIn()) {
        setState(BiometricAuthenticationFailedState());
        sendEvent(BiometricAuthenticationFailedEvent());
        return;
      }

      final didAuthenticate =
          await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
            localizedStrings?.biometricAuthenticationPromptMessage ??
                'PromptMessage',
        androidAuthStrings: AndroidAuthMessages(
          fingerprintHint: '',
          signInTitle: localizedStrings?.biometricAuthenticationPromptTitle ??
              'PromptTitle',
        ),
        stickyAuth: true,
      );

      if (didAuthenticate) {
        await _doSignIn();
      } else {
        setState(BiometricAuthenticationFailedState());
        sendEvent(BiometricAuthenticationFailedEvent());
      }
    } on Exception catch (e) {
      if (e is PlatformException) {
        if (e.code == auth_error_codes.notAvailable &&
            e.message.contains('denied')) {
          setState(BiometricAuthenticationDisabledState());
          sendEvent(BiometricAuthenticationDisabledEvent());

          return;
        }

        if ([
          auth_error_codes.lockedOut,
          auth_error_codes.permanentlyLockedOut,
          auth_error_codes.otherOperatingSystem,
          auth_error_codes.notAvailable,
        ].contains(e.code)) {
          _neverAskForAuthenticationAgain();
          return;
        }
      }

      setState(BiometricAuthenticationFailedState());
      sendEvent(BiometricAuthenticationFailedEvent());
    }
  }

  Future<bool> toggleBiometrics({bool enable}) =>
      enable == true ? _enableBiometric() : _disableBiometric();

  Future<bool> _enableBiometric() async {
    try {
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

      if (!canCheckBiometrics) {
        sendEvent(BiometricAuthenticationDisabledEvent());
        return false;
      }

      final enabledBiometric =
          (await _localAuthentication.getAvailableBiometrics()).isNotEmpty;

      if (!enabledBiometric) {
        await _localAuthentication.authenticateWithBiometrics(
          localizedReason:
              localizedStrings?.biometricAuthenticationPromptMessage ??
                  'PromptMessage',
          androidAuthStrings: AndroidAuthMessages(
            fingerprintHint: '',
            signInTitle:
                localizedStrings?.biometricAuthenticationPromptTitle ??
                    'PromptTitle',
          ),
          stickyAuth: true,
        );
      }

      await _localSettingsRepository.setUserHasAcceptedBiometricAuthentication(
          accepted: true);

      return true;
    } catch (e) {
      sendEvent(BiometricAuthenticationDisabledEvent());
      return false;
    }
  }

  Future<bool> _disableBiometric() async {
    await _localSettingsRepository.setUserHasAcceptedBiometricAuthentication(
        accepted: false);

    return true;
  }

  Future<void> clear() async {
    setState(BiometricUninitializedState());
  }

  Future<void> _doSignIn() async {
    final email = await _userRepository.getCustomerEmail();
    final password = await _userRepository.getCustomerPassword();
    await _loginBloc.login(email, password);
    final loginBlocState = _loginBloc.currentState;
    if (loginBlocState is LoginSuccessState) {
      setState(BiometricAuthenticationSuccessState());
      sendEvent(BiometricAuthenticationSuccessEvent());
    } else if (loginBlocState is LoginErrorState) {
      setState(BiometricAuthenticationFailedState());
      sendEvent(BiometricAuthenticationFailedEvent());
    }
  }

  Future<void> setBiometricAuthenticationPermission({bool hasAgreed}) async {
    if (hasAgreed) {
      await _acceptBiometricAuthentication();
    } else {
      await _declineBiometricAuthentication();
    }
  }

  Future<void> _acceptBiometricAuthentication() async {
    await _localSettingsRepository.setUserHasAcceptedBiometricAuthentication(
        accepted: true);

    sendEvent(BiometricAuthenticationApprovedEvent());
  }

  Future<void> _declineBiometricAuthentication() async {
    final countRejections =
        _localSettingsRepository.getCountBiometricRejections() ?? 0;

    await _localSettingsRepository.setUserHasAcceptedBiometricAuthentication(
        accepted: false);

    _localSettingsRepository
      ..setCountBiometricRejections(countRejections + 1)
      ..setLastBiometricRejectionTimeStamp(
          DateTime.now().millisecondsSinceEpoch);

    setState(BiometricCannotAuthenticateState());
    sendEvent(BiometricAuthenticationDeclinedEvent());
  }

  void _neverAskForAuthenticationAgain() {
    _localSettingsRepository
      ..setUserHasAcceptedBiometricAuthentication(accepted: false)
      ..setCountBiometricRejections(countMaxBiometricsRejections + 1);

    setState(BiometricCannotAuthenticateState());
    sendEvent(BiometricAuthenticationWillNotAuthenticateEvent());
  }

  bool _shouldAskUserToEnableBiometrics() {
    final countRejectedBiometrics =
        _localSettingsRepository.getCountBiometricRejections();

    final lastRejectedBiometricsDate =
        _localSettingsRepository.getLastBiometricRejectionTimeStamp();

    return (countRejectedBiometrics == null ||
            countRejectedBiometrics < countMaxBiometricsRejections) &&
        (lastRejectedBiometricsDate == null ||
            DateTime.fromMillisecondsSinceEpoch(lastRejectedBiometricsDate)
                    .day !=
                DateTime.now().day);
  }
}

BiometricBloc useBiometricBloc() =>
    ModuleProvider.of<AppModule>(useContext()).biometricBloc
      ..localizedStrings = useLocalizedStrings();
