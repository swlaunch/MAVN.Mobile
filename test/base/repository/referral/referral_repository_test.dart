import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/hotel_referral_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/request_model/lead_referral_model.dart';
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

    test('submit lead referral', () async {
      await _subject.submitLeadReferral(
        firstName: TestConstants.stubFirstName,
        lastName: TestConstants.stubLastName,
        countryCodeId: TestConstants.stubCountryCodeId,
        phone: TestConstants.stubPhoneNumber,
        email: TestConstants.stubEmail,
        note: TestConstants.stubNote,
        earnRuleId: TestConstants.stubEarnRuleId,
      );

      final LeadReferralRequestModel capturedLeadReferralRequestModel =
          verify(_mockReferralApi.submitLeadReferral(captureAny)).captured[0];

      expect(capturedLeadReferralRequestModel.firstName,
          TestConstants.stubFirstName);
      expect(capturedLeadReferralRequestModel.lastName,
          TestConstants.stubLastName);
      expect(capturedLeadReferralRequestModel.countryCodeId,
          TestConstants.stubCountryCodeId);
      expect(
        capturedLeadReferralRequestModel.phoneNumber,
        TestConstants.stubPhoneNumber,
      );
      expect(capturedLeadReferralRequestModel.email, TestConstants.stubEmail);
      expect(capturedLeadReferralRequestModel.note, TestConstants.stubNote);
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
