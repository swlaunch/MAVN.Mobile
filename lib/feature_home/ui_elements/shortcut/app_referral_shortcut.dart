import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/shortcut/home_shortcut_item.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class AppReferralShortcutWidget extends HookWidget {
  const AppReferralShortcutWidget({@required this.earnRuleListState});

  final GenericListState earnRuleListState;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final themeBloc = useThemeBloc();
    final themeBlocState = useBlocState(themeBloc);

    if (themeBlocState is ThemeSelectedState &&
        earnRuleListState is GenericListLoadedState) {
      final theme = themeBlocState.theme;

      ///check if there is an app referral item in earn rule list
      final appReferralRule = (earnRuleListState as GenericListLoadedState)
          .list
          .firstWhere(
              (element) =>
                  element?.conditions?.firstWhere(
                      (condition) =>
                          condition?.type ==
                          EarnRuleConditionType.friendReferral,
                      orElse: () => null) !=
                  null,
              orElse: () => null);

      ///if there is no friend referral rule, do not show shortcut
      if (appReferralRule == null) {
        return Container();
      }
      return HomeShortcutItemWidget(
        backgroundColor: theme.homeAppReferralBackground,
        text: useLocalizedStrings().leadReferralPageTitle,
        onTap: () => router.pushEarnRuleDetailsPage(appReferralRule),
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(SvgAssets.appReferral)),
      );
    }

    return Container();
  }
}
