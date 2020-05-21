import 'package:flutter/foundation.dart';

class CancelVoucherRequestModel {
  CancelVoucherRequestModel({@required this.shortCode});

  final String shortCode;

  Map<String, dynamic> toJson() => {'ShortCode': shortCode};
}
