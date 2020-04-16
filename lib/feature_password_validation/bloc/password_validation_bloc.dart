import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/di/password_validation_module.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/util/password_validation_rules.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PasswordValidationBloc extends Bloc<PasswordValidationState> {
  PasswordValidationBloc(this.getMobileSettingsUseCase);

  final GetMobileSettingsUseCase getMobileSettingsUseCase;

  @override
  PasswordValidationState initialState() =>
      PasswordValidationUninitializedState();

  Future<void> validatePassword(String password) async {
    final passwordStrength = currentState is PasswordValidationLoadedState
        ? (currentState as PasswordValidationLoadedState).passwordStrength
        : getMobileSettingsUseCase.execute().passwordStrength;

    final passwordValidationList = passwordStrength != null
        ? [
            PasswordMinLengthValidationRule(
                minCharacters: passwordStrength.minLength, password: password),
            PasswordUpperCaseValidationRule(
                minUpperCaseCharacters: passwordStrength.minUpperCase,
                password: password),
            PasswordLowerCaseValidationRule(
                minLowerCaseCharacters: passwordStrength.minLowerCase,
                password: password),
            PasswordNumbersValidationRule(
                minNumericCharacters: passwordStrength.minNumbers,
                password: password),
            PasswordSpecialCharactersValidationRule(
                minSpecialCharacters: passwordStrength.minSpecialSymbols,
                specialCharacters: passwordStrength.specialCharacters,
                password: password),
          ]
        : [];

    setState(PasswordValidationLoadedState(
        passwordValidationList: passwordValidationList,
        passwordStrength: passwordStrength));
  }
}

PasswordValidationBloc usePasswordValidationBloc() =>
    ModuleProvider.of<PasswordValidationModule>(useContext())
        .passwordValidationBloc;
