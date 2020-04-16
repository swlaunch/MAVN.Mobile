import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PersonalDetailsModule extends Module {
  PersonalDetailsBloc get personalDetailsBloc => get();

  @override
  void provideInstances() {
    // Bloc
    provideSingleton(() => PersonalDetailsBloc(get()));
  }
}
