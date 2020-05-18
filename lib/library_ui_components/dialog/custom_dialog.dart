import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class CustomDialog extends HookWidget {
  const CustomDialog({
    @required this.title,
    @required this.content,
    @required this.positiveButtonText,
    @required this.negativeButtonText,
    this.titleIcon,
  });

  final String title;
  final String content;
  final String positiveButtonText;
  final String negativeButtonText;
  final Widget titleIcon;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final isLoading = useState<bool>(false);

    return Container(
      width: 312,
      decoration: const BoxDecoration(color: ColorStyles.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: [
                  if (titleIcon != null) ...[
                    titleIcon,
                    const SizedBox(width: 12)
                  ],
                  Expanded(
                    child: Text(title, style: TextStyles.darkHeadersH3),
                  ),
                ]),
                const SizedBox(height: 8),
                if (isLoading.value)
                  const Center(child: Spinner())
                else
                  Text(content, style: TextStyles.darkBodyBody2RegularHigh),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (negativeButtonText != null)
                  _buildButton(
                    key: const Key('customDialogNegativeButton'),
                    label: negativeButtonText,
                    onTap: isLoading.value
                        ? null
                        : () => onNegativeButtonTap(context, router, isLoading),
                  ),
                if (positiveButtonText != null)
                  _buildButton(
                      key: const Key('customDialogPositiveButton'),
                      label: positiveButtonText,
                      onTap: isLoading.value
                          ? null
                          : () =>
                              onPositiveButtonTap(context, router, isLoading)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onNegativeButtonTap(
      BuildContext context, Router router, ValueNotifier<bool> isLoading) {
    //Due to the specifics/limitations around HookWidget, the SOLID principles need to be violated
    router.popDialog(false);
  }

  void onPositiveButtonTap(
      BuildContext context, Router router, ValueNotifier<bool> isLoading) {
    //Due to the specifics/limitations around HookWidget, the SOLID principles need to be violated
    router.popDialog(true);
  }

  Widget _buildButton({
    Key key,
    String label,
    VoidCallback onTap,
  }) =>
      FlatButton(
        key: key,
        padding: const EdgeInsets.all(0),
        child: Text(
          label.toUpperCase(),
          style: TextStyles.linksTextLinkBold.copyWith(fontSize: 14),
        ),
        onPressed: onTap,
      );
}
