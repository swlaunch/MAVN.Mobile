import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_simple_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_simple_wallet_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_scrollable_content.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/list_items.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/copy_row_widget.dart';

class LinkSimpleWalletPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final linkSimpleWalletBloc = useLinkSimpleWalletBloc();
    final linkSimpleWalletState =
        useBlocState<LinkSimpleWalletState>(linkSimpleWalletBloc);
    final walletBloc = useWalletBloc();

    useEffect(() {
      linkSimpleWalletBloc.generateDAppURL();
    }, [linkSimpleWalletBloc]);

    final link = (linkSimpleWalletState is LinkSimpleWalletLoadedState)
        ? linkSimpleWalletState.url
        : '';

    return ScaffoldWithScrollableContent(
        heading: useLocalizedStrings().linkSimpleWalletHeader,
        hint: useLocalizedStrings().linkSimpleWalletDescription,
        bottomButton: PrimaryButton(
          text: useLocalizedStrings().backToWalletButton,
          onTap: () {
            walletBloc.fetchWallet();
            router.popToRoot();
          },
        ),
        content: OrderedListItems<Widget>(
          type: OrderedListType.numbered,
          items: [
            if (!(linkSimpleWalletState is LinkSimpleWalletErrorState))
              _buildCopyUrl(link, linkSimpleWalletState),
            if (linkSimpleWalletState is LinkSimpleWalletErrorState)
              Expanded(
                child: GenericErrorIconWidget(
                  onRetryTap: linkSimpleWalletBloc.generateDAppURL,
                  title: useLocalizedStrings().genericErrorShort,
                  text: linkSimpleWalletState.message.localize(useContext()),
                  errorKey: null,
                ),
              ),
            _buildListItem(useLocalizedStrings()
                .linkSimpleWalletInstructionSwitchToWallet),
            _buildListItem(
                useLocalizedStrings().linkSimpleWalletInstructionPasteAddress),
            _buildListItem(
                useLocalizedStrings().linkSimpleWalletInstructionPasteLink),
          ],
          numberStyle: TextStyles.darkBodyBody3Regular,
          itemBuilder: (item) => item,
        ));
  }

  Expanded _buildCopyUrl(
          String link, LinkSimpleWalletState linkSimpleWalletState) =>
      Expanded(
        child: CopyRowWidget(
          title: useLocalizedStrings().linkSimpleWalletInstructionCopyUrl,
          copyText: link,
          isLoading: linkSimpleWalletState is LinkSimpleWalletLoadingState,
        ),
      );

  Widget _buildListItem(String title) =>
      Text(title, style: TextStyles.darkBodyBody3Regular);
}
