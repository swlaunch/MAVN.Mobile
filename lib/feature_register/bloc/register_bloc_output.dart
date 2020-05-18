import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class RegisterState extends BlocState {}

class RegisterUninitializedState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  RegisterErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class RegisterSuccessEvent extends BlocEvent {
  RegisterSuccessEvent({@required this.registrationEmail});

  final String registrationEmail;

  @override
  List get props => super.props..addAll([registrationEmail]);
}
