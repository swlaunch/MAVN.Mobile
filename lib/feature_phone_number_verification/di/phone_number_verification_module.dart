import 'package:lykke_mobile_mavn/feature_phone_number_verification/analytics/phone_number_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/set_phone_number_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PhoneNumberVerificationModule extends Module {
  SetPhoneNumberBloc get setPhoneNumberBloc => get();

  PhoneNumberVerificationBloc get phoneNumberVerificationBloc => get();

  PhoneVerificationGenerationBloc get phoneVerificationGenerationBloc => get();

  PhoneNumberVerificationAnalyticsManager
      get phoneNumberVerificationAnalyticsManager => get();

  @override
  void provideInstances() {
    provideSingleton(() => SetPhoneNumberBloc(get(), get()));
    provideSingleton(() => PhoneNumberVerificationBloc(get(), get(), get()));
    provideSingleton(() => PhoneVerificationGenerationBloc(get()));
    provideSingleton(() => PhoneNumberVerificationAnalyticsManager(get()));
  }
}
