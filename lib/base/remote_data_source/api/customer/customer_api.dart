import 'package:flutter/foundation.dart';
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
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/login_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class CustomerApi extends BaseApi {
  CustomerApi(HttpClient httpClient) : super(httpClient);

//region paths
  static const String loginPath = '/auth/login';
  static const String logoutPath = '/auth/logout';
  static const String registerPath = '/customers/register';

  static const String getCustomerPath = '/customers';
  static const String transactionHistoryPath = '/history/operations';
  static const String pushNotificationsRegistrationPath =
      '/pushNotifications/registrations';

  static const String changePasswordPath = '/customers/change-password';
  static const String generateResetPasswordLinkPath =
      '/customers/generateresetpasswordlink';
  static const String resetPasswordPath = '/customers/reset-password';

  static const String deleteAccountPath = '/customers/deactivate';
  static const String pinCheckPath = '/customers/pin/check';
  static const String pinPath = '/customers/pin';

  //endregion paths

  //region query parameters
  static const String currentPageQueryParameterKey = 'CurrentPage';
  static const String pageSizeQueryParameterKey = 'PageSize';
  static const String spendRuleIdQueryParameterKey = 'spendRuleId';
  static const String pushRegistrationTokenQueryParameterKey =
      'PushRegistrationToken';

  //region query parameters

  Future<void> checkPin(PinRequestModel model) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<String>(
          pinCheckPath,
          data: model.toJson(),
        );
      });

  Future<void> createPin(PinRequestModel model) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<String>(
          pinPath,
          data: model.toJson(),
        );
      });

  Future<void> updatePin(PinRequestModel model) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.put<String>(
          pinPath,
          data: model.toJson(),
        );
      });

  Future<void> logout() => exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(logoutPath);
      });

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        final loginResponse = await httpClient.post<Map<String, dynamic>>(
          loginPath,
          data: loginRequestModel.toJson(),
        );

        return LoginResponseModel.fromJson(loginResponse.data);
      }, mapper: LoginMapper());

  Future<void> register(RegisterRequestModel registerRequestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<Map<String, dynamic>>(
          registerPath,
          data: registerRequestModel.toJson(),
        );
      });

  Future<void> registerForPushNotifications(
    PushNotificationRegistrationRequestModel
        pushNotificationRegistrationRequestModel,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          pushNotificationsRegistrationPath,
          data: pushNotificationRegistrationRequestModel.toJson(),
        );
      });

  Future<void> unregisterFromPushNotifications(String pushRegistrationToken) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.delete<dynamic>(pushNotificationsRegistrationPath,
            queryParameters: {
              pushRegistrationTokenQueryParameterKey: pushRegistrationToken
            });
      });

  Future<ChangePasswordResponseModel> changePassword(
      ChangePasswordRequestModel changePasswordRequestModel) async {
    final changePasswordResponse = await httpClient.post<Map<String, dynamic>>(
      changePasswordPath,
      data: changePasswordRequestModel.toJson(),
    );

    return ChangePasswordResponseModel.fromJson(changePasswordResponse.data);
  }

  Future<void> generateResetPasswordLink(
          GenerateResetPasswordLinkRequestModel model) async =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          generateResetPasswordLinkPath,
          data: model.toJson(),
        );
      });

  Future<void> resetPassword(ResetPasswordRequestModel model) async =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          resetPasswordPath,
          data: model.toJson(),
        );
      });

  Future<CustomerResponseModel> getCustomer() =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<dynamic>(getCustomerPath);
        return CustomerResponseModel.fromJson(response.data);
      });

  Future<TransactionHistoryResponseModel> getTransactionHistory({
    @required int currentPage,
    @required int pageSize,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get(
          transactionHistoryPath,
          queryParameters: {
            currentPageQueryParameterKey: currentPage,
            pageSizeQueryParameterKey: pageSize,
          },
        );

        return TransactionHistoryResponseModel.fromJson(response.data);
      });

  Future<void> deleteAccount() async =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.put<dynamic>(
          deleteAccountPath,
        );
      });
}
