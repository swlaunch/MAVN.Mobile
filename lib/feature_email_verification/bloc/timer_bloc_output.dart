import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class TimerState extends BlocState {}

class TimerUninitializedState extends TimerState {}

class TimerFinishedEvent extends BlocEvent {}
