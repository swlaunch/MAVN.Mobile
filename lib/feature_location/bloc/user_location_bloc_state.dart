import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/feature_location/util/user_position.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class UserLocationState extends BlocState {}

abstract class UserLocationEvent extends BlocEvent {}

class UserLocationUninitializedState extends UserLocationState {}

class UserLocationPermissionGrantedState extends UserLocationState {}

class UserLocationPermissionDeniedState extends UserLocationState {}

class UserLocationServiceDisabledState extends UserLocationState {}

class UserLocationDoNotUseLocationState extends UserLocationState {}

class UserLocationLoadedState extends UserLocationState {
  UserLocationLoadedState({@required this.userPosition});

  final UserPosition userPosition;

  @override
  List<Object> get props => [userPosition];
}

class UserLocationServiceDisabledEvent extends UserLocationEvent {}

class UserLocationPermissionDeniedEvent extends UserLocationEvent {}

class UserLocationDoNotUseLocationEvent extends UserLocationEvent {}

class UserLocationFetchedLocationEvent extends UserLocationEvent {
  UserLocationFetchedLocationEvent({@required this.userPosition});

  final UserPosition userPosition;

  @override
  List<Object> get props => [userPosition];
}
