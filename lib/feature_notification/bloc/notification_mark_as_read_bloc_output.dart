import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class NotificationMarkAsReadState extends BlocState {}

class NotificationMarkAsReadUninitializedState
    extends NotificationMarkAsReadState {}

class NotificationMarkAsReadLoadingState extends NotificationMarkAsReadState {}

class NotificationMarkAsReadGenericErrorState
    extends NotificationMarkAsReadState {}

class NotificationMarkAsReadNetworkErrorState
    extends NotificationMarkAsReadState {}

class NotificationMarkAsReadLoadedState extends NotificationMarkAsReadState {}

class NotificationSuccessfullyMarkedAsRead extends BlocEvent {}
