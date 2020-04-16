import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc_output.dart';

class CustomerBloc extends Bloc<CustomerState> {
  CustomerBloc(
    this._customerRepository,
    this._exceptionToMessageMapper,
  );

  final CustomerRepository _customerRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  CustomerState initialState() => CustomerUninitializedState();

  Future<void> getCustomer() async {
    setState(CustomerLoadingState());

    try {
      final customer = await _customerRepository.getCustomer();
      setState(CustomerLoadedState(customer));
      sendEvent(CustomerLoadedEvent(customer));
    } on Exception catch (e) {
      mapExceptionToErrorState(e);
    }
  }

  void mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      setState(CustomerNetworkErrorState());
    } else {
      setState(CustomerErrorState(_exceptionToMessageMapper.map(e)));
    }
  }
}

CustomerBloc useCustomerBloc() =>
    ModuleProvider.of<AppModule>(useContext()).customerBloc;
