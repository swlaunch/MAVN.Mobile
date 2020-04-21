import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_availability_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/ui_components/earn_offer_unavailable_widget.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/view/sections/earn_rule_detail_top_section.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/view/sections/earn_rule_how_it_works_section.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/view/sections/previous_referrals_section.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/scroll_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/chips/amount_chip.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/disabled_overlay.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class EarnRuleDetailPage extends HookWidget {
  const EarnRuleDetailPage({@required this.earnRule});

  static const double _sliverImageSize = 162;

  final EarnRule earnRule;

  @override
  Widget build(BuildContext context) {
    final earnRuleDetailBloc = useEarnRuleDetailBloc();
    final earnRuleDetailBlocState = useBlocState(earnRuleDetailBloc);

    final earnRuleAvailabilityBloc = useEarnRuleAvailabilityBloc();
    final earnRuleAvailabilityState = useBlocState(earnRuleAvailabilityBloc);

    final earnRuleReferralsBloc = useEarnRuleReferralsBloc();
    final earnRuleReferralsBlocState = useBlocState(earnRuleReferralsBloc);

    final scrollController = useScrollController();

    void loadEarnRuleDetail() {
      earnRuleDetailBloc.loadEarnRule(earnRule.id);
    }

    useEffect(() {
      loadEarnRuleDetail();
    }, [earnRuleDetailBloc]);

    void loadAllData() {
      loadEarnRuleDetail();
      earnRuleReferralsBloc.getEarnRuleReferrals(earnRule.id);
    }

    final isNetworkError = [
      earnRuleDetailBlocState,
      earnRuleReferralsBlocState,
    ].any((state) => state is BaseNetworkErrorState);

    if (isNetworkError) {
      return ScaffoldWithAppBar(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: NetworkErrorWidget(
                onRetry: loadAllData,
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: ColorStyles.offWhite,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _sliverImageSize,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  color: ColorStyles.primaryDark,
                  child: FlexibleSpaceBar(
                    background: NetworkImageWithPlaceholder(
                      imageUrl: earnRule.imageUrl,
                      height:
                          _sliverImageSize + MediaQuery.of(context).padding.top,
                      borderRadiusSize: 0,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 16,
                      color: ColorStyles.white,
                    ),
                    const EarnOfferUnavailableWidget(),
                    Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            EarnRuleDetailTopSection(
                              earnRule: earnRule,
                            ),
                            const SizedBox(height: 16),
                            if (earnRuleDetailBlocState
                                is EarnRuleDetailLoadingState)
                              const Center(
                                child: Spinner(),
                              ),
                            if (earnRuleDetailBlocState
                                is EarnRuleDetailLoadedState)
                              _buildContent(
                                  earnRuleDetailBlocState.earnRuleDetail),
                            if (earnRuleDetailBlocState
                                is EarnRuleDetailErrorState)
                              _buildErrorSection(
                                  earnRuleDetailBlocState, earnRuleDetailBloc)
                          ],
                        ),
                        if (earnRuleAvailabilityState
                            is EarnRuleAvailabilityUnavailableState)
                          const DisabledOverlay(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildAmountChip(context, scrollController)
        ],
      ),
    );
  }

  Widget _buildAmountChip(
      BuildContext context, ScrollController scrollController) {
    //starting widget position
    final defaultTopMargin =
        _sliverImageSize + MediaQuery.of(context).padding.top - 20.0;
    //pixels from top where opacity change should start
    final double opacityChangeStart = defaultTopMargin / 2;
    //pixels from top where opacity change should end
    final double opacityChangeEnd = opacityChangeStart / 2;

    double top = defaultTopMargin;
    double opacity = 1;
    if (scrollController.hasClients) {
      final offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - opacityChangeStart) {
        //offset small => don't decrease opacity
        opacity = 1;
      } else if (offset < defaultTopMargin - opacityChangeEnd) {
        //opacityChangeStart < offset> opacityChangeEnd => decrease opacity
        opacity =
            (defaultTopMargin - opacityChangeEnd - offset) / opacityChangeEnd;
      } else {
        //offset passed opacityChangeEnd => hide widget
        opacity = 0;
      }
    }

    return Positioned(
      top: top,
      left: 24,
      child: Opacity(
        opacity: opacity,
        child: AmountChip(
          amount: earnRule.reward.value,
          showAsterisk: earnRule.isApproximate,
          textStyle: TextStyles.darkHeadersH2,
        ),
      ),
    );
  }

  Widget _buildContent(ExtendedEarnRule extendedEarnRule) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EarnRuleHowItWorksSection(extendedEarnRule),
          const SizedBox(height: 16),
          PreviousReferralsSection(earnRule.id),
          const SizedBox(height: 16),
        ],
      );

  Widget _buildErrorSection(EarnRuleDetailErrorState earnRuleDetailBlocState,
          EarnRuleDetailBloc earnRuleDetailBloc) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GenericErrorIconWidget(
          title: earnRuleDetailBlocState.errorTitle.localize(useContext()),
          text: earnRuleDetailBlocState.errorSubtitle.localize(useContext()),
          icon: earnRuleDetailBlocState.iconAsset,
          errorKey: const Key('earnRuleDetailError'),
          onRetryTap: () => earnRuleDetailBloc.loadEarnRule(earnRule.id),
        ),
      );
}
