import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:meta/meta.dart';

abstract class PropertyListState extends BaseState {}

class PropertyListUninitializedState extends PropertyListState {}

class PropertyListLoadingState extends PropertyListState with BaseLoadingState {
}

class PropertyListLoadedState extends PropertyListState {
  PropertyListLoadedState({@required this.properties});

  final List<Property> properties;

  @override
  List get props => super.props..addAll([properties]);
}

class PropertyListEmptyState extends PropertyListState {}

class PropertyListNetworkErrorState extends PropertyListState
    with BaseNetworkErrorState {}

class PropertyListErrorState extends PropertyListState {}
