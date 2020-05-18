import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class TickerState extends BlocState {}

class TickerUninitializedState extends TickerState {}

class TickerEvent extends BlocEvent {}

class TickerTickingState extends TickerState {
  TickerTickingState({this.displayTime});

  final String displayTime;
}

class TickerFinishedState extends TickerState {}

class TickerFinishedEvent extends TickerEvent {}
