import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/base_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/request_model/read_notification_request_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/unread_notification_count_response_model.dart';

class NotificationApi extends BaseApi {
  NotificationApi(HttpClient httpClient) : super(httpClient);

  static const String notificationMessagesPath = '/notificationMessages';
  static const String notificationReadPath = '$notificationMessagesPath/read';
  static const String notificationReadAllPath =
      '$notificationMessagesPath/read/all';
  static const String notificationUnreadCountPath =
      '$notificationMessagesPath/unread/count';

  //query params
  static const String queryParamCurrentPage = 'CurrentPage';
  static const String queryParamPageSize = 'PageSize';

  Future<void> markAsRead(ReadNotificationRequestModel requestModel) =>
      exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(
          notificationReadPath,
          data: requestModel.toJson(),
        );
      });

  Future<void> markAllRead() => exceptionHandledHttpClientRequest(() async {
        await httpClient.post<dynamic>(notificationReadAllPath);
      });

  Future<NotificationListResponseModel> getNotificationMessages(
    int pageSize,
    int currentPage,
  ) =>
      exceptionHandledHttpClientRequest(() async {
        final response = await httpClient.get<Map<String, dynamic>>(
            notificationMessagesPath,
            queryParameters: {
              queryParamCurrentPage: currentPage,
              queryParamPageSize: pageSize,
            });
        return NotificationListResponseModel.fromJson(response.data);
      });

  Future<UnreadNotificationCountResponseModel> getUnreadCount() =>
      exceptionHandledHttpClientRequest(() async {
        final response =
            await httpClient.get<dynamic>(notificationUnreadCountPath);
        return UnreadNotificationCountResponseModel.fromJson(response.data);
      });
}
