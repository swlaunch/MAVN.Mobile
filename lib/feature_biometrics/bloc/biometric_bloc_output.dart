import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class BiometricState extends BlocState {}

class BiometricUninitializedState extends BiometricState {}

class BiometricRequirePermissionState extends BiometricState {}

class BiometricCannotAuthenticateState extends BiometricState {}

class BiometricAuthenticatingState extends BiometricState {}

class BiometricAuthenticationSuccessState extends BiometricState {}

class BiometricAuthenticationFailedState extends BiometricState {}

class BiometricAuthenticationDisabledState extends BiometricState {}

class BiometricAuthenticationApprovedEvent extends BlocEvent {}

class BiometricAuthenticationDeclinedEvent extends BlocEvent {}

class BiometricAuthenticationSuccessEvent extends BlocEvent {}

class BiometricAuthenticationFailedEvent extends BlocEvent {}

class BiometricAuthenticationDisabledEvent extends BlocEvent {}

class BiometricAuthenticationWillNotAuthenticateEvent extends BlocEvent {}
