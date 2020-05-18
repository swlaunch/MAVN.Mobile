import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';

class GenericErrorWidget extends StatelessWidget {
  const GenericErrorWidget({
    @required this.onRetryTap,
    this.text,
    this.onCloseTap,
    this.valueKey,
    this.margin = const EdgeInsets.all(16),
  });

  final String text;
  final VoidCallback onRetryTap;
  final VoidCallback onCloseTap;
  final ValueKey valueKey;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final genericError = useExceptionToMessageMapper(context).map(Exception());

    return IntrinsicHeight(
      child: Container(
        key: valueKey,
        margin: margin,
        padding: EdgeInsets.fromLTRB(onCloseTap != null ? 0 : 16, 16, 16, 16),
        decoration: BoxDecoration(
            color: ColorStyles.charcoalGrey,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            if (onCloseTap != null)
              IconButton(
                icon: const Icon(Icons.close),
                color: ColorStyles.white,
                padding: EdgeInsets.zero,
                onPressed: onCloseTap,
              ),
            Expanded(
              child: Text(text ?? genericError,
                  key: const Key('errorWidgetDetails'),
                  style: TextStyles.lightBody4Bold),
            ),
            const SizedBox(width: 12),
            if (onRetryTap != null)
              RaisedButton(
                key: const Key('genericErrorWidgetRetryButton'),
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  LocalizedStrings.of(context).retryButton.toUpperCase(),
                  style: TextStyles.linksTextLinkBold.copyWith(fontSize: 14),
                ),
                onPressed: onRetryTap,
              )
          ],
        ),
      ),
    );
  }
}
