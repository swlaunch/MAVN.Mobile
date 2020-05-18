import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_home/ui_elements/countdown_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/pagination_error_state.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class PreviousReferralsSection extends HookWidget {
  const PreviousReferralsSection(this.earnRuleId);

  final String earnRuleId;

  @override
  Widget build(BuildContext context) {
    final earnRuleReferralsBloc = useEarnRuleReferralsBloc();
    final earnRuleReferralsBlocState = useBlocState(earnRuleReferralsBloc);

    void fetchReferrals() {
      earnRuleReferralsBloc.getEarnRuleReferrals(earnRuleId);
    }

    useEffect(() {
      fetchReferrals();
    }, [earnRuleReferralsBloc]);
    if (earnRuleReferralsBlocState is EarnRuleReferralsLoadingState) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Center(child: Spinner()),
      );
    }
    if (earnRuleReferralsBlocState is EarnRuleReferralsLoadedState) {
      return CountDownWidget(
        referrals: earnRuleReferralsBlocState.referralList,
        totalCount: earnRuleReferralsBlocState.totalCount,
      );
    }
    if (earnRuleReferralsBlocState is EarnRuleReferralsErrorState) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: ColorStyles.white,
        child: PaginationErrorWidget(
          errorText:
              earnRuleReferralsBlocState.errorSubtitle.localize(useContext()),
          onRetry: fetchReferrals,
        ),
      );
    }
    return Container();
  }
}
