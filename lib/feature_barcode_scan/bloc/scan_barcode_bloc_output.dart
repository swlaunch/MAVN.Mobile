import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class BarcodeScanState extends BlocState {}

class BarcodeScanUninitializedState extends BarcodeScanState {}

class BarcodeScanSuccessEvent extends BlocEvent {
  BarcodeScanSuccessEvent(this.content);

  final String content;

  @override
  List get props => super.props..addAll([content]);
}

class BarcodeScanPermissionErrorState extends BarcodeScanState {
  BarcodeScanPermissionErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}

class BarcodeScanErrorState extends BarcodeScanState {
  BarcodeScanErrorState(this.error);

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..addAll([error]);
}
