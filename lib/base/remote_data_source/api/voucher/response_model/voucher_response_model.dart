import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class VoucherResponseModel {
  VoucherResponseModel({
    @required this.id,
    @required this.shortCode,
    @required this.validationCodeHash,
    @required this.campaignId,
    @required this.status,
    @required this.ownerId,
    @required this.purchaseDate,
    @required this.expirationDate,
    @required this.redemptionDate,
    @required this.partnerName,
    @required this.campaignName,
    @required this.imageUrl,
    @required this.description,
    @required this.price,
  });

  VoucherResponseModel.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        shortCode = json['ShortCode'],
        validationCodeHash = json['ValidationCodeHash'],
        campaignId = json['CampaignId'],
        status = EnumMapper.mapFromString(
          json['Status'],
          enumValues: VoucherStatus.values,
          defaultValue: null,
        ),
        ownerId = json['OwnerId'],
        purchaseDate = json['PurchaseDate'] != null
            ? DateTime.tryParse(json['PurchaseDate'])
            : null,
        expirationDate = json['ExpirationDate'] != null
            ? DateTime.tryParse(json['ExpirationDate'])
            : null,
        redemptionDate = json['RedemptionDate'] != null
            ? DateTime.tryParse(json['RedemptionDate'])
            : null,
        partnerName = json['PartnerName'],
        campaignName = json['CampaignName'],
        imageUrl = json['ImageUrl'],
        description = json['Description'],
        price = FiatCurrency(
          value: json['Price'],
          assetSymbol: json['Currency'],
        );

  static List<VoucherResponseModel> toListFromJson(List list) => list
      .map((vouchersJson) => VoucherResponseModel.fromJson(vouchersJson))
      .toList();

  final int id;
  final String shortCode;
  final String validationCodeHash;
  final String campaignId;
  final VoucherStatus status;
  final String ownerId;
  final DateTime purchaseDate;
  final DateTime expirationDate;
  final DateTime redemptionDate;
  final String partnerName;
  final String campaignName;
  final String imageUrl;
  final String description;
  final FiatCurrency price;
}

class VoucherListResponseModel {
  VoucherListResponseModel({
    this.vouchers,
    this.totalCount,
  });

  VoucherListResponseModel.fromJson(Map<String, dynamic> json)
      : vouchers =
            VoucherResponseModel.toListFromJson(json['SmartVouchers'] as List),
        totalCount = json['TotalCount'];

  final List<VoucherResponseModel> vouchers;
  final int totalCount;
}

enum VoucherStatus { none, inStock, reserved, sold }
