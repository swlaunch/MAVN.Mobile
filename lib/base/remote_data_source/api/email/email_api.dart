import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/request_model/email_verification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';

class EmailApi extends BaseApi {
  EmailApi(HttpClient httpClient) : super(httpClient);

  static const String sendVerificationEmailPath = '/emails/verification';
  static const String verifyEmailPath = '/emails/verify-email';

  Future<void> sendVerificationEmail() =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post(sendVerificationEmailPath);
      });

  Future<void> verifyEmail({
    @required EmailVerificationRequestModel emailVerificationRequestModel,
  }) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post(verifyEmailPath,
            data: emailVerificationRequestModel.toJson());
      });
}
