import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class LoginFormState extends BlocState {}

class LoginFormUninitializedState extends LoginFormState {}

class LoginFormEmailFetchedEvent extends BlocEvent {
  LoginFormEmailFetchedEvent(this.email);

  final String email;

  @override
  List get props => super.props..addAll([email]);
}
