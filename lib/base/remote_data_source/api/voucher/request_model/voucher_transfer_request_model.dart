import 'package:flutter/cupertino.dart';

class VoucherTransferRequestModel {
  VoucherTransferRequestModel({
    @required this.receiverEmail,
    @required this.voucherShortCode,
  });

  final String receiverEmail;
  final String voucherShortCode;

  Map<String, dynamic> toJson() => {
        'ReceiverEmail': receiverEmail,
        'VoucherShortCode': voucherShortCode,
      };
}
