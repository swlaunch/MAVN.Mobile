import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/image_response_model.dart';
import 'package:lykke_mobile_mavn/library_utils/enum_mapper.dart';

class LocalizedCampaignDetails {
  LocalizedCampaignDetails.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        contentType = EnumMapper.mapFromString(
          json['ContentType'],
          enumValues: LocalizedContentType.values,
          defaultValue: null,
        ),
        localization = EnumMapper.mapFromString(
          json['Localization'],
          enumValues: Localization.values,
          defaultValue: Localization.en,
        ),
        value = json['Value'],
        image = json['Image'] != null
            ? ImageResponseModel.fromJson(json['Image'])
            : null;

  static List<LocalizedCampaignDetails> toListFromJson(List list) =>
      list.map((json) => LocalizedCampaignDetails.fromJson(json)).toList();

  final String id;
  final LocalizedContentType contentType;
  final Localization localization;
  final String value;
  final ImageResponseModel image;
}

enum LocalizedContentType { name, description, imageUrl }

enum Localization { en, de, ru, ar }
