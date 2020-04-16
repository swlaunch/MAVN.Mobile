import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class PaymentRequestResponseModel {
  const PaymentRequestResponseModel({
    @required this.paymentRequestId,
    @required this.status,
    @required this.totalInToken,
    @required this.requestedAmountInTokens,
    @required this.totalInCurrency,
    @required this.sendingAmountInToken,
    @required this.currencyCode,
    @required this.partnerId,
    @required this.partnerName,
    @required this.locationId,
    @required this.locationName,
    @required this.paymentInfo,
    @required this.walletBalance,
    @required this.date,
    @required this.lastUpdatedDate,
    @required this.tokensToFiatConversionRate,
    @required this.expirationTimeLeftInSeconds,
    @required this.expirationTimeStamp,
  });

  PaymentRequestResponseModel.fromJson(json)
      : paymentRequestId = json['PaymentRequestId'],
        status = _toPaymentRequestStatus(json['Status']),
        totalInToken = TokenCurrency(value: json['TotalInToken']),
        requestedAmountInTokens =
            TokenCurrency(value: json['RequestedAmountInTokens']),
        totalInCurrency = json['TotalInCurrency'],
        sendingAmountInToken =
            TokenCurrency(value: json['SendingAmountInToken']),
        currencyCode = json['CurrencyCode'],
        partnerId = json['PartnerId'],
        partnerName = json['PartnerName'],
        locationId = json['LocationId'],
        locationName = json['LocationName'],
        paymentInfo = json['PaymentInfo'],
        walletBalance = TokenCurrency(value: json['WalletBalance']),
        date = json['Date'],
        lastUpdatedDate = json['LastUpdatedDate'],
        tokensToFiatConversionRate = json['TokensToFiatConversionRate'],
        expirationTimeLeftInSeconds =
            json['CustomerActionExpirationTimeLeftInSeconds'],
        expirationTimeStamp = json['CustomerActionExpirationTimestamp'];

  final String paymentRequestId;
  final PaymentRequestStatus status;
  final TokenCurrency totalInToken;
  final TokenCurrency requestedAmountInTokens;
  final double totalInCurrency;
  final TokenCurrency sendingAmountInToken;
  final String currencyCode;
  final String partnerId;
  final String partnerName;
  final String locationId;
  final String locationName;
  final String paymentInfo;
  final TokenCurrency walletBalance;
  final String date;
  final String lastUpdatedDate;
  final double tokensToFiatConversionRate;
  final int expirationTimeLeftInSeconds;
  final String expirationTimeStamp;

  static PaymentRequestStatus _toPaymentRequestStatus(String requestStatus) {
    for (final status in PaymentRequestStatus.values) {
      if (status.toString().split('.')[1].toLowerCase() ==
          requestStatus.toLowerCase()) {
        return status;
      }
    }
    return null;
  }
}

enum PaymentRequestStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  failed,
  requestExpired,
  paymentExpired,
}
