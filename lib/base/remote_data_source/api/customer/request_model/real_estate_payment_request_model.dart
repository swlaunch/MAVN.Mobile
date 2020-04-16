class RealEstatePaymentRequestModel {
  RealEstatePaymentRequestModel(
    this.id,
    this.instalmentName,
    this.amountInTokens,
    this.amountInFiat,
    this.fiatCurrencyCode,
    this.spendRuleId,
  );

  final String id;
  final String instalmentName;
  final String amountInTokens;
  final double amountInFiat;
  final String fiatCurrencyCode;
  final String spendRuleId;

  Map<String, dynamic> toJson() => {
        'Id': id,
        'InstalmentName': instalmentName,
        'AmountInTokens': amountInTokens,
        'AmountInFiat': amountInFiat,
        'FiatCurrencyCode': fiatCurrencyCode,
        'SpendRuleId': spendRuleId
      };
}
