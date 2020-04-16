import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_routes.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/dynamic_link_route_base.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class ResetPasswordDynamicRoute extends DynamicLinkRouteBase {
  ResetPasswordDynamicRoute(Router router) : super(router);

  @override
  String get routeName => DynamicLinkRoutes.resetPasswordRoute;

  @override
  Future<bool> routePendingRequest(BlocEvent fromEvent) async => false;

  @override
  Future<void> processRequest(Uri uri) {
    router.pushSetPasswordPage(
        uri.queryParameters['email'], uri.queryParameters['resetIdentifier']);
  }
}
