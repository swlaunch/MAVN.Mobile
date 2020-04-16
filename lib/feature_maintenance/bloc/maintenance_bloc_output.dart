import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class MaintenanceState extends BlocState {}

class MaintenanceStateUninitializedState extends MaintenanceState {
  MaintenanceStateUninitializedState();
}

class MaintenanceLoadingState extends MaintenanceState {}

class MaintenanceSuccessState extends MaintenanceState {}

class MaintenanceErrorState extends MaintenanceState {
  MaintenanceErrorState(this.remainingMaintenanceDuration);

  final String remainingMaintenanceDuration;

  @override
  List get props => super.props..addAll([remainingMaintenanceDuration]);
}

class MaintenanceCloseEvent extends BlocEvent {}
