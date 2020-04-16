import 'package:lykke_mobile_mavn/base/common_use_cases/clear_secure_storage_use_case.dart';
import 'package:lykke_mobile_mavn/feature_splash/bloc/splash_bloc.dart';
import 'package:lykke_mobile_mavn/feature_splash/use_case/save_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SplashModule extends Module {
  SplashBloc get splashBloc => get();

  SaveMobileSettingsUseCase get fetchMobileSettingsUseCase => get();

  @override
  void provideInstances() {
    provideSingleton(() => SplashBloc(get(), get(), get(), get(), get()));
    provideSingleton(() => SaveMobileSettingsUseCase(get(), get()));
    provideSingleton(() => ClearSecureStorageUseCase(get()));
  }
}
