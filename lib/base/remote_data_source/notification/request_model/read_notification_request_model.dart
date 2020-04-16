import 'package:flutter/foundation.dart';

class ReadNotificationRequestModel {
  ReadNotificationRequestModel({@required this.messageGroupId});

  Map<String, dynamic> toJson() => {'MessageGroupId': messageGroupId};

  final String messageGroupId;
}
