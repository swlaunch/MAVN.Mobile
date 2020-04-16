import 'package:lykke_mobile_mavn/feature_spend/bloc/spend_rule_detail_bloc.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/voucher_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SpendRuleDetailModule extends Module {
  SpendRuleDetailBloc get spendRuleDetailBloc => get();

  VoucherPurchaseBloc get voucherPurchaseBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => SpendRuleDetailBloc(get()));
    provideSingleton(() => VoucherPurchaseBloc(get(), get()));
  }
}
