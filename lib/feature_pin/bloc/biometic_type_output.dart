import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';

abstract class BiometricTypeState extends BaseState {}

class BiometricTypeUninitializedState extends BiometricTypeState {}

class BiometricTypeLoadedState extends BiometricTypeState {
  BiometricTypeLoadedState({
    this.assetName,
    this.label,
  });

  final String assetName;
  final String label;

  @override
  List get props => [label, assetName];
}
