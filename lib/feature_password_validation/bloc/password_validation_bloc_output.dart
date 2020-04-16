import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/response_model/mobile_settings_response_model.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/util/password_validation_rules.dart';

import '../../base/common_blocs/base_bloc_output.dart';

abstract class PasswordValidationState extends BaseState {}

class PasswordValidationUninitializedState extends PasswordValidationState {}

class PasswordValidationLoadingState extends PasswordValidationState
    with BaseLoadingState {}

class PasswordValidationLoadedState extends PasswordValidationState {
  PasswordValidationLoadedState({
    this.passwordValidationList,
    this.passwordStrength,
  });

  List<PasswordValidationRule> passwordValidationList;

  PasswordStrength passwordStrength;
}
