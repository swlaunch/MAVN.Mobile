import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';

class EnableBiometricsDialog extends CustomDialog {
  EnableBiometricsDialog(LocalizedStrings localizedStrings)
      : super(
          title: Platform.isIOS
              ? localizedStrings.biometricAuthenticationDialogTitleIOS
              : localizedStrings.biometricAuthenticationDialogTitleAndroid,
          content: localizedStrings.biometricsGoToSettingsDescription,
          positiveButtonText: localizedStrings.warningDialogGoToSettings,
          negativeButtonText: localizedStrings.warningDialogNoButton,
        );

  @override
  Future<void> onPositiveButtonTap(BuildContext context, Router router,
      ValueNotifier<bool> isLoading) async {
    await AppSettings.openAppSettings();
  }
}
