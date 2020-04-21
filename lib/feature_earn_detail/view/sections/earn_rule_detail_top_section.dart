import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_earn/analytics/earn_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class EarnRuleDetailTopSection extends HookWidget {
  const EarnRuleDetailTopSection({
    @required this.earnRule,
  });

  final EarnRule earnRule;
  static final DateFormat _dateFormatFromDate = DateFormat('dd MMMM');
  static final DateFormat _dateFormatToDate = DateFormat('dd MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final analyticsManager = useEarnAnalyticsManager();

    final router = useRouter();
    final dateTimeManager = useDateTimeManager();

    final earnRuleDetailBloc = useEarnRuleDetailBloc();
    final earnRuleDetailState = useBlocState(earnRuleDetailBloc);

    return Container(
      color: ColorStyles.white,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (earnRule.title != null) Heading(earnRule.title),
          if (earnRule.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                earnRule.description,
                style: TextStyles.darkBodyBody1RegularHigh,
              ),
            ),
          const SizedBox(height: 16),
          if (earnRule.fromDate != null && earnRule.toDate != null)
            _buildDateSection(earnRule, dateTimeManager),
          if (earnRuleDetailState is EarnRuleDetailLoadedState)
            _buildActionButton(
              router,
              earnRuleDetailState.earnRuleDetail,
              analyticsManager,
            ),
        ],
      ),
    );
  }

  Widget _buildDateSection(
    EarnRule earnRule,
    DateTimeManager dateTimeManager,
  ) =>
      Row(
        children: <Widget>[
          const DividerDecoration(
            color: ColorStyles.primaryDark,
            width: 8,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getFormattedDate(earnRule, dateTimeManager),
              style: TextStyles.darkBodyBody4Regular,
            ),
          )
        ],
      );

  Widget _buildActionButton(
    Router router,
    ExtendedEarnRule extendedEarnRule,
    EarnAnalyticsManager analyticsManager,
  ) {
    if (extendedEarnRule.conditions.first.type ==
            EarnRuleConditionType.propertyPurchaseCommissionOne ||
        extendedEarnRule.conditions.first.type ==
            EarnRuleConditionType.propertyPurchaseCommissionTwo ||
        extendedEarnRule.conditions.first.type ==
            EarnRuleConditionType.hotelStay) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: PrimaryButton(
        text: useLocalizedStrings().getStartedButton,
        onTap: _getOnConditionTap(
          router,
          extendedEarnRule,
          analyticsManager,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }

  String _getFormattedDate(EarnRule rule, DateTimeManager dateTimeManager) {
    final fromDate = _dateFormatFromDate
        .format(dateTimeManager.toLocal(DateTime.parse(earnRule.fromDate)));
    final toDate = _dateFormatToDate
        .format(dateTimeManager.toLocal(DateTime.parse(earnRule.toDate)));

    return useLocalizedStrings()
        .earnRuleValidDate(fromDate, toDate)
        .toUpperCase();
  }

  VoidCallback _getOnConditionTap(
      Router router,
      ExtendedEarnRule extendedEarnRule,
      EarnAnalyticsManager analyticsManager) {
    if (earnRule.conditions?.isEmpty ?? true) {
      return null;
    }
    analyticsManager.earnRuleTapped(
      offerId: extendedEarnRule.id,
      conditionType: earnRule.conditions.first.type,
    );
    switch (earnRule.conditions.first.type) {
      case EarnRuleConditionType.estateLeadReferral:
        return () => router.pushLeadReferralPage(extendedEarnRule);
      case EarnRuleConditionType.hotelStayReferral:
        return () => router.pushHotelReferralPage(extendedEarnRule);
      case EarnRuleConditionType.friendReferral:
        return () => router.pushFriendReferralPage(extendedEarnRule);
      default:
        return null;
    }
  }
}
