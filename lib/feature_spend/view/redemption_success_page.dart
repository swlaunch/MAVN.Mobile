import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/copy_row_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';

class RedemptionSuccessPage extends HookWidget {
  const RedemptionSuccessPage({this.voucherCode});

  final String voucherCode;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final externalRouter = useExternalRouter();

    return ScaffoldWithAppBar(
      body: Column(
        children: <Widget>[
          PageTitle(
            title: useLocalizedStrings().redemptionSuccessTitle,
            assetIconTrailing: SvgAssets.success,
            assetIconTrailingAlignedToTitle: true,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: <Widget>[
                  _buildCopyWidget(),
                  const SizedBox(height: 24),
                  _buildClickableText(
                    onTap: () {
                      router
                        ..popToRoot()
                        ..switchToHomeTab()
                        ..pushAccountPage()
                        ..pushVoucherListPage();
                    },
                  ),
                  Expanded(child: Container()),
                  _buildOpenVoucherAppButton(onTap: () {
                    //TODO use external router to open voucher app
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyWidget() => CopyRowWidget(
        title: useLocalizedStrings().redemptionSuccessCopyTitle,
        copyText: voucherCode,
        copyWidgetType: CopyWidgetType.advanced,
        advancedCopyTextStyle: TextStyles.darkBodyBody2Bold,
        toastMessage: useLocalizedStrings().redemptionSuccessToastMessage,
      );

  Widget _buildClickableText({@required VoidCallback onTap}) => RichText(
          text: TextSpan(
        children: [
          TextSpan(
            text: useLocalizedStrings().redemptionSuccessDetailsText,
            style: TextStyles.darkBodyBody3Regular,
          ),
          TextSpan(
            text: useLocalizedStrings().redemptionSuccessDetailsLink,
            style: TextStyles.linksTextLinkSmallBold,
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ));

  Widget _buildOpenVoucherAppButton({@required VoidCallback onTap}) =>
      PrimaryButton(
        text: useLocalizedStrings().redemptionSuccessOpenVoucherAppButton,
        onTap: onTap,
      );
}
