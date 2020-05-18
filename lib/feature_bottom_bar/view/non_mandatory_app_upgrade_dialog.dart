import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog.dart';

class NonMandatoryAppUpgradeDialog extends StatelessWidget {
  const NonMandatoryAppUpgradeDialog();

  @override
  Widget build(BuildContext context) => CustomDialog(
        title: LocalizedStrings.nonMandatoryAppUpgradeDialogTitle,
        content: LocalizedStrings.nonMandatoryAppUpgradeDialogContent,
        positiveButtonText:
            LocalizedStrings.nonMandatoryAppUpgradeDialogPositiveButton,
        negativeButtonText:
            LocalizedStrings.nonMandatoryAppUpgradeDialogNegativeButton,
        titleIcon: SvgPicture.asset(SvgAssets.appUpdate),
      );
}
