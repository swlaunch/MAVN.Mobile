import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class UnlinkWalletSubmissionState extends BaseState {}

class UnlinkWalletSubmissionUninitializedState
    extends UnlinkWalletSubmissionState {}

class UnlinkWalletSubmissionEvent extends BlocEvent {}

class UnlinkWalletSubmissionSuccessEvent extends UnlinkWalletSubmissionEvent {}

class UnlinkWalletSubmissionErrorEvent extends UnlinkWalletSubmissionEvent {
  UnlinkWalletSubmissionErrorEvent(this.message);

  final String message;
}
