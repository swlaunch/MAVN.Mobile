import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/login_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/feature_login/use_case/login_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

const stubEmail = 'stubEmail';
const stubPassword = 'stubPassword';
const stubReferralCode = 'stubReferralCode';

void main() {
  group('Login use case tests', () {
    final CustomerRepository mockCustomerRepository = MockCustomerRepository();
    final TokenRepository mockTokenRepository = MockTokenRepository();
    final UserRepository mockUserRepository = MockUserRepository();

    const stubToken = '123';
    final stubLoginResponse = LoginResponseModel(token: stubToken);
    const stubEmail = 'test@example.com';
    const stubPassword = 'password';

    test('execute', () async {
      when(mockCustomerRepository.login(any, any))
          .thenAnswer((_) => Future.value(stubLoginResponse));

      final subject = LoginUseCase(
          mockCustomerRepository, mockTokenRepository, mockUserRepository);

      await subject.execute(stubEmail, stubPassword);

      verify(mockCustomerRepository.login(stubEmail, stubPassword)).called(1);
      verify(mockTokenRepository.setLoginToken(stubToken)).called(1);
      verify(mockUserRepository.setCustomerEmail(stubEmail)).called(1);
    });
  });
}
