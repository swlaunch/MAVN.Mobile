import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/feature_change_password/analytics/change_password_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_change_password/bloc/change_password_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_change_password/di/change_password_module.dart';
import 'package:lykke_mobile_mavn/feature_change_password/use_case/change_password_use_case.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordState> {
  ChangePasswordBloc(
    this._changePasswordUseCase,
    this._analyticsManager,
    this._userRepository,
    this._exceptionToMessageMapper,
  );

  final ChangePasswordUseCase _changePasswordUseCase;
  final ChangePasswordAnalyticsManager _analyticsManager;
  final UserRepository _userRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  ChangePasswordState initialState() => ChangePasswordUninitializedState();

  Future<void> changePassword({@required String password}) async {
    setState(ChangePasswordLoadingState());

    try {
      await _changePasswordUseCase.execute(password);

      await _analyticsManager.changePasswordDone();
      await _userRepository.setCustomerPassword(password);
      sendEvent(ChangePasswordSuccessEvent());
    } on Exception catch (e) {
      await _analyticsManager.changePasswordFailed();

      setState(_mapExceptionToErrorMessage(e));
    }
  }

  ChangePasswordState _mapExceptionToErrorMessage(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    if (e is ServiceException) {
      return ChangePasswordInlineErrorState(errorMessage);
    }

    return ChangePasswordErrorState(errorMessage);
  }
}

ChangePasswordBloc useChangePasswordBloc() =>
    ModuleProvider.of<ChangePasswordModule>(useContext()).changePasswordBloc;
