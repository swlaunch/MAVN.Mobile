import 'package:lykke_mobile_mavn/feature_login/anaytics/login_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_form_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class LoginModule extends Module {
  LoginAnalyticsManager get loginAnalyticsManager => get();

  LoginFormBloc get loginFormBloc => get();
  @override
  void provideInstances() {
    // AnalyticsManager
    provideSingleton(() => LoginAnalyticsManager(get()));
    provideSingleton(() => LoginFormBloc(get()));
  }
}
