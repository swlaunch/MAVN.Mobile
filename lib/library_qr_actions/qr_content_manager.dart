import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_base_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_invalidate_voucher_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_open_url_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_p2p_transaction_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_unsuported_action.dart';

class QrContentManager {
  QrContentManager(
    this.router,
    this.externalRouter,
    this.getMobileSettingsUseCase,
    this.customerBloc,
  ) : actions = [
          QrInvalidateVoucherAction(router: router, customerBloc: customerBloc),
          QrOpenUrlAction(externalRouter: externalRouter),
          QrGoToP2PTransactionAction(
            router: router,
            tokenSymbol: getMobileSettingsUseCase.execute()?.tokenSymbol,
          ),
        ];

  final List<QrBaseAction> actions;
  final Router router;
  final ExternalRouter externalRouter;
  final GetMobileSettingsUseCase getMobileSettingsUseCase;
  final CustomerBloc customerBloc;

  Future<QrBaseAction> getQrAction(String content) async {
    for (final action in actions) {
      if (await action.match(content)) return action;
    }

    return QrUnsupportedAction();
  }
}

QrContentManager useQrContentManager() =>
    ModuleProvider.of<AppModule>(useContext()).qrContentManager;
