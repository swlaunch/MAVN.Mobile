import 'package:equatable/equatable.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class HotelReferralState extends BlocState {}

class HotelReferralUninitializedState extends HotelReferralState {}

class HotelReferralSubmissionLoadingState extends HotelReferralState {}

class HotelReferralSubmissionErrorState extends HotelReferralState
    with EquatableMixin {
  HotelReferralSubmissionErrorState({this.error, this.canRetry = false});

  final LocalizedStringBuilder error;
  final bool canRetry;

  @override
  List get props => super.props..addAll([error, canRetry]);
}

class HotelReferralSubmissionSuccessEvent extends BlocEvent {}
