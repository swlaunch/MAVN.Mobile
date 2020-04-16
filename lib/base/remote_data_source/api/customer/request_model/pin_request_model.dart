import 'package:flutter/foundation.dart';

class PinRequestModel {
  PinRequestModel({
    @required this.pin,
  });

  final String pin;

  Map<String, dynamic> toJson() => {'Pin': pin};
}
