import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_login/use_case/login_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc_output.dart';

class LoginBloc extends Bloc<LoginState> {
  LoginBloc(
    this._loginUseCase,
    this._exceptionToMessageMapper,
  );

  final LoginUseCase _loginUseCase;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  LoginState initialState() => LoginUninitializedState();

  Future<void> clear() {
    setState(LoginUninitializedState());
  }

  Future<void> login(String email, String password) async {
    setState(LoginLoadingState());

    try {
      await _loginUseCase.execute(email?.trim(), password);
      setState(LoginSuccessState());
      sendEvent(LoginSuccessEvent());
    } on Exception catch (e) {
      final errorMessage = _exceptionToMessageMapper.map(e);

      if (e is ServiceException &&
          e.exceptionType == ServiceExceptionType.customerBlocked) {
        sendEvent(LoginErrorDeactivatedAccountEvent());
      } else {
        setState(LoginErrorState(errorMessage));
      }
    }
  }
}

LoginBloc useLoginBloc() =>
    ModuleProvider.of<AppModule>(useContext()).loginBloc;
