import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/offer_unavailable_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/token_amount_with_icon.dart';

class EarnOfferUnavailableWidget extends HookWidget {
  const EarnOfferUnavailableWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final balanceBloc = useBalanceBloc();
    final balanceState = useBlocState(balanceBloc);

    final earnRuleDetailBloc = useEarnRuleDetailBloc();
    final earnRuleDetailBlocState = useBlocState(earnRuleDetailBloc);

    final earnRuleAvailabilityBloc = useEarnRuleAvailabilityBloc();
    final earnRuleAvailabilityState = useBlocState(earnRuleAvailabilityBloc);

    useEffect(() {
      earnRuleAvailabilityBloc.checkAvailability(
          earnRuleDetailBlocState, balanceState);
    }, [balanceState, earnRuleDetailBlocState]);

    return Column(children: <Widget>[
      if (earnRuleAvailabilityState is EarnRuleAvailabilityWalletDisabledState)
        WalletDisabledWidget(router: router).build(context),
      if (earnRuleAvailabilityState is EarnRuleAvailabilityNotEnoughTokensState)
        _NotEnoughTokensWidget(
                stakingAmount: earnRuleAvailabilityState.stakingAmount,
                router: router)
            .build(context),
      if (earnRuleAvailabilityState
          is EarnRuleAvailabilityExceededParticipationLimitState)
        _ParticipationLimitExceededWidget(router: router).build(context),
    ]);
  }
}

class _NotEnoughTokensWidget extends BaseOfferUnavailableWidget {
  _NotEnoughTokensWidget({
    this.stakingAmount,
    this.router,
  }) : super(
            title: LazyLocalizedStrings.earnRuleDetailsOfferUnavailableTitle,
            buttonText: LazyLocalizedStrings.earnRuleViewOtherOffers,
            onButtonTap: () {
              router
                ..pop()
                ..switchToOffersTab();
            },
            bodyBuilder: (context) => RichText(
                  text: TextSpan(
                    style: TextStyles.darkBodyBody1RegularHigh,
                    children: [
                      TextSpan(
                          text: LocalizedStrings.of(context)
                              .earnRuleDetailsLowBalanceErrorPart1),
                      WidgetSpan(
                          child: TokenAmountWithIcon(stakingAmount.value)),
                      TextSpan(
                          text: LocalizedStrings.of(context)
                              .earnRuleDetailsLowBalanceErrorPart2),
                    ],
                  ),
                ));

  final TokenCurrency stakingAmount;
  final Router router;
}

class _ParticipationLimitExceededWidget extends BaseOfferUnavailableWidget {
  _ParticipationLimitExceededWidget({this.router})
      : super(
          title: LazyLocalizedStrings.earnRuleDetailsOfferUnavailableTitle,
          buttonText: LazyLocalizedStrings.earnRuleViewOtherOffers,
          onButtonTap: () {
            router
              ..pop()
              ..switchToOffersTab();
          },
          bodyBuilder: (context) => Text(
            LocalizedStrings.of(context).earnRuleDetailsParticipationLimitError,
            style: TextStyles.darkBodyBody1RegularHigh,
          ),
        );

  final Router router;
}
