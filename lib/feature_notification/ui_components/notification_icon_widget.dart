import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_notification/ui_components/badge_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class NotificationIconWidget extends HookWidget {
  const NotificationIconWidget({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final notificationCountBloc = useNotificationCountBloc();
    final notificationCountState = useBlocState(notificationCountBloc);

    return Stack(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: StandardSizedSvg(
              SvgAssets.bell,
              color: color,
            ),
          ),
        ),
        if (notificationCountState is NotificationCountLoadedState)
          _buildBadge(notificationCountState),
      ],
    );
  }

  Widget _buildBadge(NotificationCountState notificationCountState) {
    if (notificationCountState is NotificationCountEmptyState ||
        notificationCountState is NotificationCountDoNotShowCountState) {
      return Container();
    }
    if (notificationCountState is NotificationCountShowCountState) {
      return _buildBadgeWidget(notificationCountState.unreadCount.toString());
    }
  }

  Widget _buildBadgeWidget(String text) =>
      const Positioned(right: 1, top: 4, child: BadgeWidget());
}
