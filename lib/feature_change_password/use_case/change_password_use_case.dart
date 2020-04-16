import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';

class ChangePasswordUseCase {
  ChangePasswordUseCase(this._customerRepository, this._tokenRepository);

  final CustomerRepository _customerRepository;
  final TokenRepository _tokenRepository;

  Future<void> execute(String password) async {
    final changePasswordResponse =
        await _customerRepository.changePassword(password: password);

    final token = changePasswordResponse.token;
    await _tokenRepository.setLoginToken(token);
  }
}
