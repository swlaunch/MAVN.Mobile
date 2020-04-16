import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class Property {
  const Property({
    this.name,
    this.instalments,
  });

  Property.fromJson(Map<String, dynamic> json)
      : name = json['Name'],
        instalments = Instalment.toListFromJson(json['Instalments'] as List);

  final String name;
  final List<Instalment> instalments;

  static List<Property> toListFromJson(List<dynamic> json) =>
      json.map((json) => Property.fromJson(json)).toList();
}

class Instalment {
  const Instalment({
    this.id,
    this.amountInTokens,
    this.amountInFiat,
    this.dueDate,
    this.name,
  });

  Instalment.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        amountInTokens = TokenCurrency(value: json['AmountInTokens']),
        amountInFiat = FiatCurrency(
          value: json['AmountInFiat'],
          assetSymbol: json['FiatCurrencyCode'],
        ),
        dueDate = DateTime.tryParse(json['DueDate']);

  static List<Instalment> toListFromJson(List list) => list == null
      ? []
      : list.map((instalment) => Instalment.fromJson(instalment)).toList();

  final String id;
  final TokenCurrency amountInTokens;
  final FiatCurrency amountInFiat;
  final DateTime dueDate;
  final String name;
}

class RealEstatePropertyListResponseModel {
  const RealEstatePropertyListResponseModel({
    this.properties,
  });

  RealEstatePropertyListResponseModel.fromJson(Map<String, dynamic> json)
      : properties = Property.toListFromJson(json['RealEstateProperties']);

  final List<Property> properties;
}
