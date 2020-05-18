import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/real_estate_property_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/di/real_estate_property_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PropertyListBloc extends Bloc<PropertyListState> {
  PropertyListBloc(this._spendRepository);

  final SpendRepository _spendRepository;

  @override
  PropertyListState initialState() => PropertyListUninitializedState();

  Future<void> loadProperties(String spendRuleId) async {
    setState(PropertyListLoadingState());

    try {
      final response =
          await _spendRepository.getProperties(spendRuleId: spendRuleId);

      if (response.properties.isNotEmpty) {
        setState(PropertyListLoadedState(properties: response.properties));
      } else {
        setState(PropertyListEmptyState());
      }
    } on Exception catch (exception) {
      setState(exception is NetworkException
          ? PropertyListNetworkErrorState()
          : PropertyListErrorState());
    }
  }
}

PropertyListBloc usePropertyListBloc() =>
    ModuleProvider.of<RealEstatePropertyModule>(useContext())
        .realEstatePropertyListBloc;
