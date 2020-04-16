import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/notification/notification_repository.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'notification_count_bloc_output.dart';

class NotificationCountBloc extends Bloc<NotificationCountState> {
  NotificationCountBloc(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  @override
  NotificationCountState initialState() =>
      NotificationCountUninitializedState();

  Future<void> getUnreadNotificationCount() async {
    setState(
        NotificationCountLoadingState(unreadCount: currentState.unreadCount));

    try {
      final response =
          await _notificationRepository.getUnreadNotificationCount();

      final count = response.unreadMessagesCount;

      if (count == 0) {
        setState(NotificationCountEmptyState());
        return;
      }

      //show count only if its different to what we've previously shown
      if (currentState.unreadCount >= count) {
        setState(NotificationCountDoNotShowCountState(unreadCount: count));
        return;
      }

      setState(NotificationCountShowCountState(unreadCount: count));
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(NotificationCountNetworkErrorState(
            unreadCount: currentState.unreadCount));
        return;
      }

      setState(NotificationCountGenericErrorState(
          unreadCount: currentState.unreadCount));
    }
  }

  Future<void> markAsSeen() async {
    setState(NotificationCountDoNotShowCountState(
        unreadCount: currentState.unreadCount));
  }
}

NotificationCountBloc useNotificationCountBloc() =>
    ModuleProvider.of<AppModule>(useContext()).notificationCountBloc;
