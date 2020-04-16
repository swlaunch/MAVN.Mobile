import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';

class LoginUseCase {
  LoginUseCase(
      this._customerRepository, this._tokenRepository, this._userRepository);

  final CustomerRepository _customerRepository;
  final TokenRepository _tokenRepository;
  final UserRepository _userRepository;

  Future<void> execute(String email, String password) async {
    final loginResponse = await _customerRepository.login(email, password);
    final token = loginResponse.token;
    await _tokenRepository.setLoginToken(token);
    await _userRepository.setCustomerEmail(email);
    await _userRepository.setCustomerPassword(password);
  }
}
