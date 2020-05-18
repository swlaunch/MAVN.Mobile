import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/earn/earn_repository.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/bloc/earn_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_earn_detail/di/earn_rule_detail_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class EarnRuleDetailBloc extends Bloc<EarnRuleDetailState> {
  EarnRuleDetailBloc(this._earnRepository);

  final EarnRepository _earnRepository;

  @override
  EarnRuleDetailState initialState() => EarnRuleDetailUninitializedState();

  Future<void> loadEarnRule(String earnRuleId) async {
    setState(EarnRuleDetailLoadingState());

    try {
      final response =
          await _earnRepository.getExtendedEarnRule(earnRuleId: earnRuleId);

      setState(EarnRuleDetailLoadedState(earnRuleDetail: response));
    } on Exception catch (exception) {
      setState(_mapErrorState(exception));
    }
  }

  EarnRuleDetailErrorState _mapErrorState(Exception e) {
    if (e is NetworkException) {
      return EarnRuleDetailErrorState(
        errorTitle: LazyLocalizedStrings.networkErrorTitle,
        errorSubtitle: LazyLocalizedStrings.networkError,
        iconAsset: SvgAssets.networkError,
      );
    }

    return EarnRuleDetailErrorState(
      errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
      errorSubtitle: LazyLocalizedStrings.earnDetailPageGenericErrorSubTitle,
      iconAsset: SvgAssets.genericError,
    );
  }
}

EarnRuleDetailBloc useEarnRuleDetailBloc() =>
    ModuleProvider.of<EarnRuleDetailModule>(useContext()).earnRuleDetailBloc;
