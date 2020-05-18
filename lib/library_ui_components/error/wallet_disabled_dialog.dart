import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/single_button_dialog.dart';

class WalletDisabledDialog extends HookWidget {
  const WalletDisabledDialog();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SingleButtonDialog(
        title: useLocalizedStrings().walletPageWalletDisabledError,
        content: useLocalizedStrings().walletPageWalletDisabledErrorMessage,
        buttonText: useLocalizedStrings().contactUsButton,
        onTap: () {
          router
            ..popDialog()
            ..popToRoot()
            ..switchToWalletTab()
            ..pushContactUsPage();
        },
      ),
    );
  }
}
