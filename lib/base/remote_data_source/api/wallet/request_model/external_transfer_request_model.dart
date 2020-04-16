import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';

class ExternalTransferRequestModel {
  ExternalTransferRequestModel({@required this.amount});

  final Decimal amount;

  Map<String, dynamic> toJson() => {
        'Amount': amount.toString(),
      };
}
