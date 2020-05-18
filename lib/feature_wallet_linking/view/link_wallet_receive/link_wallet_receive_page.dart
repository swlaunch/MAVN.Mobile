import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_scrollable_content.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/copy_row_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LinkWalletReceivePage extends HookWidget {
  static const qrCodeSizeRatio = 0.5;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final walletBlock = useWalletBloc();
    final walletBlockState = useBlocState<WalletState>(walletBlock);

    final gatewayAddress = walletBlockState is WalletLoadedState
        ? walletBlockState.wallet.transitAccountAddress ?? ''
        : '';

    return ScaffoldWithScrollableContent(
      heading: useLocalizedStrings().linkWalletReceiveTitle(tokenSymbol.value),
      hint: useLocalizedStrings().linkWalletReceiveHint(tokenSymbol.value),
      content: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          _buildQRCode(context, gatewayAddress),
          const SizedBox(height: 24),
          _buildCopyRow(
            useLocalizedStrings().linkWalletReceiveCopyAddress,
            gatewayAddress,
            false,
          ),
          const SizedBox(height: 32),
          Container(
            width: 248,
            child: Text(
              useLocalizedStrings().linkWalletReceiveNote,
              style: TextStyles.darkBodyBody3RegularHigh,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode(BuildContext context, String gatewayAddress) => Center(
        child: Column(
          children: <Widget>[
            QrImage(
              key: const Key('linkWalletReceiveQR'),
              data: gatewayAddress,
              size: qrCodeSizeRatio * MediaQuery.of(context).size.width,
            ),
          ],
        ),
      );

  Widget _buildCopyRow(String title, String gatewayAddress, bool isLoading) =>
      CopyRowWidget(
        title: title,
        copyText: gatewayAddress,
        isLoading: isLoading,
        styledToastPosition: StyledToastPosition.bottom,
        copyWidgetType: CopyWidgetType.simple,
      );
}
