import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/partner_info_qr_content.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/scan_barcode_bloc.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/bloc/scan_barcode_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/bloc/sme_linking_bloc.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/bloc/sme_linking_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/view/sme_linking_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_extensions/tuple_extensions.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class SmeLinkingPage extends HookWidget with FormMixin {
  final _formKey = GlobalKey<FormState>();
  final _linkingCodeGlobalKey = GlobalKey();
  final _formFullNameContextGlobalKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final localizedStrings = useLocalizedStrings();

    final smeLinkingBloc = useSmeLinkingBloc();
    final smeLinkingBlocState = useBlocState<SmeLinkingState>(smeLinkingBloc);

    final barcodeScanBloc = useBarcodeScanBloc();
    final barcodeScanState = useBlocState(barcodeScanBloc);

    final partnerCodeTextEditingController = useCustomTextEditingController();
    final linkingCodeTextEditingController = useCustomTextEditingController();

    final isFormSubmissionErrorDismissed = useState(false);
    final isScanningErrorDismissed = useState(false);

    void onSubmit() {
      isFormSubmissionErrorDismissed.value = false;
      smeLinkingBloc.submitSmeLinking(
        partnerCode: partnerCodeTextEditingController.text,
        linkingCode: linkingCodeTextEditingController.text,
      );
    }

    useBlocEventListener(smeLinkingBloc, (event) {
      if (event is SmeLinkingSubmissionSuccessEvent) {
        router.replaceWithSmeLinkingSuccessPage();
      }
    });

    useBlocEventListener(barcodeScanBloc, (event) {
      if (event is BarcodeScanSuccessEvent) {
        final content = event.content;
        final qrAction = PartnerInfoQrContent(content);
        final codes = qrAction.decode();

        if (codes.isEmpty) return;

        final scannedPartnerCode =
            codes.getValueByKey(PartnerInfoQrContent.partnerCodeKey);
        final scannedLinkingCode =
            codes.getValueByKey(PartnerInfoQrContent.linkingCodeKey);

        if (scannedPartnerCode == null || scannedLinkingCode == null) return;
        partnerCodeTextEditingController.text = scannedPartnerCode;
        linkingCodeTextEditingController.text = scannedLinkingCode;
      }
    });

    void onScanQrCodeButtonTapped() {
      dismissKeyboard(context);
      isFormSubmissionErrorDismissed.value = false;
      barcodeScanBloc.startScan();
    }

    return GestureDetector(
      onTap: () {
        dismissKeyboard(context);
      },
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Heading(
                      localizedStrings.linkBusinessAccount,
                      icon: SvgAssets.linkBusiness,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: Text(
                        localizedStrings.linkBusinessAccountDescription,
                        style: TextStyles.darkBodyBody1RegularHigh,
                      ),
                    ),
                    _buildScanQRLabel(onScanQrCodeButtonTapped),
                    const SizedBox(height: 32),
                    SmeLinkingForm(
                      formKey: _formKey,
                      partnerCodeController: partnerCodeTextEditingController,
                      partnerCodeContextGlobalKey:
                          _formFullNameContextGlobalKey,
                      linkingCodeContextGlobalKey: _linkingCodeGlobalKey,
                      linkingCodeController: linkingCodeTextEditingController,
                      onSubmitTap: onSubmit,
                    ),
                  ],
                ),
              ),
            ),
            if (smeLinkingBlocState is SmeLinkingSubmissionErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                  error: smeLinkingBlocState.error,
                  canRetry: smeLinkingBlocState.canRetry,
                  onRetryTap: onSubmit,
                  onCloseTap: () {
                    isFormSubmissionErrorDismissed.value = true;
                  }),
            if (barcodeScanState is BarcodeScanPermissionErrorState &&
                !isScanningErrorDismissed.value)
              _buildError(
                error: barcodeScanState.error,
                onRetryTap: onScanQrCodeButtonTapped,
                onCloseTap: () {
                  isScanningErrorDismissed.value = true;
                },
              ),
            if (barcodeScanState is BarcodeScanErrorState &&
                !isScanningErrorDismissed.value)
              _buildError(
                error: barcodeScanState.error,
                onRetryTap: onScanQrCodeButtonTapped,
                onCloseTap: () {
                  isScanningErrorDismissed.value = true;
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildScanQRLabel(VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(SvgAssets.qrCode),
            const SizedBox(width: 8),
            Text(
              useLocalizedStrings().transactionFormScanQRCode,
              style: TextStyles.linksTextLinkBold,
            ),
          ],
        ),
      );

  Widget _buildError({
    LocalizedStringBuilder error,
    bool canRetry = false,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      Align(
          alignment: Alignment.bottomCenter,
          child: GenericErrorWidget(
            valueKey: const Key('smeLinkingPageError'),
            text: error.localize(useContext()),
            onRetryTap: canRetry ? onRetryTap : null,
            onCloseTap: onCloseTap,
          ));
}
