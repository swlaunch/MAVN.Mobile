import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class NotificationCountState extends BlocState {
  NotificationCountState({this.unreadCount = 0});

  final int unreadCount;

  @override
  List get props => super.props..addAll([unreadCount]);
}

class NotificationCountUninitializedState extends NotificationCountState {}

class NotificationCountLoadingState extends NotificationCountState {
  NotificationCountLoadingState({int unreadCount = 0})
      : super(unreadCount: unreadCount);
}

class NotificationCountGenericErrorState extends NotificationCountState {
  NotificationCountGenericErrorState({int unreadCount = 0})
      : super(unreadCount: unreadCount);
}

class NotificationCountNetworkErrorState extends NotificationCountState {
  NotificationCountNetworkErrorState({int unreadCount = 0})
      : super(unreadCount: unreadCount);
}

abstract class NotificationCountLoadedState extends NotificationCountState {
  NotificationCountLoadedState({@required int unreadCount})
      : super(unreadCount: unreadCount);
}

class NotificationCountEmptyState extends NotificationCountLoadedState {
  NotificationCountEmptyState() : super(unreadCount: 0);
}

class NotificationCountShowCountState extends NotificationCountLoadedState {
  NotificationCountShowCountState({@required int unreadCount})
      : super(unreadCount: unreadCount);
}

class NotificationCountDoNotShowCountState
    extends NotificationCountLoadedState {
  NotificationCountDoNotShowCountState({@required int unreadCount})
      : super(unreadCount: unreadCount);
}
