import 'package:flutter/foundation.dart';

class GenerateResetPasswordLinkRequestModel {
  GenerateResetPasswordLinkRequestModel({@required this.email});

  final String email;

  Map<String, String> toJson() => {
        'Email': email,
      };
}
