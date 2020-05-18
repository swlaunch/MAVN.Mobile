import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class EmailConfirmationState extends BlocState {}

class EmailConfirmationUninitializedState extends EmailConfirmationState {}

class EmailConfirmationLoadingState extends EmailConfirmationState {}

class EmailConfirmationStoredKey extends BlocEvent {}

class EmailConfirmationSuccessEvent extends BlocEvent {}

class EmailConfirmationAlreadyVerifiedEvent extends BlocEvent {}

class EmailConfirmationInvalidCodeEvent extends BlocEvent {}

class EmailConfirmationBaseErrorState extends EmailConfirmationState {}

class EmailConfirmationNetworkErrorState
    extends EmailConfirmationBaseErrorState {}

class EmailConfirmationErrorState extends EmailConfirmationBaseErrorState {
  EmailConfirmationErrorState({this.error, this.canRetry});

  final String error;
  final bool canRetry;

  @override
  List get props => super.props..addAll([error, canRetry]);
}
