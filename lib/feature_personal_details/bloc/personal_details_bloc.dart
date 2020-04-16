import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/personal_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/di/personal_details_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PersonalDetailsBloc extends Bloc<PersonalDetailsState> {
  PersonalDetailsBloc(this._customerRepository);

  final CustomerRepository _customerRepository;

  @override
  PersonalDetailsState initialState() => PersonalDetailsUninitializedState();

  Future<void> getCustomerInfo() async {
    setState(PersonalDetailsLoadingState());

    try {
      final customerResponse = await _customerRepository.getCustomer();

      if (customerResponse != null) {
        setState(PersonalDetailsLoadedState(customer: customerResponse));
      } else {
        setState(PersonalDetailsGenericErrorState());
      }
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(PersonalDetailsNetworkErrorState());
        return;
      }

      setState(PersonalDetailsGenericErrorState());
    }
  }
}

PersonalDetailsBloc usePersonalDetailsBloc() =>
    ModuleProvider.of<PersonalDetailsModule>(useContext()).personalDetailsBloc;
