import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';

class LinkCodeState extends BaseState {}

class LinkCodeUninitializedState extends LinkCodeState {}

class LinkCodeLoadingState extends LinkCodeState {}

class LinkCodeLoadedState extends LinkCodeState {
  LinkCodeLoadedState(this.linkCode);

  final String linkCode;
}

class LinkCodeErrorState extends LinkCodeState {
  LinkCodeErrorState(this.message);

  final String message;
}
