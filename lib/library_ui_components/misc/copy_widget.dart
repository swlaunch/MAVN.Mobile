import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';

class CopyWidget extends StatelessWidget {
  ///[body] the body of the widget
  ///[copyText] the text that will be copied when the user clicks the widget
  ///[toastMessage] the text user will see upon copying
  ///[useOwnAsset] whether or not the widget will display the copy icon
  const CopyWidget({
    @required this.body,
    @required this.copyText,
    this.toastMessage,
    this.useOwnAsset = true,
  });

  final Widget body;
  final String copyText;
  final String toastMessage;
  final bool useOwnAsset;

  @override
  Widget build(BuildContext context) {
    void copyToClipBoard() {
      ClipboardManager.copyToClipBoard(copyText);
      ToastMessage.show(
        toastMessage ?? LocalizedStrings.of(context).copiedToClipboard,
        context,
      );
    }

    return InkWell(
      onTap: copyToClipBoard,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: body),
          if (useOwnAsset) const StandardSizedSvg(SvgAssets.copyPaste)
        ],
      ),
    );
  }
}
