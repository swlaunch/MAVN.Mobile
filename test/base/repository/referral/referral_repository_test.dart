import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/hotel_referral_model.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';
import '../../../test_constants.dart';

void main() {
  group('ReferralRepository tests', () {
    final _mockReferralApi = MockReferralApi();
    final _subject = ReferralRepository(_mockReferralApi);

    setUp(() {
      reset(_mockReferralApi);
    });

    test('submit hotel referral', () async {
      await _subject.submitHotelReferral(
        fullName: TestConstants.stubFullName,
        email: TestConstants.stubEmail,
        countryCodeId: TestConstants.stubCountryCodeId,
        phoneNumber: TestConstants.stubPhoneNumber,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      final HotelReferralRequestModel capturedHotelReferralRequestModel =
          verify(_mockReferralApi.submitHotelReferral(captureAny)).captured[0];

      expect(capturedHotelReferralRequestModel.email, TestConstants.stubEmail);
    });
  });
}
