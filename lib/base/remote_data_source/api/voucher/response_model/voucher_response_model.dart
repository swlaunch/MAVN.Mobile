import 'package:decimal/decimal.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class VoucherResponseModel {
  VoucherResponseModel({
    this.code,
    this.spendRuleName,
    this.partnerName,
    this.priceToken,
    this.priceBaseCurrency,
    this.purchaseDate,
  });

  VoucherResponseModel.fromJson(Map<String, dynamic> json)
      : code = json['Code'],
        spendRuleName = json['SpendRuleName'],
        partnerName = json['PartnerName'],
        priceToken = TokenCurrency(value: json['PriceToken']),
        priceBaseCurrency =
            Decimal.tryParse(json['PriceBaseCurrency'].toString()),
        purchaseDate = DateTime.tryParse(json['PurchaseDate']);

  static List<VoucherResponseModel> toListFromJson(List list) => list
      .map((vouchersJson) => VoucherResponseModel.fromJson(vouchersJson))
      .toList();

  final String code;
  final String spendRuleName;
  final String partnerName;
  final TokenCurrency priceToken;
  final Decimal priceBaseCurrency;
  final DateTime purchaseDate;
}

class VoucherListResponseModel {
  VoucherListResponseModel({
    this.vouchers,
    this.totalCount,
    this.currentPage,
    this.pageSize,
  });

  VoucherListResponseModel.fromJson(Map<String, dynamic> json)
      : vouchers =
            VoucherResponseModel.toListFromJson(json['Vouchers'] as List),
        totalCount = json['TotalCount'],
        currentPage = json['CurrentPage'],
        pageSize = json['PageSize'];

  final List<VoucherResponseModel> vouchers;
  final int totalCount;
  final int currentPage;
  final int pageSize;
}
