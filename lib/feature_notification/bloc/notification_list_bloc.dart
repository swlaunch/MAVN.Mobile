import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/notification/notification_repository.dart';
import 'package:lykke_mobile_mavn/feature_notification/di/notification_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

class NotificationListBloc extends GenericListBloc<
    NotificationListResponseModel, NotificationMessage> {
  NotificationListBloc(this._notificationRepository)
      : super(
            genericErrorSubtitle: LazyLocalizedStrings
                .notificationListRequestGenericErrorSubtitle);

  final NotificationRepository _notificationRepository;

  @override
  int getCurrentPage(NotificationListResponseModel response) =>
      response.currentPage;

  @override
  List<NotificationMessage> getDataFromResponse(
          NotificationListResponseModel response) =>
      response.notifications;

  @override
  int getTotalCount(NotificationListResponseModel response) =>
      response.totalCount;

  @override
  Future<NotificationListResponseModel> loadData(int page) =>
      _notificationRepository.getPendingNotifications(currentPage: page);

  @override
  List<NotificationMessage> sort(List<NotificationMessage> list) =>
      ListUtils.sortBy(
        list,
        (item) => item.creationDate,
        descendingOrder: true,
      );
}

NotificationListBloc useNotificationListBloc() =>
    ModuleProvider.of<NotificationModule>(useContext()).notificationListBloc;
