import 'package:decimal/decimal.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class PartnerConversionRateState extends BlocState {}

class PartnerConversionRateUninitializedState
    extends PartnerConversionRateState {}

class PartnerConversionRateLoadingState extends PartnerConversionRateState {}

class PartnerConversionRateLoadedState extends PartnerConversionRateState {
  PartnerConversionRateLoadedState({
    @required this.rate,
    @required this.currencyCode,
  });

  final Decimal rate;
  final String currencyCode;

  @override
  List get props => super.props..addAll([rate, currencyCode]);
}

class PartnerConversionRateErrorState extends PartnerConversionRateState {
  PartnerConversionRateErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}
