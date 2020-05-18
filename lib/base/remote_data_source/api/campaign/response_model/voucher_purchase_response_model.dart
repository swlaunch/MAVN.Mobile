import 'package:flutter/foundation.dart';

class VoucherPurchaseResponseModel {
  VoucherPurchaseResponseModel({@required this.paymentUrl});

  VoucherPurchaseResponseModel.fromJson(Map<String, dynamic> json)
      : paymentUrl = json['PaymentUrl'];

  final String paymentUrl;
}
