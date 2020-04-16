import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/pin/pin_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class HasPinUseCase {
  HasPinUseCase(this._pinRepository);

  final PinRepository _pinRepository;

  Future<bool> execute() => _pinRepository.hasPin();
}

HasPinUseCase useHasPinUseCase(BuildContext context) =>
    ModuleProvider.of<AppModule>(context).hasPinUseCase;
