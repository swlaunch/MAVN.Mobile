import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class LinkedWalletSendState extends BaseState {}

abstract class LinkedWalletSendEvent extends BlocEvent {}

class LinkedWalletSendUninitializedState extends LinkedWalletSendState {}

class LinkedWalletSendErrorState extends LinkedWalletSendState {
  LinkedWalletSendErrorState(this.message);

  final LocalizedStringBuilder message;

  @override
  List get props => [message];
}

class LinkedWalletSendLoadingState extends LinkedWalletSendState {}

class LinkedWalletSendErrorEvent extends LinkedWalletSendEvent {
  LinkedWalletSendErrorEvent(this.message);

  final LocalizedStringBuilder message;

  @override
  List get props => [message];
}

class LinkedWalletSendLoadedEvent extends LinkedWalletSendEvent {
  LinkedWalletSendLoadedEvent();
}

class LinkedWalletSendLoadedState extends LinkedWalletSendState {
  LinkedWalletSendLoadedState();
}
