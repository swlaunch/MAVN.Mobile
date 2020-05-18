import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/spend_rule_detail_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_spend/di/spend_rule_detail_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SpendRuleDetailBloc extends Bloc<SpendRuleDetailState> {
  SpendRuleDetailBloc(this._spendRepository);

  final SpendRepository _spendRepository;

  @override
  SpendRuleDetailState initialState() => SpendRuleDetailUninitializedState();

  Future<void> loadSpendRule(String spendRuleId) async {
    setState(SpendRuleDetailLoadingState());

    try {
      final response =
          await _spendRepository.getSpendRuleDetail(spendRuleId: spendRuleId);

      setState(SpendRuleDetailLoadedState(spendRule: response));
    } on Exception catch (exception) {
      if (exception is NetworkException) {
        setState(SpendRuleDetailNetworkErrorState());
        return;
      }

      setState(SpendRuleDetailGenericErrorState());
    }
  }
}

SpendRuleDetailBloc useSpendRuleDetailBloc() =>
    ModuleProvider.of<SpendRuleDetailModule>(useContext()).spendRuleDetailBloc;
