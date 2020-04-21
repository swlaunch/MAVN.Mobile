import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class FriendReferralState extends BaseState {}

class FriendReferralUninitializedState extends FriendReferralState {}

class FriendReferralSubmissionLoadingState extends FriendReferralState {}

class FriendReferralSubmissionErrorState extends FriendReferralState {
  FriendReferralSubmissionErrorState({this.error, this.canRetry = false});

  final LocalizedStringBuilder error;
  final bool canRetry;

  @override
  List get props => super.props..addAll([error, canRetry]);
}

class FriendReferralSubmissionSuccessEvent extends BlocEvent {}
