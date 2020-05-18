import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';

class LinkSimpleWalletState extends BaseState {}

class LinkSimpleWalletUninitializedState extends LinkSimpleWalletState {}

class LinkSimpleWalletLoadingState extends LinkSimpleWalletState {}

class LinkSimpleWalletLoadedState extends LinkSimpleWalletState {
  LinkSimpleWalletLoadedState(this.url);

  final String url;

  @override
  List get props => [url];
}

class LinkSimpleWalletErrorState extends LinkSimpleWalletState {
  LinkSimpleWalletErrorState(this.message);

  final LocalizedStringBuilder message;

  @override
  List get props => [message];
}
