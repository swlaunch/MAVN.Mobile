import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc_output.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_routes.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/routes/dynamic_link_route_base.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class VoucherPurchaseDynamicRoute extends DynamicLinkRouteBase {
  VoucherPurchaseDynamicRoute(Router router, this._voucherPurchaseSuccessBloc)
      : super(router);

  final VoucherPurchaseSuccessBloc _voucherPurchaseSuccessBloc;

  @override
  String get routeName => DynamicLinkRoutes.voucherPurchaseRoute;

  @override
  Future<void> processRequest(Uri uri) async {
    await _voucherPurchaseSuccessBloc.storeFlag();
  }

  @override
  Future<bool> routePendingRequest(BlocEvent fromEvent) async {
    if ((fromEvent is VoucherPurchaseSuccessStoredKey) ||
        (fromEvent == null && _voucherPurchaseSuccessBloc.hasBoughtVoucher())) {
      await _voucherPurchaseSuccessBloc.seeVoucher();
      router.pushBoughtVoucherSuccessPage();
      return true;
    }

    return false;
  }
}
