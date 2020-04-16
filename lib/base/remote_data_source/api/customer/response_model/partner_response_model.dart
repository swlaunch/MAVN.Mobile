import 'package:flutter/foundation.dart';

class Partner {
  const Partner({
    @required this.id,
    @required this.name,
    @required this.locations,
  });

  Partner.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        locations = PartnerLocation.toListFromJson(json['Locations'] as List);

  final String id;
  final String name;
  final List<PartnerLocation> locations;

  static List<Partner> toListOfPartners(List list) => list == null
      ? []
      : list.map((partner) => Partner.fromJson(partner)).toList();
}

class PartnerLocation {
  const PartnerLocation({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.createdAt,
  });

  PartnerLocation.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        address = json['Address'],
        createdAt = json['CreatedAt'];

  static List<PartnerLocation> toListFromJson(List list) => list == null
      ? []
      : list.map((location) => PartnerLocation.fromJson(location)).toList();

  final String id;
  final String name;
  final String address;
  final String createdAt;
}
