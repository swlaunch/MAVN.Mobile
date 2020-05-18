import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PinState extends BlocState {}

abstract class PinEvent extends BlocEvent {}

class PinEmptyState extends PinState {}

class PinLoadingState extends PinState {}

class PinLoadingEvent extends PinEvent {}

class PinLoadedEvent extends PinEvent {}

class PinStoredState extends PinState {}

class PinStoredEvent extends PinEvent {}

class PinSignInState extends PinState {}

class PinSignInEvent extends PinEvent {}

class PinReachedMaximumAttemptsState extends PinState {}

class PinReachedMaximumAttemptsEvent extends PinEvent {}

class PinFilledState extends PinState {
  PinFilledState({
    @required this.digits,
    @required this.isHidden,
    @required this.isSubmitVisible,
  });

  final List<int> digits;
  final bool isHidden;
  final bool isSubmitVisible;
}

class PinErrorState extends PinFilledState {
  PinErrorState({
    @required List<int> digits,
    @required bool isHidden,
    @required bool isSubmitVisible,
    @required this.error,
  }) : super(
            digits: digits,
            isHidden: isHidden,
            isSubmitVisible: isSubmitVisible);

  final LocalizedStringBuilder error;
}
