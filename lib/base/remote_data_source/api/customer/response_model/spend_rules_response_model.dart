import 'package:equatable/equatable.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/partner_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';
import 'package:meta/meta.dart';

class SpendRule {
  const SpendRule({
    @required this.id,
    @required this.title,
    @required this.amountInTokens,
    @required this.amountInCurrency,
    @required this.currencyName,
    @required this.description,
    @required this.imageUrl,
    @required this.type,
    @required this.partners,
    @required this.creationDate,
    this.stockCount,
    this.soldCount,
    this.price,
    this.priceInToken,
  });

  SpendRule.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        title = json['Title'],
        amountInTokens = TokenCurrency(value: json['AmountInTokens']),
        amountInCurrency = json['AmountInCurrency'] is num
            ? (json['AmountInCurrency'] as num).toStringAsFixed(2)
            : 'n/a',
        currencyName = json['CurrencyName'],
        description = json['Description'],
        imageUrl = json['ImageUrl'],
        type = EnumMapper.mapFromString(
          json['BusinessVertical'],
          enumValues: OfferVertical.values,
          defaultValue: null,
        ),
        partners = Partner.toListOfPartners(json['Partners'] as List),
        creationDate = json['CreationDate'],
        stockCount = json['StockCount'],
        soldCount = json['SoldCount'],
        price = json['Price'],
        priceInToken = TokenCurrency(value: json['PriceInToken']);

  final String id;
  final String title;
  final TokenCurrency amountInTokens;
  final String amountInCurrency;
  final String currencyName;
  final String description;
  final String imageUrl;
  final OfferVertical type;
  final List<Partner> partners;
  final String creationDate;
  final int stockCount;
  final int soldCount;
  final double price;
  final TokenCurrency priceInToken;
}

class SpendRuleListResponseModel extends Equatable {
  const SpendRuleListResponseModel({
    @required this.spendRuleList,
    @required this.totalCount,
    @required this.currentPage,
  });

  SpendRuleListResponseModel.fromJson(Map<String, dynamic> json)
      : spendRuleList = (json['SpendRules'] as List)
            .map((spendRuleJson) => SpendRule.fromJson(spendRuleJson))
            .toList(),
        totalCount = json['TotalCount'],
        currentPage = json['CurrentPage'];

  final List<SpendRule> spendRuleList;

  final int totalCount;

  final int currentPage;

  @override
  List<Object> get props => [spendRuleList, totalCount, currentPage];
}
