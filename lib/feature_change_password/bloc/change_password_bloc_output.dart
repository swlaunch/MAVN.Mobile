import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class ChangePasswordState extends BaseState {}

class ChangePasswordUninitializedState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState
    with BaseLoadingState {}

class ChangePasswordErrorState extends ChangePasswordState
    with BaseDetailedErrorState {
  ChangePasswordErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);

  @override
  String get asset => null;

  @override
  LocalizedStringBuilder get subtitle => LocalizedStringBuilder.empty();

  @override
  LocalizedStringBuilder get title => error;
}

class ChangePasswordInlineErrorState extends ChangePasswordState
    with BaseInlineErrorState {
  ChangePasswordInlineErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);

  @override
  LocalizedStringBuilder get errorMessage => error;
}

class ChangePasswordSuccessEvent extends BlocEvent {}
