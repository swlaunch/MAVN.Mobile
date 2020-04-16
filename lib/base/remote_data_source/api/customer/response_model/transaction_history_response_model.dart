import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class Transaction {
  Transaction({
    @required this.type,
    @required this.date,
    @required this.amount,
    this.actionRule = '',
    this.otherSideCustomerEmail = '',
    this.otherSideCustomerName = '',
    this.partnerName = '',
    this.instalmentName = '',
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : type = EnumMapper.mapFromString(
          json['Type'],
          enumValues: TransactionType.values,
          defaultValue: null,
        ),
        date = json['Timestamp'],
        amount = json['Amount'],
        actionRule = json['ActionRule'],
        otherSideCustomerEmail = json['OtherSideCustomerEmail'],
        otherSideCustomerName = json['OtherSideCustomerName'],
        partnerName = json['PartnerName'],
        instalmentName = json['InstalmentName'];

  final TransactionType type;
  final String date;
  final String amount;
  final String actionRule;
  final String otherSideCustomerEmail;
  final String otherSideCustomerName;
  final String partnerName;
  final String instalmentName;
}

enum TransactionType {
  sendTransfer,
  receiveTransfer,
  bonusReward,
  paymentTransfer,
  paymentTransferRefund,
  partnerPayment,
  partnerPaymentRefund,
  referralStake,
  releasedReferralStake,
  walletLinkingFee,
  linkedWalletSendTransfer,
  linkedWalletReceiveTransfer,
  transferToPublicFee,
  voucherPurchasePayment
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
