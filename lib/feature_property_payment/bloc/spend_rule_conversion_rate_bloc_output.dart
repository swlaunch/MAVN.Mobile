import 'package:decimal/decimal.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class SpendRuleConversionRateState extends BlocState {}

class SpendRuleConversionRateUninitializedState
    extends SpendRuleConversionRateState {}

class SpendRuleConversionRateLoadingState extends SpendRuleConversionRateState {
}

class SpendRuleConversionRateLoadedState extends SpendRuleConversionRateState {
  SpendRuleConversionRateLoadedState({
    @required this.rate,
    @required this.currencyCode,
  });

  final Decimal rate;
  final String currencyCode;

  @override
  List get props => super.props..addAll([rate, currencyCode]);
}

class SpendRuleConversionRateErrorState extends SpendRuleConversionRateState {
  SpendRuleConversionRateErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}
