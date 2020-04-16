import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_register/di/register_module.dart';
import 'package:lykke_mobile_mavn/feature_register/use_case/register_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc_output.dart';

class RegisterBloc extends Bloc<RegisterState> {
  RegisterBloc(
    this._registerUseCase,
    this._exceptionToMessageMapper,
  );

  final RegisterUseCase _registerUseCase;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  RegisterState initialState() => RegisterUninitializedState();

  Future<void> register({
    @required String email,
    @required String password,
    @required String firstName,
    @required String lastName,
    int countryOfNationalityId,
  }) async {
    setState(RegisterLoadingState());

    final trimmedEmail = email?.trim();
    try {
      await _registerUseCase.execute(
        email: trimmedEmail,
        password: password,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        countryOfNationalityId: countryOfNationalityId,
      );
      sendEvent(RegisterSuccessEvent(registrationEmail: trimmedEmail));
    } on Exception catch (e) {
      final errorMessage = _exceptionToMessageMapper.map(e);

      setState(RegisterErrorState(errorMessage));
    }
  }
}

RegisterBloc useRegisterBloc() =>
    ModuleProvider.of<RegisterModule>(useContext()).registerBloc;
