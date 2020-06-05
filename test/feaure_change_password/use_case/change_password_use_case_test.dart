import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/change_password_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/feature_change_password/use_case/change_password_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('Change Password use case tests', () {
    final CustomerRepository mockCustomerRepository = MockCustomerRepository();
    final TokenRepository mockTokenRepository = MockTokenRepository();

    const stubToken = '123';
    final stubChangePasswordResponse =
        ChangePasswordResponseModel(token: stubToken);

    test('execute', () async {
      when(mockCustomerRepository.changePassword(
              password: anyNamed('password')))
          .thenAnswer((_) => Future.value(stubChangePasswordResponse));

      final subject =
          ChangePasswordUseCase(mockCustomerRepository, mockTokenRepository);

      await subject.execute(TestConstants.stubPassword);

      verify(
        mockCustomerRepository.changePassword(
            password: TestConstants.stubPassword),
      ).called(1);
      verify(mockTokenRepository.setLoginToken(stubToken)).called(1);
    });
  });
}
