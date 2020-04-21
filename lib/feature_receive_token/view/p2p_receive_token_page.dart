import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/copy_row_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class P2pReceiveTokenPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final receiveTokenBloc = useP2PReceiveTokenBloc();
    final receiveTokenState =
        useBlocState<ReceiveTokenPageState>(receiveTokenBloc);

    useEffect(
      () {
        receiveTokenBloc.getCustomer();
      },
      [receiveTokenBloc],
    );

    return ScaffoldWithAppBar(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              PageTitle(
                title: useLocalizedStrings()
                    .receiveTokenPageTitle(tokenSymbol.value),
                assetIconLeading: SvgAssets.receiveTokens,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildDetails(),
                          const SizedBox(height: 50),
                          if (receiveTokenState is ReceiveTokenPageSuccess)
                            _buildQRCode(
                              context,
                              receiveTokenState.email,
                            ),
                          if (receiveTokenState is ReceiveTokenPageLoadingState)
                            const Spinner(
                                key: Key('receiveTokenLoadingSpinner')),
                          if (receiveTokenState is ReceiveTokenPageErrorState)
                            GenericErrorIconWidget(
                              title: receiveTokenState
                                  .errorTitle.localize(useContext()),
                              text: receiveTokenState
                                  .errorSubtitle.localize(useContext()),
                              icon: receiveTokenState.iconAsset,
                              errorKey: const Key('receiveTokenError'),
                              onRetryTap: receiveTokenBloc.getCustomer,
                            ),
                        ]),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() => Text(
        useLocalizedStrings().receiveTokenPageSubDetails,
        style: TextStyles.darkBodyBody1RegularHigh,
      );

  Widget _buildQRCode(BuildContext context, String email) => Center(
        child: Column(
          children: <Widget>[
            QrImage(
              key: const Key('receiveTokenQR'),
              data: email,
              size: 0.7 * MediaQuery.of(context).size.width,
            ),
            Text(
              email,
              style: TextStyles.darkBodyBody3RegularHigh,
            ),
            const SizedBox(height: 20),
            CopyRowWidget(
              title: useLocalizedStrings().copyEmail,
              copyText: email,
              copyWidgetType: CopyWidgetType.simple,
            )
          ],
        ),
      );
}
