import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_form/field_validation_manager.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/custom_checkbox.dart';

class TermsOfUseWidget extends StatelessWidget {
  const TermsOfUseWidget({
    this.router,
    this.termsOfUseValueNotifier,
    this.termsAndConditionFieldValidationManager,
    this.showTermsOfUseError,
  });

  final Router router;
  final ValueNotifier<bool> termsOfUseValueNotifier;
  final FieldValidationManager termsAndConditionFieldValidationManager;
  final ValueNotifier<bool> showTermsOfUseError;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomCheckbox(
            valueKey: const Key('termsOfUseCheckbox'),
            showError: showTermsOfUseError.value,
            fieldValidationManager: termsAndConditionFieldValidationManager,
            isCheckedValueNotifier: termsOfUseValueNotifier,
            onChanged: (isChecked) {
              if (isChecked && showTermsOfUseError.value) {
                showTermsOfUseError.value = false;
              }
            },
          ),
          Flexible(
            child: Text.rich(
              TextSpan(
                style: TextStyles.darkBodyBody3Regular,
                children: <InlineSpan>[
                  TextSpan(
                    text: LocalizedStrings.of(context)
                        .registerPageAgreeTermsOfUse,
                  ),
                  WidgetSpan(
                    child: InkWell(
                      onTap: router.pushTermsOfUsePage,
                      child: Text(
                        LocalizedStrings.of(context).termsOfUse,
                        style: TextStyles.darkBodyBody3Regular.copyWith(
                          color: ColorStyles.link,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: LocalizedStrings.of(context).and,
                  ),
                  WidgetSpan(
                    child: InkWell(
                      onTap: router.pushPrivacyPolicyPage,
                      child: Text(
                        LocalizedStrings.of(context).privacyPolicy,
                        style: TextStyles.darkBodyBody3Regular.copyWith(
                          color: ColorStyles.link,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
}
