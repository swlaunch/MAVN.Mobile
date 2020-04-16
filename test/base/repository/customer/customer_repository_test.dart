import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/change_password_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/login_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/register_request_model.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('CustomerRepository tests', () {
    final _mockCustomerApi = MockCustomerApi();
    final _subject = CustomerRepository(_mockCustomerApi);

    setUp(() {
      reset(_mockCustomerApi);
    });

    test('login', () async {
      final mockLoginResponseModel = MockLoginResponseModel();

      when(_mockCustomerApi.login(any))
          .thenAnswer((_) => Future.value(mockLoginResponseModel));

      final loginResult = await _subject.login(
          TestConstants.stubEmail, TestConstants.stubPassword);

      expect(loginResult, mockLoginResponseModel);

      final capturedLoginRequestModel =
          verify(_mockCustomerApi.login(captureAny)).captured[0]
              as LoginRequestModel;

      expect(capturedLoginRequestModel.email, TestConstants.stubEmail);
      expect(capturedLoginRequestModel.password, TestConstants.stubPassword);
    });

    test('register', () async {
      when(_mockCustomerApi.register(any)).thenAnswer((_) => Future.value());

      await _subject.register(
        email: TestConstants.stubEmail,
        password: TestConstants.stubPassword,
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryOfNationalityId: TestConstants.stubCountryId,
      );

      final capturedRegisterRequestModel =
          verify(_mockCustomerApi.register(captureAny)).captured[0]
              as RegisterRequestModel;

      expect(capturedRegisterRequestModel.email, TestConstants.stubEmail);
      expect(capturedRegisterRequestModel.password, TestConstants.stubPassword);
      expect(capturedRegisterRequestModel.referralCode, null);
      expect(
          capturedRegisterRequestModel.firstName, TestConstants.stubFirstName);
      expect(capturedRegisterRequestModel.lastName, TestConstants.stubLastName);
      expect(
        capturedRegisterRequestModel.countryOfNationalityId,
        TestConstants.stubCountryId,
      );
    });

    test('getTransactionHistory default parameters', () {
      _subject.getTransactionHistory();

      verify(_mockCustomerApi.getTransactionHistory(
              currentPage: 1, pageSize: 1))
          .called(1);
    });

    test('getTransactionHistory custom parameters', () {
      _subject.getTransactionHistory(
          currentPage: TestConstants.stubCurrentPage,
          pageSize: TestConstants.stubPageSize);

      verify(_mockCustomerApi.getTransactionHistory(
              currentPage: TestConstants.stubCurrentPage,
              pageSize: TestConstants.stubPageSize))
          .called(1);
    });

    test('change password', () async {
      when(_mockCustomerApi.changePassword(any))
          .thenAnswer((_) => Future.value(MockChangePasswordResponseModel()));

      await _subject.changePassword(password: TestConstants.stubPassword);

      final capturedChangePasswordRequestModel =
          verify(_mockCustomerApi.changePassword(captureAny)).captured[0]
              as ChangePasswordRequestModel;

      expect(capturedChangePasswordRequestModel.password,
          TestConstants.stubPassword);
    });

    test('getCustomer ', () {
      _subject.getCustomer();

      verify(_mockCustomerApi.getCustomer());
    });
  });
}
