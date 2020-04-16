import 'package:flutter/material.dart';

class PaymentApprovedRequestModel {
  const PaymentApprovedRequestModel({
    @required this.paymentRequestId,
    @required this.sendingAmount,
  });

  final String paymentRequestId;
  final String sendingAmount;

  Map<String, dynamic> toJson() => {
        'PaymentRequestId': paymentRequestId,
        'SendingAmount': sendingAmount,
      };
}
