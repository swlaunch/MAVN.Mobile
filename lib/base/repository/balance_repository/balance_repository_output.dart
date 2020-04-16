import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wellet_status_response_model.dart';

abstract class WalletEvent {}

class WalletBalanceEvent extends WalletEvent {
  WalletBalanceEvent(this.data);

  final WalletResponseModel data;
}

class WalletStatusEvent extends WalletEvent {
  WalletStatusEvent(this.data);

  final WalletStatusResponseModel data;
}
