import 'package:meta/meta.dart';

class Country {
  const Country({
    @required this.id,
    @required this.name,
    @required this.countryIso2Code,
    @required this.countryIso3Code,
  });

  Country.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        countryIso2Code = json['CountryIso2Code'],
        countryIso3Code = json['CountryIso3Code'];

  final int id;
  final String name;
  final String countryIso2Code;
  final String countryIso3Code;
}

class CountryListResponseModel {
  CountryListResponseModel({@required this.countryList});

  CountryListResponseModel.fromJson(List<dynamic> json)
      : countryList =
            json.map((jsonCountry) => Country.fromJson(jsonCountry)).toList();

  final List<Country> countryList;
}
