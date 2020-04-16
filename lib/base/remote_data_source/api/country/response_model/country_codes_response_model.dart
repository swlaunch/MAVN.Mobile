import 'package:meta/meta.dart';

class CountryCode {
  const CountryCode({
    @required this.id,
    @required this.code,
    @required this.name,
    @required this.countryIso2Code,
    @required this.countryIso3Code,
  });

  CountryCode.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        code = json['Code'],
        name = json['CountryName'],
        countryIso2Code = json['CountryIso2Code'],
        countryIso3Code = json['CountryIso3Code'];

  final int id;
  final String code;
  final String name;
  final String countryIso2Code;
  final String countryIso3Code;
}

class CountryCodeListResponseModel {
  CountryCodeListResponseModel({@required this.countryCodeList});

  CountryCodeListResponseModel.fromJson(List<dynamic> json)
      : countryCodeList = json
            .map((jsonCountryCode) => CountryCode.fromJson(jsonCountryCode))
            .toList();

  final List<CountryCode> countryCodeList;
}
