import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/di/earn_rule_detail_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

export 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc_output.dart';

class EarnRuleReferralsBloc extends Bloc<EarnRuleReferralsState> {
  EarnRuleReferralsBloc(this._referralRepository);

  final ReferralRepository _referralRepository;

  static const int _requestItemsCount = 100;
  static const int _page = 1;

  @override
  EarnRuleReferralsState initialState() =>
      EarnRuleReferralsUninitializedState();

  Future<void> getEarnRuleReferrals(String earnRuleId) async {
    if (currentState is EarnRuleReferralsLoadingState) {
      return;
    }
    try {
      setState(EarnRuleReferralsLoadingState());
      final response = await _referralRepository.getReferralsForEarnRuleId(
        currentPage: _page,
        itemsCount: _requestItemsCount,
        earnRuleId: earnRuleId,
      );

      final referralsList = response.referrals;

      if (response.totalCount == 0 || (referralsList?.isEmpty ?? true)) {
        setState(EarnRuleReferralsEmptyState());
        return;
      }

      final stakingReferrals = ListUtils.sortBy(
        referralsList,
        (item) => item.timeStamp,
        descendingOrder: true,
      );

      setState(
        EarnRuleReferralsLoadedState(
          referralList: stakingReferrals,
          totalCount: response.totalCount,
        ),
      );
    } on Exception catch (e) {
      setState(_getErrorState(e));
    }
  }

  EarnRuleReferralsState _getErrorState(
    Exception e,
  ) {
    if (e is NetworkException) {
      return EarnRuleReferralsNetworkErrorState();
    }
    return EarnRuleReferralsErrorState(
      errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
      errorSubtitle:
          LazyLocalizedStrings.referralListRequestGenericErrorSubtitle,
      iconAsset: SvgAssets.genericError,
    );
  }
}

EarnRuleReferralsBloc useEarnRuleReferralsBloc() =>
    ModuleProvider.of<EarnRuleDetailModule>(useContext()).earnRuleReferralsBloc;
