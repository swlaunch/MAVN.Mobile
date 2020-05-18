import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_routes.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/dynamic_link_route_base.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class LeadReferralAcceptDynamicRoute extends DynamicLinkRouteBase {
  LeadReferralAcceptDynamicRoute(Router router, this._leadReferralBloc)
      : super(router);

  final AcceptLeadReferralBloc _leadReferralBloc;

  @override
  String get routeName => DynamicLinkRoutes.leadReferralAcceptRoute;

  @override
  Future<void> processRequest(Uri uri) async {
    await _leadReferralBloc.storeReferralCode(uri.queryParameters['code']);
  }

  @override
  Future<bool> routePendingRequest(BlocEvent fromEvent) async {
    if (fromEvent is LeadReferralSubmissionStoredKey &&
        !router.isLeadReferralAcceptedCurrentRoute) {
      await router.pushLeadReferralAcceptedPage();
      return true;
    }

    if (fromEvent == null &&
        _leadReferralBloc.hasPendingReferralConfirmation()) {
      await router.pushLeadReferralAcceptedPage();
      return true;
    }

    return false;
  }
}
