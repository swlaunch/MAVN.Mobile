import 'package:equatable/equatable.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class HotelPreCheckoutState extends BlocState {}

class HotelPreCheckoutUninitializedState extends HotelPreCheckoutState {}

class HotelPreCheckoutLoadingState extends HotelPreCheckoutState {}

class HotelPreCheckoutErrorState extends HotelPreCheckoutState
    with EquatableMixin {
  HotelPreCheckoutErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class HotelPreCheckoutLoadedState extends HotelPreCheckoutState
    with EquatableMixin {
  HotelPreCheckoutLoadedState({
    @required this.partnerName,
    @required this.message,
  });

  final String partnerName;
  final String message;

  @override
  List get props => super.props..addAll([partnerName, message]);
}
