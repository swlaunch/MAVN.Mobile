import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/di/p2p_receive_token_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'p2p_receive_token_bloc_output.dart';

class P2pReceiveTokenBloc extends Bloc<ReceiveTokenPageState> {
  P2pReceiveTokenBloc(this._customerRepository, this._userRepository);

  final CustomerRepository _customerRepository;
  final UserRepository _userRepository;

  @override
  ReceiveTokenPageState initialState() => ReceiveTokenPageUninitializedState();

  Future<void> getCustomer() async {
    setState(ReceiveTokenPageLoadingState());

    try {
      final email = await _userRepository.getCustomerEmail();
      if (email == null) {
        final CustomerResponseModel customer =
            await _customerRepository.getCustomer();
        setState(ReceiveTokenPageSuccess(customer.email));
      } else {
        setState(ReceiveTokenPageSuccess(email));
      }
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(ReceiveTokenPageErrorState(
          errorTitle: LazyLocalizedStrings.networkErrorTitle,
          errorSubtitle: LazyLocalizedStrings.networkError,
          iconAsset: SvgAssets.networkError,
        ));
        return;
      }

      setState(ReceiveTokenPageErrorState(
        errorTitle: LazyLocalizedStrings.receiveTokenPageGenericErrorTitle,
        errorSubtitle:
            LazyLocalizedStrings.receiveTokenPageGenericErrorSubtitle,
        iconAsset: SvgAssets.genericError,
      ));
    }
  }
}

P2pReceiveTokenBloc useP2PReceiveTokenBloc() =>
    ModuleProvider.of<P2PReceiveTokenModule>(useContext()).p2pReceiveTokenBloc;
