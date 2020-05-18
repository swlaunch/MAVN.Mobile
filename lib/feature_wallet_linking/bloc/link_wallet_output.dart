import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import 'link_wallet_bloc.dart';

abstract class LinkWalletState extends BaseState {}

abstract class LinkWalletEvent extends BlocEvent {}

class LinkWalletUninitializedState extends LinkWalletState {}

class LinkWalletErrorState extends LinkWalletState {
  LinkWalletErrorState(this.message);

  final String message;

  @override
  List get props => [message];
}

class LinkWalletErrorEvent extends LinkWalletEvent {
  LinkWalletErrorEvent(this.message);

  final LocalizedStringBuilder message;

  @override
  List get props => [message];
}

class LinkWalletLoadedEvent extends LinkWalletEvent {
  LinkWalletLoadedEvent(this.type);

  final LinkWalletType type;

  @override
  List get props => [type];
}
