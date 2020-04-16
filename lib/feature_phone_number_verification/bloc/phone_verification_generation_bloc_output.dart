import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class PhoneVerificationGenerationState extends BaseState {}

abstract class PhoneVerificationGenerationEvent extends BlocEvent {}

abstract class PhoneVerificationGenerationBaseErrorState
    extends PhoneVerificationGenerationState {}

class PhoneVerificationGenerationUninitializedState
    extends PhoneVerificationGenerationState {}

class PhoneVerificationGenerationLoadingState
    extends PhoneVerificationGenerationState with BaseLoadingState {}

class PhoneVerificationGenerationSentSmsEvent
    extends PhoneVerificationGenerationEvent {}

class PhoneVerificationGenerationSuccessState
    extends PhoneVerificationGenerationState {}

class PhoneVerificationGenerationErrorState
    extends PhoneVerificationGenerationBaseErrorState
    with BaseInlineErrorState {
  PhoneVerificationGenerationErrorState({@required this.errorMessage});

  @override
  String errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

class PhoneVerificationGenerationNetworkErrorState
    extends PhoneVerificationGenerationBaseErrorState {}

class PhoneVerificationGenerationAlreadyVerifiedErrorEvent
    extends PhoneVerificationGenerationEvent {}
