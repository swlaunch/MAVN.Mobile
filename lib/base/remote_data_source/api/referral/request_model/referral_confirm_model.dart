class ReferralConfirmRequestModel {
  ReferralConfirmRequestModel({this.code});

  final String code;

  Map<String, dynamic> toJson() => {
        'ConfirmationCode': code,
      };
}
