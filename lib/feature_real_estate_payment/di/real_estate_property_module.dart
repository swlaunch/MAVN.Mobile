import 'package:lykke_mobile_mavn/feature_property_payment/bloc/spend_rule_conversion_rate_bloc.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/instalment_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/real_estate_property_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class RealEstatePropertyModule extends Module {
  PropertyListBloc get realEstatePropertyListBloc => get();

  InstalmentListBloc get instalmentListBloc => get();

  SpendRuleConversionRateBloc get spendRuleConversionRateBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => PropertyListBloc(get()));
    provideSingleton(() => InstalmentListBloc(get()));
    provideSingleton(() => SpendRuleConversionRateBloc(get(), get()));
  }
}
