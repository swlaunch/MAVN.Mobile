import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/view/transfer_voucher_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';

class TransferVoucherPage extends HookWidget with FormMixin {
  TransferVoucherPage({this.voucherCode});

  final _formKey = GlobalKey<FormState>();
  final _receiverEmailGlobalKey = GlobalKey();
  final _receiverEmailFieldKey = GlobalKey<FormFieldState>();
  final String voucherCode;

  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    final router = useRouter();

    final transferVoucherBloc = useTransferVoucherBloc();
    final transferVoucherState =
        useBlocState<TransferVoucherState>(transferVoucherBloc);

    final isFormSubmissionErrorDismissed = useState(false);
    final receiverEmailController = useCustomTextEditingController();

    useBlocEventListener(transferVoucherBloc, (event) {
      if (event is TransferVoucherSuccessEvent) {
        //TODO update vouchers
        router.replaceWithVoucherTransferSuccessPage(
            receiverEmail: receiverEmailController.text);
      }
    });

    void onSend() {
      isFormSubmissionErrorDismissed.value = false;
      transferVoucherBloc.transferVoucher(
          receiverEmail: receiverEmailController.text,
          voucherShortCode: voucherCode);
    }

    return DismissKeyboardOnTap(
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                PageTitle(
                  title: localizedStrings.sendVoucher,
                  assetIconLeading: SvgAssets.voucher,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.only(left: 24, top: 16, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 32),
                        TransferVoucherForm(
                          formKey: _formKey,
                          receiverEmailGlobalKey: _receiverEmailGlobalKey,
                          receiverEmailFieldKey: _receiverEmailFieldKey,
                          receiverEmailTextEditingController:
                              receiverEmailController,
                          onSendTap: onSend,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (transferVoucherState is TransferVoucherErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                error: transferVoucherState.error.localize(useContext()),
                onRetryTap: onSend,
                onCloseTap: () => isFormSubmissionErrorDismissed.value = true,
              ),
            if (transferVoucherState is TransferVoucherNetworkErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildNetworkError(onRetry: onSend),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkError({VoidCallback onRetry}) => Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: NetworkErrorWidget(onRetry: onRetry),
      ));

  Widget _buildError({
    String key,
    String error,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      Align(
        alignment: Alignment.bottomCenter,
        child: GenericErrorWidget(
          text: error,
          onRetryTap: onRetryTap,
          onCloseTap: onCloseTap,
        ),
      );
}
