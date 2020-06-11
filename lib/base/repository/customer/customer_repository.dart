import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/change_password_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/generate_reset_password_link_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/login_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/pin_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/push_notification_registration_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/register_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/request_model/reset_password_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/change_password_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/login_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';

class CustomerRepository {
  CustomerRepository(this._customerApi);

  static const itemsPerPage = 30;

  final CustomerApi _customerApi;

  Future<LoginResponseModel> login(String email, String password) =>
      _customerApi.login(LoginRequestModel(email, password));

  Future<void> logout() => _customerApi.logout();

  Future<void> checkPin(String pin) =>
      _customerApi.checkPin(PinRequestModel(pin: pin));

  Future<void> updatePin(String pin) =>
      _customerApi.updatePin(PinRequestModel(pin: pin));

  Future<void> createPin(String pin) =>
      _customerApi.createPin(PinRequestModel(pin: pin));

  Future<void> register({
    @required String email,
    @required String password,
    @required String firstName,
    @required String lastName,
    int countryOfNationalityId,
    String referralCode,
  }) async {
    await _customerApi.register(
      RegisterRequestModel(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          countryOfNationalityId: countryOfNationalityId,
          referralCode: referralCode),
    );
  }

  Future<void> registerForPushNotifications({
    @required String pushRegistrationToken,
  }) =>
      _customerApi.registerForPushNotifications(
        PushNotificationRegistrationRequestModel(
            pushRegistrationToken: pushRegistrationToken),
      );

  Future<void> unregisterFromPushNotifications(
          {@required String pushRegistrationToken}) =>
      _customerApi.unregisterFromPushNotifications(pushRegistrationToken);

  Future<ChangePasswordResponseModel> changePassword(
          {@required String password}) async =>
      _customerApi
          .changePassword(ChangePasswordRequestModel(password: password));

  Future<void> generateResetPasswordLink({@required String email}) async =>
      _customerApi.generateResetPasswordLink(
          GenerateResetPasswordLinkRequestModel(email: email));

  Future<void> resetPassword({
    @required String email,
    @required String resetIdentifier,
    @required String password,
  }) async =>
      _customerApi.resetPassword(ResetPasswordRequestModel(
          email: email, resetIdentifier: resetIdentifier, password: password));

  Future<CustomerResponseModel> getCustomer() => _customerApi.getCustomer();

  Future<TransactionHistoryResponseModel> getTransactionHistory({
    int currentPage = 1,
    int pageSize = 30,
  }) =>
      _customerApi.getTransactionHistory(
        currentPage: currentPage,
        pageSize: pageSize,
      );

  Future<void> deleteAccount() => _customerApi.deleteAccount();
}
