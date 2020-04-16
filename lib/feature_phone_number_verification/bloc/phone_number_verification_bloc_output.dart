import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PhoneNumberVerificationState extends BaseState {}

abstract class PhoneNumberVerificationEvent extends BlocEvent {}

abstract class PhoneNumberVerificationBaseErrorState
    extends PhoneNumberVerificationState {}

class PhoneNumberVerifiedEvent extends PhoneNumberVerificationEvent {}

class PhoneNumberVerifiedState extends PhoneNumberVerificationState {}

class PhoneNumberVerificationUninitializedState
    extends PhoneNumberVerificationState {}

class PhoneNumberVerificationLoadingState extends PhoneNumberVerificationState
    with BaseLoadingState {}

class PhoneNumberVerificationErrorState
    extends PhoneNumberVerificationBaseErrorState with BaseInlineErrorState {
  PhoneNumberVerificationErrorState({this.errorMessage = ''});

  @override
  String errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

class PhoneNumberVerificationNetworkErrorState
    extends PhoneNumberVerificationBaseErrorState {}

class PhoneNumberVerificationAlreadyVerifiedErrorEvent
    extends PhoneNumberVerificationEvent {}
