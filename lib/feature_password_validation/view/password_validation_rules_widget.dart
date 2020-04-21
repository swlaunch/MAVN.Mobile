import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/bloc/password_validation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_password_validation/util/password_validation_rules.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class PasswordValidationRulesWidget extends HookWidget {
  const PasswordValidationRulesWidget();

  @override
  Widget build(BuildContext context) {
    final passwordValidationBloc = usePasswordValidationBloc();
    final passwordValidationBlocState =
        useBlocState<PasswordValidationState>(passwordValidationBloc);

    return Column(
      children: <Widget>[
        Text(
          useLocalizedStrings().passwordGuide,
          style: TextStyles.darkBodyBody4Regular,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        if (passwordValidationBlocState is PasswordValidationLoadedState)
          _buildRulesList(
              rules: passwordValidationBlocState.passwordValidationList),
        if (passwordValidationBlocState is PasswordValidationLoadingState)
          const Center(child: Spinner())
      ],
    );
  }

  Widget _buildRulesList({List<PasswordValidationRule> rules}) =>
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) =>
            PasswordValidationRuleView(validationRule: rules[position]),
        separatorBuilder: (context, position) => const SizedBox(height: 8),
        itemCount: rules.length,
      );
}

class PasswordValidationRuleView extends StatelessWidget {
  const PasswordValidationRuleView({this.validationRule});

  final PasswordValidationRule validationRule;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: validationRule.validate()
                  ? ColorStyles.primaryBlue
                  : ColorStyles.paleLilac,
            ),
          ),
          const SizedBox(width: 8),
          Text(validationRule.getDescription().localize(context),
              style: TextStyles.darkBodyBody4Regular)
        ],
      );
}
