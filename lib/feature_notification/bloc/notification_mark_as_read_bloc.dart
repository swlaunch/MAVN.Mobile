import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/notification/notification_repository.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_notification/di/notification_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class NotificationMarkAsReadBloc extends Bloc<NotificationMarkAsReadState> {
  NotificationMarkAsReadBloc(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  @override
  NotificationMarkAsReadState initialState() =>
      NotificationMarkAsReadUninitializedState();

  Future<void> markAsRead(String messageGroupId) async {
    setState(NotificationMarkAsReadLoadingState());

    try {
      await _notificationRepository.markAsRead(messageGroupId: messageGroupId);
      setState(NotificationMarkAsReadLoadedState());
      sendEvent(NotificationSuccessfullyMarkedAsRead());
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(NotificationMarkAsReadNetworkErrorState());
        return;
      }
      setState(NotificationMarkAsReadGenericErrorState());
    }
  }

  Future<void> markAllAsRead() async {
    setState(NotificationMarkAsReadLoadingState());

    try {
      await _notificationRepository.markAllAsRead();
      setState(NotificationMarkAsReadLoadedState());
      sendEvent(NotificationSuccessfullyMarkedAsRead());
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(NotificationMarkAsReadNetworkErrorState());
        return;
      }
      setState(NotificationMarkAsReadGenericErrorState());
    }
  }
}

NotificationMarkAsReadBloc useNotificationMarkAsReadBloc() =>
    ModuleProvider.of<NotificationModule>(useContext())
        .notificationMarkAsReadBloc;
