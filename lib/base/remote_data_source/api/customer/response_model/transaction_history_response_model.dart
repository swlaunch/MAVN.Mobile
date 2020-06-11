import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class Transaction {
  Transaction({
    @required this.type,
    @required this.date,
    @required this.price,
    this.campaignName = '',
    this.otherSideCustomerEmail = '',
    this.partnerName = '',
    this.instalmentName = '',
    this.vertical = '',
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : type = EnumMapper.mapFromString(
          json['Type'],
          enumValues: TransactionType.values,
          defaultValue: null,
        ),
        date = json['Timestamp'],
        price = FiatCurrency(
            value: double.tryParse(json['Amount']),
            assetSymbol: json['Currency']),
        campaignName = json['CampaignName'],
        otherSideCustomerEmail = json['OtherSideCustomerEmail'],
        partnerName = json['PartnerName'],
        instalmentName = json['InstalmentName'],
        vertical = json['Vertical'];

  final TransactionType type;
  final String date;
  final FiatCurrency price;
  final String campaignName;
  final String otherSideCustomerEmail;
  final String partnerName;
  final String instalmentName;
  final String vertical;
}

enum TransactionType {
  smartVoucherPayment,
  smartVoucherUse,
  smartVoucherTransferSend,
  smartVoucherTransferReceive,
}

class TransactionHistoryResponseModel extends Equatable {
  const TransactionHistoryResponseModel(
      {this.transactionList, this.totalCount});

  TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json)
      : transactionList = (json['Operations'] as List)
            .map((transactionJson) => Transaction.fromJson(transactionJson))
            .toList(),
        totalCount = json['TotalCount'];

  final List<Transaction> transactionList;

  final int totalCount;

  @override
  List<Object> get props => [transactionList, totalCount];
}
