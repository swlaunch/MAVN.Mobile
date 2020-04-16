import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/request_model/email_verification_request_model.dart';
import 'package:lykke_mobile_mavn/base/repository/email/email_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('EmailRepsitory tests', () {
    final _mockEmailApi = MockEmailApi();
    final _subject = EmailRepository(_mockEmailApi);

    setUp(() {
      reset(_mockEmailApi);
    });

    test('sendVerificationEmail', () async {
      await _subject.sendVerificationEmail();
      verify(_mockEmailApi.sendVerificationEmail()).called(1);
    });

    test('verifyEmail', () async {
      await _subject.verifyEmail(
          verificationCode: TestConstants.stubEmailVerificationCode);

      final capturedLoginRequestModel = verify(_mockEmailApi.verifyEmail(
              emailVerificationRequestModel:
                  captureAnyNamed('emailVerificationRequestModel')))
          .captured[0] as EmailVerificationRequestModel;

      expect(capturedLoginRequestModel.verificationCode,
          TestConstants.stubEmailVerificationCode);
    });
  });
}
