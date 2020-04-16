import 'package:lykke_mobile_mavn/library_fcm/notification_tapped.dart';

class NotificationMessage {
  NotificationMessage({
    this.messageGroupId,
    this.creationDate,
    this.message,
    this.payload,
    this.isRead,
  });

  NotificationMessage.fromJson(Map<String, dynamic> json)
      : messageGroupId = json['MessageGroupId'],
        creationDate = DateTime.tryParse(json['CreationTimestamp']),
        message = json['Message'],
        payload = NotificationTapped.fromJson(json['Payload']),
        isRead = json['IsRead'];

  final String messageGroupId;
  final DateTime creationDate;
  final String message;
  final NotificationTapped payload;
  final bool isRead;

  static List<NotificationMessage> toListFromJson(List list) => list
      .map((notificationsJson) =>
          NotificationMessage.fromJson(notificationsJson))
      .toList();
}

class NotificationListResponseModel {
  NotificationListResponseModel({
    this.notifications,
    this.totalCount,
    this.currentPage,
    this.pageSize,
  });

  NotificationListResponseModel.fromJson(Map<String, dynamic> json)
      : notifications = NotificationMessage.toListFromJson(
            json['NotificationMessages'] as List),
        totalCount = json['TotalCount'],
        currentPage = json['CurrentPage'],
        pageSize = json['PageSize'];

  final int totalCount;
  final int currentPage;
  final int pageSize;
  final List<NotificationMessage> notifications;
}
