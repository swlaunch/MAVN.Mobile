import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';

class WalletDisabledWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    return GenericErrorIconWidget(
      errorKey: const Key('walletDisabledWidget'),
      title: useLocalizedStrings().walletPageWalletDisabledError,
      text: useLocalizedStrings().walletPageWalletDisabledErrorMessage,
      buttonText: useLocalizedStrings().contactUsButton,
      icon: SvgAssets.walletError,
      onRetryTap: router.pushContactUsPage,
    );
  }
}
