import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/email_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/request_model/email_verification_request_model.dart';

class EmailRepository {
  EmailRepository(this._emailApi);

  final EmailApi _emailApi;

  Future<void> sendVerificationEmail() => _emailApi.sendVerificationEmail();

  Future<void> verifyEmail({@required verificationCode}) =>
      _emailApi.verifyEmail(
        emailVerificationRequestModel: EmailVerificationRequestModel(
          verificationCode: verificationCode,
        ),
      );
}
