import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class BaseState extends BlocState {}

mixin BaseLoadingState on BaseState {}

mixin BaseErrorState on BaseState {}

mixin BaseDetailedErrorState on BaseState {
  LocalizedStringBuilder get title;

  LocalizedStringBuilder get subtitle;

  String get asset;

  @override
  List get props => super.props..addAll([title, subtitle, asset]);
}

mixin BaseInlineErrorState on BaseState {
  LocalizedStringBuilder get errorMessage;

  @override
  List get props => super.props..addAll([errorMessage]);
}

mixin BaseNetworkErrorState on BaseState {}
