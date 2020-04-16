import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/notification/notification_routes.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_fcm/notification_tapped.dart';

class NotificationRouter {
  NotificationRouter(this._router);

  final Router _router;

  ///Routes a [NotificationTapped] to the relevant page
  ///
  /// Can be used both with [NotificationMessage.payload] and
  /// the [NotificationTapped]
  void route(NotificationTapped notificationTapped) {
    if (notificationTapped == null) {
      return;
    }
    final route = notificationTapped.notificationTappedCustomPayload.route;
    switch (route) {
      case NotificationRoutes.referralListPageRoute:
        {
          _router
            ..popToRoot()
            ..pushReferralListPage();
          break;
        }
      case NotificationRoutes.transactionHistoryPageRoute:
      case NotificationRoutes.walletPageRoute:
        {
          _router
            ..popToRoot()
            ..switchToWalletTab();
          break;
        }
      case NotificationRoutes.paymentRequestPageRoute:
        {
          _router
            ..popToRoot()
            ..switchToWalletTab()
            ..pushPaymentRequestListPage()
            ..pushPaymentRequestPage(
                (notificationTapped.notificationTappedCustomPayload
                        as PaymentRequestNotificationTapped)
                    .paymentId,
                fromPushNotification: true);
          break;
        }
      case NotificationRoutes.hotelWelcomeRoute:
        {
          _router.showHotelWelcomeDialog(
              (notificationTapped.notificationTappedCustomPayload
                      as HotelWelcomeNotificationTapped)
                  .partnerMessageId);
          break;
        }
    }
  }
}

NotificationRouter useNotificationRouter() =>
    ModuleProvider.of<AppModule>(useContext()).notificationRouter;
