import 'package:lykke_mobile_mavn/feature_email_verification/analytics/email_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/timer_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EmailVerificationModule extends Module {
  EmailVerificationBloc get emailVerificationBloc => get();

  TimerBloc get timerBloc => get();

  EmailVerificationAnalyticsManager get emailVerificationAnalyticsManager =>
      get();

  @override
  void provideInstances() {
    provideSingleton(() => EmailVerificationBloc(get(), get()));
    provideSingleton(() => TimerBloc());
  }
}
