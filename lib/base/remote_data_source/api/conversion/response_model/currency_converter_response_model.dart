import 'package:meta/meta.dart';

class CurrencyConverterResponseModel {
  CurrencyConverterResponseModel({@required this.amount});

  CurrencyConverterResponseModel.fromJson(Map<String, dynamic> json)
      : amount = json['Amount'];

  final String amount;
}
