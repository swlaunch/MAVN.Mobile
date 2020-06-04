import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class SmeLinkingState extends BaseState {}

class SmeLinkingUninitializedState extends SmeLinkingState {}

class SmeLinkingSubmissionLoadingState extends SmeLinkingState {}

class SmeLinkingSubmissionSuccessState extends SmeLinkingState {}

class SmeLinkingSubmissionErrorState extends SmeLinkingState {
  SmeLinkingSubmissionErrorState({this.error, this.canRetry = false});

  final LocalizedStringBuilder error;
  final bool canRetry;

  @override
  List get props => super.props..addAll([error, canRetry]);
}

class SmeLinkingNetworkErrorState extends SmeLinkingState {}

class SmeLinkingSubmissionSuccessEvent extends BlocEvent {}
