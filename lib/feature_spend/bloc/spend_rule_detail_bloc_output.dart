import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class SpendRuleDetailState extends BlocState {}

class SpendRuleDetailUninitializedState extends SpendRuleDetailState {}

class SpendRuleDetailLoadingState extends SpendRuleDetailState {}

class SpendRuleDetailLoadedState extends SpendRuleDetailState {
  SpendRuleDetailLoadedState({@required this.spendRule});

  final SpendRule spendRule;
}

class SpendRuleDetailNetworkErrorState extends SpendRuleDetailState {}

class SpendRuleDetailGenericErrorState extends SpendRuleDetailState {}
