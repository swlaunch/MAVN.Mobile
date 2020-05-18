import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/available_and_staked_balance_widget.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/linked_wallet_send/linked_wallet_send_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_scrollable_content.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';

class LinkedWalletSendPage extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  final _amountGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final router = useRouter();
    final walletBloc = useWalletBloc();
    final walletState = useBlocState<WalletState>(walletBloc);

    final linkedWalletSendBloc = useLinkedWalletSendBloc();
    final linkedWalletSendState =
        useBlocState<LinkedWalletSendState>(linkedWalletSendBloc);

    final amountController = useCustomTextEditingController();

    useBlocEventListener(linkedWalletSendBloc, (event) {
      if (event is LinkedWalletSendErrorEvent) {
        router.pushLinkedWalletSendFailedPage(
          amount: amountController.value.text,
          error: event.message.localize(useContext()),
        );
        return;
      }

      if (event is LinkedWalletSendLoadedEvent) {
        router.pushLinkedWalletSendProgressPage();
        return;
      }
    });

    final balance = walletState is WalletLoadedState
        ? walletState.wallet.balance.decimalValue
        : Decimal.fromInt(0);

    return DismissKeyboardOnTap(
      child: ScaffoldWithScrollableContent(
        heading: useLocalizedStrings().linkedWalletSendTitle(tokenSymbol.value),
        hint: useLocalizedStrings().linkedWalletSendHint(tokenSymbol.value),
        content: Column(
          children: [
            const SizedBox(height: 32),
            AvailableAndStakedBalanceWidget.withState(walletState),
            LinkedWalletSendForm(
              formKey: _formKey,
              amountController: amountController,
              amountGlobalKey: _amountGlobalKey,
              balance: balance,
              formSubmitted: () => linkedWalletSendBloc.transferToken(
                  NumberFormatter.tryParseDecimal(
                          amountController.value.text) ??
                      '0'),
              isLoading: linkedWalletSendState is LinkedWalletSendLoadingState,
            )
          ],
        ),
      ),
    );
  }
}
