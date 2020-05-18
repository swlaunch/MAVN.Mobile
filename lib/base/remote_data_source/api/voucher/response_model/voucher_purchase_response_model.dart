import 'package:flutter/foundation.dart';

class VoucherPurchaseResponseModel {
  VoucherPurchaseResponseModel({@required this.voucherCode});

  VoucherPurchaseResponseModel.fromJson(Map<String, dynamic> json)
      : voucherCode = json['Code'];

  final String voucherCode;
}
