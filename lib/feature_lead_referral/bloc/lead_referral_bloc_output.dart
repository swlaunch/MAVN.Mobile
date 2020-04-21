import 'package:equatable/equatable.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class LeadReferralState extends BlocState {}

class LeadReferralUninitializedState extends LeadReferralState {}

class LeadReferralSubmissionLoadingState extends LeadReferralState {}

class LeadReferralSubmissionErrorState extends LeadReferralState
    with EquatableMixin {
  LeadReferralSubmissionErrorState({this.error, this.canRetry});

  final LocalizedStringBuilder error;
  final bool canRetry;

  @override
  List get props => super.props..addAll([error, canRetry]);
}

class LeadReferralSubmissionSuccessEvent extends BlocEvent {}
