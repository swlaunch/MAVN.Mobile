import 'package:lykke_mobile_mavn/feature_change_password/analytics/change_password_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc.dart';
import 'package:lykke_mobile_mavn/feature_change_password/use_case/change_password_use_case.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ChangePasswordModule extends Module {
  ChangePasswordBloc get changePasswordBloc => get();

  ChangePasswordAnalyticsManager get changePasswordAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => ChangePasswordAnalyticsManager(get()));

    provideSingleton(() => ChangePasswordUseCase(get(), get()));

    provideSingleton(() => ChangePasswordBloc(get(), get(), get(), get()));
  }
}
