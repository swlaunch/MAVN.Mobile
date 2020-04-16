import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class PartnerNameState extends BlocState {}

class PartnerNameUninitializedState extends PartnerNameState {}

class PartnerNameLoadedState extends PartnerNameState {
  PartnerNameLoadedState({this.partnerName});

  final String partnerName;

  @override
  List get props => super.props..addAll([partnerName]);
}
