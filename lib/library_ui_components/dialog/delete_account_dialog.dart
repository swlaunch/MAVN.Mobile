import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/delete_account_use_case.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';
import 'package:lykke_mobile_mavn/library_utils/toast_message.dart';

class DeleteAccountDialog extends CustomDialog {
  DeleteAccountDialog(LocalizedStrings localizedStrings)
      : super(
          titleIcon: SvgPicture.asset(SvgAssets.genericError,
              color: ColorStyles.errorRed),
          title: localizedStrings.deleteAccountDialogTitle,
          content: localizedStrings.deleteAccountDialogDetails,
          positiveButtonText: localizedStrings.deleteAccountDialogDeleteButton,
          negativeButtonText: localizedStrings.deleteAccountDialogCancelButton,
        );

  @override
  Future<void> onPositiveButtonTap(BuildContext context, Router router,
      ValueNotifier<bool> isLoading) async {
    isLoading.value = true;

    try {
      await useDeleteAccountUseCase(context: context).execute();
      await useLogOutUseCase(context: context).execute(serverLogout: false);
      await router.navigateToLandingPage();
    } on CustomException catch (exception) {
      ToastMessage.show(exception.message.localize(context), context);
    } finally {
      isLoading.value = false;
    }
  }
}
