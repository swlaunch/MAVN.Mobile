import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class BaseState extends BlocState {}

mixin BaseLoadingState on BaseState {}

mixin BaseErrorState on BaseState {}

mixin BaseDetailedErrorState on BaseState {
  String get title;

  String get subtitle;

  String get asset;

  @override
  List get props => super.props..addAll([title, subtitle, asset]);
}

mixin BaseInlineErrorState on BaseState {
  String get errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

mixin BaseNetworkErrorState on BaseState {}
