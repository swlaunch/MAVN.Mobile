import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/notification_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/request_model/read_notification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/unread_notification_count_response_model.dart';

class NotificationRepository {
  NotificationRepository(this._notificationApi);

  final NotificationApi _notificationApi;

  static const itemsPerPage = 30;

  Future<void> markAsRead({@required String messageGroupId}) => _notificationApi
      .markAsRead(ReadNotificationRequestModel(messageGroupId: messageGroupId));

  Future<void> markAllAsRead() => _notificationApi.markAllRead();

  Future<NotificationListResponseModel> getPendingNotifications({
    int currentPage,
    int itemsCount = itemsPerPage,
  }) =>
      _notificationApi.getNotificationMessages(itemsCount, currentPage);

  Future<UnreadNotificationCountResponseModel> getUnreadNotificationCount() =>
      _notificationApi.getUnreadCount();
}
