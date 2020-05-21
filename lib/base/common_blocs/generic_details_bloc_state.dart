import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';

import '../../base/common_blocs/base_bloc_output.dart';

abstract class GenericDetailsState<T> extends BaseState {}

class GenericDetailsUninitializedState extends GenericDetailsState {}

class GenericDetailsLoadingState extends GenericDetailsState
    with BaseLoadingState {}

class GenericDetailsLoadedState<T> extends GenericDetailsState {
  GenericDetailsLoadedState({@required this.details});

  final T details;
}

class GenericDetailsErrorState extends GenericDetailsState {
  GenericDetailsErrorState({@required this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class GenericDetailsNetworkErrorState extends GenericDetailsState
    with BaseNetworkErrorState {}
