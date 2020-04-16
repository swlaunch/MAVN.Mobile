import 'package:flutter/foundation.dart';

class ResetPasswordRequestModel {
  ResetPasswordRequestModel({
    @required this.email,
    @required this.resetIdentifier,
    @required this.password,
  });

  final String email;
  final String resetIdentifier;
  final String password;

  Map<String, String> toJson() => {
        'CustomerEmail': email,
        'ResetIdentifier': resetIdentifier,
        'Password': password
      };
}
