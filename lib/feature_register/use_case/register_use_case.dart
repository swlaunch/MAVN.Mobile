import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';

class RegisterUseCase {
  RegisterUseCase(
    this._customerRepository,
    this._tokenRepository,
    this._userRepository,
    this._sharedPreferencesManager,
  );

  final CustomerRepository _customerRepository;
  final TokenRepository _tokenRepository;
  final UserRepository _userRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  Future<void> execute({
    @required String email,
    @required String password,
    @required String firstName,
    @required String lastName,
    int countryOfNationalityId,
  }) async {
    final referralCode = _sharedPreferencesManager.read(
          key: SharedPreferencesKeys.appReferralCode,
        ) ??
        '';

    await _customerRepository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      countryOfNationalityId: countryOfNationalityId,
      referralCode: referralCode,
    );

    final loginResponse = await _customerRepository.login(email, password);
    final token = loginResponse.token;
    await _tokenRepository.setLoginToken(token);
    await _userRepository.setCustomerEmail(email);
    await _userRepository.setCustomerPassword(password);
    await _sharedPreferencesManager.remove(
      key: SharedPreferencesKeys.appReferralCode,
    );
  }
}
