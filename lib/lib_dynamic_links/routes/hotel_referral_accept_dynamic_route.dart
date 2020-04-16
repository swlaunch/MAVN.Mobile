import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_routes.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/dynamic_link_route_base.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class HotelReferralAcceptDynamicRoute extends DynamicLinkRouteBase {
  HotelReferralAcceptDynamicRoute(Router router, this._hotelReferralBloc)
      : super(router);

  final AcceptHotelReferralBloc _hotelReferralBloc;

  @override
  String get routeName => DynamicLinkRoutes.hotelReferralAcceptRoute;

  @override
  Future<void> processRequest(Uri uri) async {
    await _hotelReferralBloc.storeReferralCode(uri.queryParameters['code']);
  }

  @override
  Future<bool> routePendingRequest(BlocEvent fromEvent) async {
    if (fromEvent is HotelReferralSubmissionStoredKey &&
        !router.isHotelReferralAcceptedCurrentRoute) {
      await router.pushHotelReferralAcceptedPage();
      return true;
    }

    if (fromEvent == null &&
        _hotelReferralBloc.hasPendingReferralConfirmation()) {
      await router.pushHotelReferralAcceptedPage();
      return true;
    }

    return false;
  }
}
