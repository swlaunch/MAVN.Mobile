import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc_output.dart';

class SpendRuleListBloc
    extends GenericListBloc<SpendRuleListResponseModel, SpendRule> {
  SpendRuleListBloc(this._spendRepository)
      : super(genericErrorSubtitle: LazyLocalizedStrings.cannotGetOffersError);

  final SpendRepository _spendRepository;

  @override
  Future<SpendRuleListResponseModel> loadData(int page) =>
      _spendRepository.getSpendRules(currentPage: page);

  @override
  int getCurrentPage(SpendRuleListResponseModel response) =>
      response.currentPage;

  @override
  List<SpendRule> getDataFromResponse(SpendRuleListResponseModel response) =>
      response.spendRuleList;

  @override
  int getTotalCount(SpendRuleListResponseModel response) => response.totalCount;
}

SpendRuleListBloc useSpendRuleListBloc() =>
    ModuleProvider.of<AppModule>(useContext()).spendRuleListBloc;
