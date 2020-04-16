import 'package:meta/meta.dart';

class LinkCodeRequestResponseModel {
  LinkCodeRequestResponseModel({@required this.linkCode});

  LinkCodeRequestResponseModel.fromJson(Map<String, dynamic> json)
      : linkCode = json['LinkCode'];

  final String linkCode;
}
