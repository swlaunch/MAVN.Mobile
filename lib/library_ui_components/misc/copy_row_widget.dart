import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';

class CopyRowWidget extends StatelessWidget {
  const CopyRowWidget({
    @required this.title,
    @required this.copyText,
    this.isLoading = false,
    this.styledToastPosition =
        const StyledToastPosition(align: Alignment.bottomCenter, offset: 90),
    this.copyWidgetType = CopyWidgetType.advanced,
    this.toastMessage,
    this.advancedCopyTextStyle = TextStyles.linksTextLinkSmallBold,
    Key key,
  }) : super(key: key);

  final String title;
  final String copyText;
  final bool isLoading;
  final StyledToastPosition styledToastPosition;
  final CopyWidgetType copyWidgetType;
  final String toastMessage;
  final TextStyle advancedCopyTextStyle;

  @override
  Widget build(BuildContext context) {
    void copyCodeToClipBoard() {
      ClipboardManager.copyToClipBoard(copyText);
      ToastMessage.show(
        toastMessage ?? LocalizedStrings.of(context).copiedToClipboard,
        context,
        position: styledToastPosition,
      );
    }

    return InkWell(
        onTap: () => copyCodeToClipBoard(),
        child: Column(
          children: <Widget>[
            if (copyWidgetType == CopyWidgetType.simple) _buildSimpleCopyRow(),
            if (copyWidgetType == CopyWidgetType.advanced)
              _buildAdvancedCopyRow(),
          ],
        ));
  }

  Widget _buildSimpleCopyRow() => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          SvgPicture.asset(SvgAssets.copyPaste),
          const SizedBox(width: 12),
          if (isLoading) const Center(child: Spinner()),
          if (!isLoading)
            Text(
              title,
              style: TextStyles.linksTextLinkBoldHigh,
            ),
        ],
      );

  Widget _buildAdvancedCopyRow() => Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyles.darkBodyBody3Regular,
                ),
                const SizedBox(height: 8),
                if (isLoading) const Center(child: Spinner()),
                if (!isLoading)
                  Text(
                    copyText,
                    style: advancedCopyTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          SvgPicture.asset(SvgAssets.copyPaste)
        ],
      );
}

enum CopyWidgetType { simple, advanced }
