import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PasswordValidationModule extends Module {
  PasswordValidationBloc get passwordValidationBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => PasswordValidationBloc(get()));
  }
}
