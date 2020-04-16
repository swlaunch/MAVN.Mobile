import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/feature_notification/router/notification_router.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_fcm/notification_tapped.dart';
import 'package:pedantic/pedantic.dart';

class FirebaseMessagingBloc extends Bloc<FirebaseMessagingState> {
  FirebaseMessagingBloc(
    this._customerRepository,
    this._firebaseMessaging,
    this._notificationRouter,
  );

  static const notificationCountDisplayLimit = 9;

  final FirebaseMessaging _firebaseMessaging;
  final NotificationRouter _notificationRouter;
  final CustomerRepository _customerRepository;
  static const fcmStartDelayMillis = 500;

  @override
  FirebaseMessagingState initialState() =>
      FirebaseMessagingUninitializedState();

  Future<void> init() async {
    await _startListeningFirebaseMessaging();
    await _checkPushNotificationTokens();
  }

  Future<void> _startListeningFirebaseMessaging() async {
    /// We are delaying the start of the FirebaseMessaging plugin, because
    /// the first time we do this, on iOS devices, the user is prompted
    /// with a system dialog where they have to allow the permission for
    /// receiving notifications, and we don't want to show the dialog while
    /// we are transitioning to the HomePage, because when the dialog shows,
    /// Flutter stops all animations even though the Flutter view is visible
    /// in the background, so the Flutter view might stop while transitioning
    /// and it doesn't look that good. This will give the transition enough
    /// time to finish.
    await Future.delayed(const Duration(milliseconds: fcmStartDelayMillis));

    final hasPermission = await _checkPermission();
    if (!hasPermission) return;
    configure();
  }

  ///Check if we have permission to use notifications on iOS
  ///Since we will get null on Android, return true
  Future<bool> _checkPermission() async =>
      (await _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true))) ??
      true;

  void configure() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        sendEvent(FirebaseMessagingNotificationPendingEvent());
      },
      onLaunch: (message) async {
        print('fcmm onLaunch');

        _routeNotification(message);
      },
      onResume: (message) async {
        _routeNotification(message);
      },
    );
    setState(FirebaseMessagingConfiguredState());
  }

  Future<void> _checkPushNotificationTokens() async {
    unawaited(_firebaseMessaging.getToken().then((value) => _customerRepository
        .registerForPushNotifications(pushRegistrationToken: value)));
  }

  void _routeNotification(Map<String, dynamic> message) {
    final notificationTapped =
        NotificationTapped.fromFirebaseNotification(message);
    sendEvent(FirebaseMessagingMarkAsReadEvent(
        messageGroupId:
            notificationTapped.notificationTappedCustomPayload.messageGroupId));

    _notificationRouter.route(notificationTapped);
  }
}

FirebaseMessagingBloc useFirebaseMessagingBloc() =>
    ModuleProvider.of<AppModule>(useContext()).firebaseMessagingBloc;
