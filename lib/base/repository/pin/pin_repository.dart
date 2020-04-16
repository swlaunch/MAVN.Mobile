import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';

class PinRepository {
  PinRepository(
    this._customerRepository,
    this._localSettingsRepository,
  );

  final CustomerRepository _customerRepository;
  final LocalSettingsRepository _localSettingsRepository;

  static const String _pinSeparator = '';

  Future<void> setPin(List<int> digits) async {
    final cachedHasPin = await hasPin(useCache: false);
    final pin = digits.join(_pinSeparator);

    cachedHasPin
        ? await _customerRepository.updatePin(pin)
        : await _customerRepository.createPin(pin);

    await _localSettingsRepository.setHasPIN(hasPIN: true);
  }

  Future<bool> checkPin(List<int> digits) async {
    await _customerRepository.checkPin(digits.join(_pinSeparator));
    return true;
  }

  Future<bool> hasPin({bool useCache = true}) async {
    if (useCache == true) {
      final cachedHasPIN = _localSettingsRepository.hasPIN();

      if (cachedHasPIN != null) {
        return cachedHasPIN;
      }
    }

    final customer = await _customerRepository.getCustomer();
    return customer.hasPin;
  }
}
