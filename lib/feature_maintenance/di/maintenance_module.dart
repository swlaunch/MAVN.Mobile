import 'package:lykke_mobile_mavn/feature_maintenance/bloc/maintenance_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class MaintenanceModule extends Module {
  MaintenanceBloc get maintenanceBloc => get();

  @override
  void provideInstances() {
    // Bloc
    provideSingleton(() => MaintenanceBloc(get()));
  }
}
