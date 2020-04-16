import 'package:meta/meta.dart';

class LoginResponseModel {
  LoginResponseModel({@required this.token});

  LoginResponseModel.fromJson(Map<String, dynamic> json)
      : token = json['Token'];

  final String token;
}
