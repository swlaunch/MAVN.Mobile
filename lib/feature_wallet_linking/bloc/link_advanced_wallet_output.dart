import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class LinkAdvancedWalletState extends BaseState {}

class LinkAdvancedWalletUninitializedState extends LinkAdvancedWalletState {}

class LinkAdvancedWalletLoadingState extends LinkAdvancedWalletState {}

class LinkAdvancedWalletErrorState extends LinkAdvancedWalletState {
  LinkAdvancedWalletErrorState(this.message);

  final LocalizedStringBuilder message;
}

class LinkAdvancedWalletSubmissionSuccessEvent extends BlocEvent {}

class LinkAdvancedWalletSubmissionErrorEvent extends BlocEvent {
  LinkAdvancedWalletSubmissionErrorEvent(this.message);

  final LocalizedStringBuilder message;
}
