import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ResetPasswordModule extends Module {
  ResetPasswordBloc get resetPasswordBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => ResetPasswordBloc(get(), get()));
  }
}
