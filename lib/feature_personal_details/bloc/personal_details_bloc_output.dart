import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PersonalDetailsState extends BlocState {}

class PersonalDetailsUninitializedState extends PersonalDetailsState {}

class PersonalDetailsLoadingState extends PersonalDetailsState {}

class PersonalDetailsGenericErrorState extends PersonalDetailsState {}

class PersonalDetailsNetworkErrorState extends PersonalDetailsState {}

class PersonalDetailsLoadedState extends PersonalDetailsState {
  PersonalDetailsLoadedState({@required this.customer});

  final CustomerResponseModel customer;
}
