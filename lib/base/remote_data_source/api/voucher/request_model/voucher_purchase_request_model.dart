import 'package:flutter/cupertino.dart';

class VoucherPurchaseRequestModel {
  VoucherPurchaseRequestModel({@required this.voucherId});

  final String voucherId;

  Map<String, dynamic> toJson() => {
        'SmartVoucherVoucherId': voucherId,
      };
}
