import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/notification/notification_routes.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/feature_notification/di/notification_module.dart';
import 'package:lykke_mobile_mavn/feature_notification/view/notification_list_item.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/date_time_utils.dart';

class NotificationToItemMapper {
  NotificationToItemMapper(this._dateTimeManager);

  final DateTimeManager _dateTimeManager;

  ///Returns a list of [NotificationListItem] for the [notifications]
  ///
  ///If [addSectionHeaders] is true, the list consists of
  ///both [NotificationListNotification] and [NotificationListHeader] items
  ///If [addSectionHeaders] is true, the list consists of
  ///only [NotificationListNotification]
  List<NotificationListItem> mapNotifications({
    List<NotificationMessage> notifications,
    bool addSectionHeaders = true,
  }) {
    if (addSectionHeaders) {
      final now = DateTime.now();

      return [
        ..._getSection(
            now: now,
            isWithin24Hours: true,
            headerName: LazyLocalizedStrings.newHeader,
            notifications: notifications),
        ..._getSection(
            now: now,
            isWithin24Hours: false,
            headerName: LazyLocalizedStrings.earlierHeader,
            notifications: notifications),
      ];
    }

    return _transform(notifications);
  }

  ///Returns a list of [NotificationListItem] that contains all
  ///mapped notifications plus the relevant header based on the passed
  ///parameters.
  ///
  ///A [NotificationListHeader] is added as first item in the list
  ///using [headerName] for its title.
  ///By using [isWithin24Hours] the [notifications] are filtered
  ///and added to the returned list.
  ///
  /// If there are no [NotificationMessages] that adhere to [isWithin24Hours],
  /// an empty list is returned.
  List<NotificationListItem> _getSection({
    DateTime now,
    bool isWithin24Hours,
    LocalizedStringBuilder headerName,
    List<NotificationMessage> notifications,
  }) {
    final mappedNotifications = <NotificationListItem>[];

    //get the partition of the whole list that matches the 24-hour condition
    final partition = notifications
        .where((notificationMessage) =>
            DateTimeUtils.dateIsWithin24Hours(
                now, notificationMessage.creationDate.toLocal()) ==
            isWithin24Hours)
        .toList();

    if (partition.isNotEmpty) {
      mappedNotifications
        ..add(NotificationListHeader(headerName))
        ..addAll(_transform(partition));
    }

    return mappedNotifications;
  }

  ///Maps a list of [NotificationMessage] to
  ///a list of [NotificationListNotification]
  List<NotificationListItem> _transform(
          List<NotificationMessage> notifications) =>
      notifications
          .map((notificationMessage) => NotificationListNotification(
                notificationMessage,
                _mapRouteToAsset(notificationMessage
                    .payload.notificationTappedCustomPayload.route),
                _dateTimeManager.getTimeAgo(
                  notificationMessage.creationDate.toLocal(),
                ),
              ))
          .toList();
}

///Returns the relevant SVG asset for the [route]
String _mapRouteToAsset(String route) {
  if (route == NotificationRoutes.referralListPageRoute) {
    return SvgAssets.refer;
  }
  return SvgAssets.wallet;
}

NotificationToItemMapper useNotificationMapper() =>
    ModuleProvider.of<NotificationModule>(useContext()).notificationMapper;
