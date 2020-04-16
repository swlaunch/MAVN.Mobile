import 'package:meta/meta.dart';

class ChangePasswordResponseModel {
  ChangePasswordResponseModel({@required this.token});

  ChangePasswordResponseModel.fromJson(Map<String, dynamic> json)
      : token = json['Token'];

  final String token;
}
