import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/link_advanced_wallet_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/link_advanced_wallet/link_advanced_wallet_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_scrollable_content.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';

class LinkAdvancedWalletPage extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  final _linkingCodeGlobalKey = GlobalKey();
  final _publicAddressGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final linkAdvancedWalletBloc = useLinkAdvancedWalletBloc();

    final linkingCodeController = useCustomTextEditingController();
    final publicAddressController = useCustomTextEditingController();

    useBlocEventListener(linkAdvancedWalletBloc, (event) {
      if (event is LinkAdvancedWalletSubmissionSuccessEvent) {
        router
          ..popToRoot()
          ..pushLinkWalletInProgressPage();
      }

      if (event is LinkAdvancedWalletSubmissionErrorEvent) {
        ToastMessage.show(event.message.localize(context), context);
      }
    });

    void onSubmit() {
      linkAdvancedWalletBloc.linkPrivateWallet(
          publicAddress: publicAddressController.text,
          linkingCode: linkingCodeController.text);
    }

    return ScaffoldWithScrollableContent(
      heading: useLocalizedStrings().linkAdvancedWalletHeader,
      hint: useLocalizedStrings().linkAdvancedWalletDescription,
      content: LinkingAdvancedWalletForm(
        formKey: _formKey,
        linkingCodeContextGlobalKey: _linkingCodeGlobalKey,
        publicAddressContextGlobalKey: _publicAddressGlobalKey,
        linkingCodeController: linkingCodeController,
        publicAddressController: publicAddressController,
        onSubmitTapped: onSubmit,
      ),
    );
  }
}
