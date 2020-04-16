import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/bloc/reset_password_output.dart';
import 'package:lykke_mobile_mavn/feature_reset_password/di/reset_password_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordState> {
  ResetPasswordBloc(
    this._customerRepository,
    this._exceptionToMessageMapper,
  );

  final CustomerRepository _customerRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  ResetPasswordState initialState() => ResetPasswordUninitializedState();

  /// Send a email with a deep-link to reset the password
  Future<void> sendLink(String email) async {
    setState(ResetPasswordLoadingState());

    try {
      await _customerRepository.generateResetPasswordLink(email: email);
      setState(ResetPasswordSentEmailState());
      sendEvent(ResetPasswordSentEmailEvent());
    } on Exception catch (e) {
      setState(ResetPasswordErrorState(
          errorMessage: _exceptionToMessageMapper.map(e)));
    }
  }

  /// Changed the password via the provided email and resetIdentifier
  Future<void> changePassword({
    @required String email,
    @required String resetIdentifier,
    @required String password,
  }) async {
    setState(ResetPasswordLoadingState());

    try {
      await _customerRepository.resetPassword(
          email: email, resetIdentifier: resetIdentifier, password: password);
      setState(ResetPasswordChangedState());
      sendEvent(ResetPasswordChangedEvent());
    } on Exception catch (e) {
      setState(ResetPasswordErrorState(
          errorMessage: _exceptionToMessageMapper.map(e)));
    }
  }
}

ResetPasswordBloc useResetPasswordBloc() =>
    ModuleProvider.of<ResetPasswordModule>(useContext()).resetPasswordBloc;
