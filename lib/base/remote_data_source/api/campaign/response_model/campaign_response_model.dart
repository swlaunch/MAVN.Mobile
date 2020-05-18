import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

import 'localized_details_response_model.dart';

class CampaignResponseModel {
  CampaignResponseModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.totalCount,
    @required this.boughtCount,
    @required this.price,
    @required this.partnerId,
    @required this.partnerName,
    @required this.fromDate,
    @required this.toDate,
    @required this.creationDate,
    @required this.createdBy,
    @required this.vertical,
    @required this.localizedDetails,
  });

  CampaignResponseModel.fromJson(Map<String, dynamic> json)
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
        partnerName = json['PartnerName'],
        fromDate = json['FromDate'] != null
            ? DateTime.tryParse(json['FromDate'])
            : null,
        toDate =
            json['ToDate'] != null ? DateTime.tryParse(json['ToDate']) : null,
        creationDate = json['CreationDate'] != null
            ? DateTime.tryParse(json['CreationDate'])
            : null,
        createdBy = json['CreatedBy'],
        vertical = EnumMapper.mapFromString(
          json['Vertical'],
          enumValues: Vertical.values,
          defaultValue: null,
        ),
        localizedDetails =
            LocalizedCampaignDetails.toListFromJson(json['LocalizedContents']);

  static List<CampaignResponseModel> toListFromJson(List list) => list
      .map((vouchersJson) => CampaignResponseModel.fromJson(vouchersJson))
      .toList();

  final String id;
  final String name;
  final String description;
  final int totalCount;
  final int boughtCount;
  final FiatCurrency price;
  final String partnerId;
  final String partnerName;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime creationDate;
  final String createdBy;
  final Vertical vertical;
  final List<LocalizedCampaignDetails> localizedDetails;

  ////TODO move this to localization manager ASAP
  String getImageUrl() {
    final images = localizedDetails
        .where((detail) => detail.contentType == LocalizedContentType.imageUrl);
    if (images.isEmpty) return null;
    final i = images.firstWhere(
        (element) => element?.localization == Localization.en,
        orElse: () => null);
    return (i ?? images?.first).image?.blobUrl;
  }
}

class CampaignListResponseModel {
  CampaignListResponseModel({
    this.campaigns,
    this.totalCount,
  });

  CampaignListResponseModel.fromJson(Map<String, dynamic> json)
      : campaigns = CampaignResponseModel.toListFromJson(
            json['SmartVoucherCampaigns'] as List),
        totalCount = json['TotalCount'];

  final List<CampaignResponseModel> campaigns;
  final int totalCount;
}

enum Vertical { hospitality, realEstate, retail }
