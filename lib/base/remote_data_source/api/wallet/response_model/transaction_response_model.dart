import 'package:meta/meta.dart';

class TransactionResponseModel {
  TransactionResponseModel({@required this.transactionId});

  TransactionResponseModel.fromJson(Map<String, dynamic> json)
      : transactionId = json['TransactionId'];

  final String transactionId;
}
