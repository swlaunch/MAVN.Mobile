import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class DynamicLinkRouteBase {
  DynamicLinkRouteBase(this.router);

  Router router;

  String get routeName;

  Future<void> processRequest(Uri uri);

  ///Route to pending requests if any.In case there is no need of routing
  ///the result Future will emmit false
  Future<bool> routePendingRequest(BlocEvent fromEvent);
}
