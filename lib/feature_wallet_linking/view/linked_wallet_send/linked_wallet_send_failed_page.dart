import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_utility/result_feedback/view/result_feedback_page.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/bloc/linked_wallet_send_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';

class LinkedWalletSendFailedPage extends HookWidget {
  const LinkedWalletSendFailedPage({
    this.amount,
    this.error,
  });

  final String amount;
  final String error;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final linkedWalletSendBloc = useLinkedWalletSendBloc();
    final linkedWalletSendState =
        useBlocState<LinkedWalletSendState>(linkedWalletSendBloc);

    useBlocEventListener(linkedWalletSendBloc, (event) {
      if (event is LinkedWalletSendErrorEvent) {
        ToastMessage.show(event.message.localize(context), context);
        return;
      }

      if (event is LinkedWalletSendLoadedEvent) {
        router
          ..popToRoot()
          ..pushLinkedWalletSendProgressPage();
      }
    });

    return ResultFeedbackPage(
      widgetKey: const Key('linkedWalletSendFailedWidget'),
      title: useLocalizedStrings().linkWalletTransferFailedTitle,
      details: useLocalizedStrings().linkWalletTransferFailedDetails,
      subDetails: error,
      subDetailsStyle: TextStyles.darkBodyBody1Bold,
      buttonText: useLocalizedStrings().retryButton,
      resultFeedbackButtonStyle: ResultFeedbackButtonStyle.styled,
      onButtonTap: () =>
          linkedWalletSendBloc.transferToken(Decimal.tryParse(amount) ?? 0.0),
      isLoading: linkedWalletSendState is LinkedWalletSendLoadingState,
      endIcon: SvgAssets.error,
    );
  }
}
