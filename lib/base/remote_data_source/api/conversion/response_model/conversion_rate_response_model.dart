class ConversionRateResponseModel {
  ConversionRateResponseModel({
    this.amount,
    this.rate,
    this.currencyCode,
    this.error,
  });

  ConversionRateResponseModel.fromJson(Map<String, dynamic> json)
      : amount = json['Amount'],
        rate = json['Rate'],
        currencyCode = json['CurrencyCode'],
        error = json['Error'];

  final String amount;
  final String rate;
  final String currencyCode;
  final String error;
}
