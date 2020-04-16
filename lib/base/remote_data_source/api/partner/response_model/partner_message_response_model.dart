import 'package:equatable/equatable.dart';

class PartnerMessageResponseModel with EquatableMixin {
  PartnerMessageResponseModel({
    this.partnerMessageId,
    this.partnerId,
    this.partnerName,
    this.locationId,
    this.locationName,
    this.customerId,
    this.timestamp,
    this.subject,
    this.message,
  });

  PartnerMessageResponseModel.fromJson(json)
      : partnerMessageId = json['PartnerMessageId'],
        partnerId = json['PartnerId'],
        partnerName = json['PartnerName'],
        locationId = json['LocationId'],
        locationName = json['LocationName'],
        customerId = json['CustomerId'],
        timestamp = json['Timestamp'],
        subject = json['Subject'],
        message = json['Message'];

  final String partnerMessageId;
  final String partnerId;
  final String partnerName;
  final String locationId;
  final String locationName;
  final String customerId;
  final String timestamp;
  final String subject;
  final String message;

  @override
  List get props => [
        partnerMessageId,
        partnerId,
        partnerName,
        locationId,
        locationName,
        customerId,
        timestamp,
        subject,
        message,
      ];
}
