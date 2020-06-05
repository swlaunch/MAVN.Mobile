import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/login_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/feature_register/use_case/register_use_case.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('Register use case tests', () {
    final CustomerRepository _mockCustomerRepository = MockCustomerRepository();
    final TokenRepository _mockTokenRepository = MockTokenRepository();
    final UserRepository _mockUserRepository = MockUserRepository();
    final SharedPreferencesManager _mockSharedPreferencesManager =
        MockSharedPreferencesManager();

    setUp(() {
      reset(_mockCustomerRepository);
      reset(_mockTokenRepository);
      reset(_mockUserRepository);
    });

    final stubLoginResponse =
        LoginResponseModel(token: TestConstants.stubLoginToken);

    test('execute', () async {
      when(_mockSharedPreferencesManager.read(
              key: SharedPreferencesKeys.appReferralCode))
          .thenReturn(TestConstants.stubReferralCode);

      when(_mockCustomerRepository.login(any, any))
          .thenAnswer((_) => Future.value(stubLoginResponse));

      final subject = RegisterUseCase(
        _mockCustomerRepository,
        _mockTokenRepository,
        _mockUserRepository,
        _mockSharedPreferencesManager,
      );

      await subject.execute(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      verify(_mockCustomerRepository.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
        referralCode: TestConstants.stubReferralCode,
      ));

      verify(_mockCustomerRepository.login(
              TestConstants.stubEmail, TestConstants.stubPassword))
          .called(1);
      verify(_mockTokenRepository.setLoginToken(TestConstants.stubLoginToken))
          .called(1);
      verify(_mockUserRepository.setCustomerEmail(TestConstants.stubEmail))
          .called(1);
      verify(_mockUserRepository
              .setCustomerPassword(TestConstants.stubPassword))
          .called(1);
      verify(_mockSharedPreferencesManager.remove(
          key: SharedPreferencesKeys.appReferralCode));
    });
  });
}
