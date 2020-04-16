import 'package:flutter/material.dart';

class PaymentRejectedRequestModel {
  const PaymentRejectedRequestModel({@required this.paymentRequestId});

  final String paymentRequestId;

  Map<String, dynamic> toJson() => {'PaymentRequestId': paymentRequestId};
}
