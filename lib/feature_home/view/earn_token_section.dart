import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/section_widget.dart';
import 'package:lykke_mobile_mavn/library_formatting/number_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/carousel/carousel.dart';
import 'package:lykke_mobile_mavn/library_ui_components/carousel/offer_carousel_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class EarnTokenSection extends HookWidget {
  const EarnTokenSection({
    @required this.theme,
    @required this.router,
    @required this.earnRuleListState,
    @required this.onRetryTap,
    this.handleOwnLoading = true,
  });

  final BaseAppTheme theme;
  final Router router;
  final GenericListState earnRuleListState;
  final VoidCallback onRetryTap;
  final bool handleOwnLoading;

  static const maxEarnRuleCarouselItems = 5;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    return SectionWidget(
      theme: theme,
      title: useLocalizedStrings().monthlyChallenges,
      subtitle: useLocalizedStrings().monthlyChallengesSubtitle,
      circularWidget: Container(
        color: theme.iconBackground,
        padding: const EdgeInsets.all(6),
        child: SvgPicture.asset(
          SvgAssets.rocket,
          color: theme.icon,
        ),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (earnRuleListState is GenericListLoadingState &&
                handleOwnLoading)
              const Center(child: Spinner()),
            if (earnRuleListState is GenericListErrorState)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GenericErrorWidget(
                  onRetryTap: onRetryTap,
                  text: (earnRuleListState as GenericListErrorState)
                      .error
                      .localize(useContext()),
                ),
              ),
            if (earnRuleListState is GenericListLoadedState)
              _buildCarousel(
                (earnRuleListState as GenericListLoadedState).list,
                tokenSymbol.value,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(List<EarnRule> earnRuleList, String tokenSymbol) {
    final earnRuleWidgetList = earnRuleList
        .where((rule) =>
            rule.conditions.isNotEmpty &&
            rule.conditions.first.type != EarnRuleConditionType.signUp)
        .take(maxEarnRuleCarouselItems)
        .map(
          (earnRule) => OfferCarouselItem(
            title: earnRule.title,
            subtitle:
                // ignore: lines_longer_than_80_chars
                '$tokenSymbol ${NumberFormatter.trimDecimalZeros(earnRule.reward.value)}',
            imageUrl: earnRule.imageUrl,
            onTap: () => router.pushEarnRuleDetailsPage(earnRule),
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Carousel(
        children: earnRuleWidgetList,
        startPadding: 24,
      ),
    );
  }
}
