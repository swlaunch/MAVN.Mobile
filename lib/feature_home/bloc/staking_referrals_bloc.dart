import 'package:decimal/decimal.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/feature_home/bloc/staking_referrals_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_home/di/staking_referrals_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

export 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc_output.dart';

class StakingReferralsBloc extends Bloc<StakingReferralsState> {
  StakingReferralsBloc(this._referralRepository);

  final ReferralRepository _referralRepository;

  static const int _requestItemsCount = 100;
  static const int _page = 1;

  @override
  StakingReferralsState initialState() => StakingReferralsUninitializedState();

  Future<void> getStakingReferrals() async {
    if (currentState is StakingReferralsLoadingState) {
      return;
    }
    try {
      setState(StakingReferralsLoadingState());
      final response = await _referralRepository.getPendingReferrals(
        currentPage: _page,
        itemsCount: _requestItemsCount,
      );

      final referralsList = (response?.referrals ?? [])
          .where((referral) => referral.hasStaking)
          .toList();

      if (referralsList.isEmpty) {
        setState(StakingReferralsEmptyState());
        return;
      }

      final stakingReferrals = ListUtils.sortBy(
        referralsList,
        (item) => item.timeStamp,
        descendingOrder: true,
      );

      setState(
        StakingReferralsLoadedState(
          referralList: stakingReferrals,
          totalCount: response.totalCount,
          amountTokensWaiting: TokenCurrency(
            value: _getRewardsSum(stakingReferrals).toString(),
          ),
        ),
      );
    } on Exception catch (e) {
      setState(_getErrorState(e));
    }
  }

  Decimal _getRewardsSum(List<CustomerCommonReferralResponseModel> referrals) =>
      referrals
          .map((ref) => ref.totalReward.decimalValue)
          .reduce((prev, current) => prev + current);

  StakingReferralsState _getErrorState(
    Exception e,
  ) {
    if (e is NetworkException) {
      return StakingReferralsNetworkErrorState();
    }
    return StakingReferralsErrorState(
      errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
      errorSubtitle:
          LazyLocalizedStrings.referralListRequestGenericErrorSubtitle,
      iconAsset: SvgAssets.genericError,
    );
  }
}

StakingReferralsBloc useStakingReferralsBloc() =>
    ModuleProvider.of<StakingReferralsModule>(useContext())
        .stakingReferralsBloc;
