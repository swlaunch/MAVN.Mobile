class EmailVerificationRequestModel {
  EmailVerificationRequestModel({this.verificationCode});

  final String verificationCode;

  Map<String, dynamic> toJson() => {
        'VerificationCode': verificationCode,
      };
}
