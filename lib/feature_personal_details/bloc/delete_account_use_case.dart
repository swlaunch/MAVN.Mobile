import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class DeleteAccountUseCase {
  DeleteAccountUseCase(
    this._customerRepository,
    this._exceptionToMessageMapper,
  );

  final CustomerRepository _customerRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  Future<void> execute() async {
    try {
      await _customerRepository.deleteAccount();
    } on Exception catch (e) {
      final errorMessage = _exceptionToMessageMapper.map(e);
      throw CustomException(errorMessage);
    }
  }
}

DeleteAccountUseCase useDeleteAccountUseCase({BuildContext context}) =>
    ModuleProvider.of<AppModule>(context ?? useContext()).deleteAccountUseCase;
