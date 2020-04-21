import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/earn/earn_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc_output.dart';

class EarnRuleListBloc
    extends GenericListBloc<EarnRuleListResponseModel, EarnRule> {
  EarnRuleListBloc(this._earnRepository)
      : super(genericErrorSubtitle: LazyLocalizedStrings.cannotGetOffersError);

  final EarnRepository _earnRepository;

  @override
  Future<EarnRuleListResponseModel> loadData(int page) =>
      _earnRepository.getEarnRules(currentPage: page);

  @override
  int getCurrentPage(EarnRuleListResponseModel response) =>
      response.currentPage;

  @override
  List<EarnRule> getDataFromResponse(EarnRuleListResponseModel response) =>
      response.earnRuleList;

  @override
  int getTotalCount(EarnRuleListResponseModel response) => response.totalCount;
}

EarnRuleListBloc useEarnRuleListBloc() =>
    ModuleProvider.of<AppModule>(useContext()).earnRuleListBloc;
