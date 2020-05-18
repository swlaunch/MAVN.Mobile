import 'package:decimal/decimal.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/di/wallet_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'link_wallet_output.dart';

class LinkWalletBloc extends Bloc<LinkWalletState> {
  LinkWalletBloc(this._balanceBloc);

  final BalanceBloc _balanceBloc;

  @override
  LinkWalletState initialState() => LinkWalletUninitializedState();

  Future<void> linkByType(LinkWalletType type) async {
    final balanceState = _balanceBloc.currentState;

    if (balanceState is BalanceLoadedState) {
      if (balanceState.wallet.balance.decimalValue <= Decimal.fromInt(1)) {
        sendEvent(LinkWalletErrorEvent(LocalizedStrings.insufficientFunds));
        return;
      }

      sendEvent(LinkWalletLoadedEvent(type));
      return;
    }

    sendEvent(LinkWalletErrorEvent(LocalizedStrings.couldNotLoadBalanceError));
  }
}

enum LinkWalletType { simple, advanced }

LinkWalletBloc useLinkWalletBloc() =>
    ModuleProvider.of<WalletLinkingModule>(useContext()).linkWalletBloc;
