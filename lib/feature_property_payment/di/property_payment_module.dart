import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_amount_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/property_payment_bloc.dart';
import 'package:lykke_mobile_mavn/feature_property_payment/bloc/spend_rule_conversion_rate_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PropertyPaymentModule extends Module {
  PropertyPaymentBloc get propertyPaymentBloc => get();

  PropertyPaymentAmountBloc get propertyPaymentAmountBloc => get();

  SpendRuleConversionRateBloc get spendRuleConversionRateBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => PropertyPaymentBloc(get(), get()));
    provideSingleton(() => PropertyPaymentAmountBloc());
    provideSingleton(() => SpendRuleConversionRateBloc(get(), get()));
  }
}
