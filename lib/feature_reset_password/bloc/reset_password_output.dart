import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class ResetPasswordState extends BaseState {}

abstract class ResetPasswordEvent extends BlocEvent {}

class ResetPasswordUninitializedState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState
    with BaseLoadingState {}

class ResetPasswordErrorState extends ResetPasswordState
    with BaseInlineErrorState {
  ResetPasswordErrorState({@required this.errorMessage});

  @override
  LocalizedStringBuilder errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

class ResetPasswordSentEmailState extends ResetPasswordState {}

class ResetPasswordSentEmailEvent extends ResetPasswordEvent {}

class ResetPasswordChangedState extends ResetPasswordState {}

class ResetPasswordChangedEvent extends ResetPasswordEvent {}
