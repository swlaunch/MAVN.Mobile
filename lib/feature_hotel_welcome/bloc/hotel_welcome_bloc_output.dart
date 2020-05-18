import 'package:equatable/equatable.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

abstract class HotelWelcomeState extends BlocState {}

class HotelWelcomeUninitializedState extends HotelWelcomeState {}

class HotelWelcomeLoadingState extends HotelWelcomeState {}

class HotelWelcomeErrorState extends HotelWelcomeState with EquatableMixin {
  HotelWelcomeErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class HotelWelcomeLoadedState extends HotelWelcomeState with EquatableMixin {
  HotelWelcomeLoadedState({
    @required this.partnerName,
    @required this.heading,
    @required this.message,
  });

  final String partnerName;
  final String heading;
  final String message;

  @override
  List get props => super.props..addAll([partnerName, heading, message]);
}
