import 'package:flutter/material.dart';

class PhoneVerificationRequestModel {
  PhoneVerificationRequestModel({@required this.verificationCode});

  final String verificationCode;

  Map<String, dynamic> toJson() => {
        'VerificationCode': verificationCode,
      };
}
