import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_barcode_scan/actions/qr_content.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class BarcodeScanState extends BlocState {}

class BarcodeScanUninitializedState extends BarcodeScanState {}

class BarcodeScanSuccessEvent extends BlocEvent {
  BarcodeScanSuccessEvent(this.qrAction);

  final QrContent qrAction;

  @override
  List get props => super.props..addAll([qrAction]);
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
