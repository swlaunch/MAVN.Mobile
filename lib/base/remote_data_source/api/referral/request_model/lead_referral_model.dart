class LeadReferralRequestModel {
  LeadReferralRequestModel({
    this.firstName,
    this.lastName,
    this.countryCodeId,
    this.phoneNumber,
    this.email,
    this.note,
    this.earnRuleId,
  });

  final String firstName;
  final String lastName;
  final int countryCodeId;
  final String phoneNumber;
  final String email;
  final String note;
  final String earnRuleId;

  Map<String, dynamic> toJson() => {
        'FirstName': firstName,
        'LastName': lastName,
        'CountryPhoneCodeId': countryCodeId,
        'PhoneNumber': phoneNumber,
        'Email': email,
        'Note': note,
        'CampaignId': earnRuleId
      };
}
