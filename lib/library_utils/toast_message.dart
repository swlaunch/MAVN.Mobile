import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class ToastMessage {
  static void show(
    String message,
    BuildContext context, {
    StyledToastPosition position = StyledToastPosition.bottom,
  }) =>
      showToast(
        message,
        context: context,
        backgroundColor: ColorStyles.charcoalGrey,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        textPadding: const EdgeInsets.all(24),
        toastHorizontalMargin: 16,
        textStyle: TextStyles.lightInputTextRegular,
        textAlign: TextAlign.start,
        position: position,
      );
}
