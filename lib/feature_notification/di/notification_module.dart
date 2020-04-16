import 'package:lykke_mobile_mavn/base/repository/mapper/notification_mapper.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class NotificationModule extends Module {
  NotificationListBloc get notificationListBloc => get();

  NotificationMarkAsReadBloc get notificationMarkAsReadBloc => get();

  NotificationToItemMapper get notificationMapper => get();

  @override
  void provideInstances() {
    // Bloc
    provideSingleton(() => NotificationListBloc(get()));
    provideSingleton(() => NotificationMarkAsReadBloc(get()));
    provideSingleton(() => NotificationToItemMapper(get()));
  }
}
