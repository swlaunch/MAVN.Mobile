import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/feature_login/di/login_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormState> {
  LoginFormBloc(
    this._userRepository,
  );

  final UserRepository _userRepository;

  @override
  LoginFormState initialState() => LoginFormUninitializedState();

  Future<void> fetchEmail() async {
    final localEmail = await _userRepository.getCustomerEmail();
    if (localEmail != null) {
      sendEvent(LoginFormEmailFetchedEvent(localEmail));
    }
  }
}

LoginFormBloc useLoginFormBloc() =>
    ModuleProvider.of<LoginModule>(useContext()).loginFormBloc;
