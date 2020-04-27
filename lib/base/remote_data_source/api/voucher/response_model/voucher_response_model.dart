import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';

class VoucherResponseModel {
  VoucherResponseModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.totalCount,
    @required this.boughtCount,
    @required this.price,
    @required this.partnerId,
    @required this.fromDate,
    @required this.toDate,
    @required this.creationDate,
    @required this.createdBy,
  });

  VoucherResponseModel.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        description = json['Description'],
        totalCount = json['VouchersTotalCount'],
        boughtCount = json['BoughtVouchersCount'],
        price = FiatCurrency(
          value: json['VoucherPrice'],
          assetSymbol: json['Currency'],
        ),
        partnerId = json['PartnerId'],
        fromDate = json['FromDate'] != null
            ? DateTime.tryParse(json['FromDate'])
            : null,
        toDate =
            json['ToDate'] != null ? DateTime.tryParse(json['ToDate']) : null,
        creationDate = json['CreationDate'] != null
            ? DateTime.tryParse(json['CreationDate'])
            : null,
        createdBy = json['CreatedBy'];

  static List<VoucherResponseModel> toListFromJson(List list) => list
      .map((vouchersJson) => VoucherResponseModel.fromJson(vouchersJson))
      .toList();

  final String id;
  final String name;
  final String description;
  final int totalCount;
  final int boughtCount;
  final FiatCurrency price;
  final String partnerId;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime creationDate;
  final String createdBy;
}

class VoucherListResponseModel {
  VoucherListResponseModel({
    this.vouchers,
    this.totalCount,
  });

  VoucherListResponseModel.fromJson(Map<String, dynamic> json)
      : vouchers = VoucherResponseModel.toListFromJson(
            json['SmartVoucherCampaigns'] as List),
        totalCount = json['TotalCount'];

  final List<VoucherResponseModel> vouchers;
  final int totalCount;
}
