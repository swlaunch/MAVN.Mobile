import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class CustomerState extends BaseState {}

class CustomerUninitializedState extends CustomerState {}

class CustomerLoadingState extends CustomerState with BaseLoadingState {}

abstract class CustomerBaseErrorState extends CustomerState {}

class CustomerNetworkErrorState extends CustomerBaseErrorState {}

class CustomerErrorState extends CustomerBaseErrorState {
  CustomerErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class CustomerLoadedState extends CustomerState {
  CustomerLoadedState(this.customer);

  final CustomerResponseModel customer;
}

class CustomerLoadedEvent extends BlocEvent {
  CustomerLoadedEvent(this.customer);

  final CustomerResponseModel customer;
}
