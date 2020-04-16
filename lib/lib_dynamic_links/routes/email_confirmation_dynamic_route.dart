import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc_output.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/dynamic_link_route_base.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import '../dynamic_link_routes.dart';

class EmailConfirmationDynamicRoute extends DynamicLinkRouteBase {
  EmailConfirmationDynamicRoute(Router router, this._emailConfirmationBloc)
      : super(router);

  final EmailConfirmationBloc _emailConfirmationBloc;

  @override
  String get routeName => DynamicLinkRoutes.emailConfirmationRoute;

  @override
  Future<void> processRequest(Uri uri) async {
    await _emailConfirmationBloc
        .storeVerificationCode(uri.queryParameters['code']);
  }

  @override
  Future<bool> routePendingRequest(BlocEvent fromEvent) async {
    if ((fromEvent is EmailConfirmationStoredKey &&
            !router.isEmailVerificationCurrentRoute) ||
        (fromEvent == null &&
            _emailConfirmationBloc.hasPendingEmailConfirmation())) {
      await router.replaceWithEmailConfirmationPage();
      return true;
    }

    return false;
  }
}
