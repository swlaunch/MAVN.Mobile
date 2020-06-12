import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_utility/result_feedback/view/result_feedback_page.dart';

class TransferVoucherSuccessPage extends HookWidget {
  const TransferVoucherSuccessPage({@required this.receiverEmail});

  final String receiverEmail;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final router = useRouter();
    return ResultFeedbackPage(
      widgetKey: const Key('transferVoucherSuccessWidget'),
      title: localizedStrings.transferVoucherSuccessTitle,
      details: localizedStrings.transferVoucherSuccessDetails(receiverEmail),
      buttonText: localizedStrings.backToVouchers,
      onButtonTap: () {
        router
          ..popToRoot()
          ..switchToWalletTab();
      },
      endIcon: SvgAssets.success,
    );
  }
}
