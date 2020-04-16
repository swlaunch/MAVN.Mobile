import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class SetPhoneNumberState extends BaseState {}

class SetPhoneNumberEvent extends BlocEvent {}

class SetPhoneNumberUninitializedState extends SetPhoneNumberState {}

class SetPhoneNumberLoadingState extends SetPhoneNumberState
    with BaseLoadingState {}

class SetPhoneNumberSuccessState extends SetPhoneNumberState {}

class SetPhoneNumberBaseErrorState extends SetPhoneNumberState {}

class SetPhoneNumberErrorState extends SetPhoneNumberBaseErrorState {
  SetPhoneNumberErrorState({@required this.errorMessage});

  String errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

class SetPhoneNumberInlineErrorState extends SetPhoneNumberBaseErrorState
    with BaseInlineErrorState {
  SetPhoneNumberInlineErrorState({@required this.errorMessage});

  @override
  String errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

class SetPhoneNumberNetworkErrorState extends SetPhoneNumberBaseErrorState {}
