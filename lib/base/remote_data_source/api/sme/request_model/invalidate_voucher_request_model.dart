import 'package:flutter/foundation.dart';

class InvalidateVoucherRequestModel {
  InvalidateVoucherRequestModel({
    @required this.voucherShortCode,
    @required this.voucherValidationCode,
  });

  final String voucherShortCode;
  final String voucherValidationCode;

  Map<String, dynamic> toJson() => {
        'VoucherShortCode': voucherShortCode,
        'VoucherValidationCode': voucherValidationCode,
      };
}
