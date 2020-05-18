import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:meta/meta.dart';

abstract class InstalmentListState extends BaseState {}

class InstalmentListUninitializedState extends InstalmentListState {}

class InstalmentListLoadingState extends InstalmentListState
    with BaseLoadingState {}

class InstalmentListLoadedState extends InstalmentListState {
  InstalmentListLoadedState({@required this.extendedInstalments});

  final List<ExtendedInstalmentModel> extendedInstalments;

  @override
  List get props => super.props..addAll([extendedInstalments]);
}
