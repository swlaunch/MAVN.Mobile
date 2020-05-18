import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class EmailVerificationState extends BlocState {}

class EmailVerificationUninitializedState extends EmailVerificationState {}

class EmailVerificationLoadingState extends EmailVerificationState {}

class EmailVerificationSuccessState extends EmailVerificationState {}

class EmailVerificationAlreadyVerifiedEvent extends BlocEvent {}

class EmailVerificationBaseErrorState extends EmailVerificationState {}

class EmailVerificationNetworkErrorState
    extends EmailVerificationBaseErrorState {}

class EmailVerificationErrorState extends EmailVerificationBaseErrorState {
  EmailVerificationErrorState({this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}
