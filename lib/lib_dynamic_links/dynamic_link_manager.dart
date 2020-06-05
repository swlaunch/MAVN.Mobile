import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/app_referral_dynamic_route.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/dynamic_link_route_base.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/email_confirmation_dynamic_route.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/hotel_referral_accept_dynamic_route.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/reset_password_dynamic_route.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/voucher_purchase_dynamic_route.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:meta/meta.dart';

class DynamicLinkManager {
  DynamicLinkManager({
    @required this.firebaseDynamicLinks,
    @required this.router,
    @required AcceptHotelReferralBloc hotelReferralBloc,
    @required EmailConfirmationBloc emailConfirmationBloc,
    @required VoucherPurchaseSuccessBloc voucherPurchaseSuccessBloc,
    @required SharedPreferencesManager sharedPreferencesManager,
  }) : routes = [
          EmailConfirmationDynamicRoute(router, emailConfirmationBloc),
          HotelReferralAcceptDynamicRoute(router, hotelReferralBloc),
          ResetPasswordDynamicRoute(router),
          AppReferralDynamicLinkRoute(router, sharedPreferencesManager),
          VoucherPurchaseDynamicRoute(router, voucherPurchaseSuccessBloc),
        ];

  FirebaseDynamicLinks firebaseDynamicLinks;
  Router router;

  final List<DynamicLinkRouteBase> routes;

  /// Indicates whether is already listen so that double listening is prevented
  bool _isListen = false;

  Future<void> startListenOnceForDynamicLinks() async {
    if (_isListen) {
      return;
    }

    _isListen = true;

    final data = await firebaseDynamicLinks.getInitialLink();
    handleDeepLink(data?.link);

    firebaseDynamicLinks.onLink(onSuccess: (dynamicLink) async {
      handleDeepLink(dynamicLink?.link);
    }, onError: (e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void handleDeepLink(Uri deepLink) {
    final link = deepLink?.queryParameters == null ||
            deepLink?.queryParameters['link'] == null
        ? deepLink
        : Uri.parse(deepLink.queryParameters['link']);

    final path = link?.path;

    if (path == null) {
      return;
    }

    routes.firstWhere((route) => route.routeName == path)?.processRequest(link);
  }

  Future<void> routePendingRequests({BlocEvent fromEvent}) async {
    for (final route in routes) {
      if (await route.routePendingRequest(fromEvent)) {
        break;
      }
    }
  }

  Future<void> routeEmailConfirmationRequests({BlocEvent fromEvent}) async {
    await routes
        .firstWhere((route) => route is EmailConfirmationDynamicRoute)
        ?.routePendingRequest(fromEvent);
  }
}

DynamicLinkManager useDynamicLinkManager() =>
    ModuleProvider.of<AppModule>(useContext()).dynamicLinkManager;
