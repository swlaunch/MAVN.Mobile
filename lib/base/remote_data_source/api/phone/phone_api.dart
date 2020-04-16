import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/phone_verification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/request_model/set_phone_number_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class PhoneApi extends BaseApi {
  PhoneApi(HttpClient httpClient) : super(httpClient);

  static const String phonePath = '/phones';
  static const String verifyPhonePath = '/phones/verify';
  static const String generateVerificationPath =
      '/phones/generate-verification';

  Future<void> setPhoneNumber(
          {@required SetPhoneNumberRequestModel setPhoneNumberRequestModel}) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          phonePath,
          data: setPhoneNumberRequestModel.toJson(),
        );
      });

  Future<void> generateVerification() =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(generateVerificationPath);
      });

  Future<void> verifyPhoneNumber(
          {@required
              PhoneVerificationRequestModel phoneVerificationRequestModel}) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          verifyPhonePath,
          data: phoneVerificationRequestModel.toJson(),
        );
      });
}
