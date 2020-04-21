import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_wallet_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/list_items.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';

class LinkWalletPage extends HookWidget {

  @override
  Widget build(BuildContext context) {
    final _instructions = [
      useLocalizedStrings().linkWalletInstructionSelectWallet,
      useLocalizedStrings().linkWalletInstructionConfirmLinking,
      useLocalizedStrings().linkWalletInstructionFees,
    ];

    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final router = useRouter();
    final linkWalletBloc = useLinkWalletBloc();

    useBlocEventListener(linkWalletBloc, (event) {
      if (event is LinkWalletErrorEvent) {
        ToastMessage.show(event.message.localize(context), context);
      }

      if (event is LinkWalletLoadedEvent) {
        router.pushLinkWalletByType(event.type);
      }
    });

    return ScaffoldWithAppBar(
        useDarkTheme: false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(useLocalizedStrings().linkWalletHeader),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: Text(
                  useLocalizedStrings().externalLinkWalletDescription(
                      tokenSymbol.value),
                  style: TextStyles.darkBodyBody1RegularHigh,
                ),
              ),
              OrderedListItems<String>(
                items: _instructions,
                itemBuilder: (item) =>
                    Text(item, style: TextStyles.darkBodyBody3Regular),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 42, bottom: 28),
                child: Text(
                  useLocalizedStrings().linkWalletChooseSupportedWallets,
                  style: TextStyles.darkHeadersH3,
                ),
              ),
              const Divider(),
              _buildWallet(
                title: useLocalizedStrings().simpleWalletsTitle,
                description: useLocalizedStrings().simpleWalletsDescription,
                onTap: () => linkWalletBloc.linkByType(LinkWalletType.simple),
              ),
              const Divider(),
              _buildWallet(
                title: useLocalizedStrings().advancedWalletsTitle,
                description: useLocalizedStrings().advancedWalletsDescription,
                onTap: () => linkWalletBloc.linkByType(LinkWalletType.advanced),
              ),
              const Divider(),
            ],
          ),
        ));
  }

  Widget _buildWallet({
    @required String title,
    @required String description,
    @required Function onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(SvgAssets.wallet),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 4),
                      child: Text(title,
                          style: TextStyles.darkBodyBody2RegularHigh),
                    ),
                    Text(description,
                        style: TextStyles.darkBodyBody3RegularHigh),
                  ],
                ),
              ),
              SvgPicture.asset(SvgAssets.arrow),
              const SizedBox(width: 4),
            ],
          ),
        ),
      );
}
