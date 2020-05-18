import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class NotificationListItemView extends StatelessWidget {
  const NotificationListItemView({
    @required this.notificationListItem,
    this.onTap,
  });

  final NotificationListNotification notificationListItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        child: Container(
          color: notificationListItem.notification.isRead
              ? ColorStyles.white
              : ColorStyles.offWhite,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StandardSizedSvg(
                notificationListItem.icon,
                color: ColorStyles.slateGrey,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NullSafeText(
                      notificationListItem.notification.message,
                      style: TextStyles.darkBodyBody4Regular,
                    ),
                    const SizedBox(height: 4),
                    NullSafeText(
                      notificationListItem.formattedDate.localize(context),
                      style: TextStyles.notificationListItemSubtitle,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      );
}

class NotificationListHeaderView extends StatelessWidget {
  const NotificationListHeaderView(this.notificationListHeader);

  final NotificationListHeader notificationListHeader;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: NullSafeText(
          notificationListHeader.text.localize(context),
          style: TextStyles.darkHeadersH3,
        ),
      );
}

abstract class NotificationListItem {}

class NotificationListNotification extends NotificationListItem {
  NotificationListNotification(
    this.notification,
    this.icon,
    this.formattedDate,
  );

  final NotificationMessage notification;
  final String icon;
  final LocalizedStringBuilder formattedDate;
}

class NotificationListHeader extends NotificationListItem {
  NotificationListHeader(this.text);

  final LocalizedStringBuilder text;
}
