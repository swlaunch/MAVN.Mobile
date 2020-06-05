import 'dart:async';
import 'dart:io';

import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wellet_status_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_websocket_wamp_client/websocket_wamp_client.dart';
import 'package:rxdart/rxdart.dart';

import 'balance_repository_output.dart';

export 'balance_repository_output.dart';

class WalletRealTimeRepository {
  WalletRealTimeRepository(this._wampClient);

  static const String walletBalanceTopic = 'balance';
  static const String walletStatusTopic = 'wallet-status';
  static const String walletInitMethod = 'init';

  final WampClient _wampClient;

  final BehaviorSubject<WalletEvent> _walletUpdatesController =
      BehaviorSubject(sync: false);

  StreamSubscription _walletBalanceSubscription;
  StreamSubscription _walletStatusSubscription;

  Future<Stream<WalletEvent>> getWalletUpdatesStream() async =>
      _walletUpdatesController.stream;

  void dispose() {
    disconnect();
    _walletUpdatesController?.close();
  }

  void disconnect() {
    _wampClient.disconnect();
    cancelSubscriptions();
  }

  Future<void> reconnect() async {
    disconnect();
    await _wampClient.connect();
  }

  void init({String token}) {
    _walletUpdatesController.value = null;
    _wampClient
      ..init(
        ticketAuth: TicketAuth(authId: token),
        onConnect: (wampClient) async {
          final walletBalanceTopicStream =
              await wampClient.subscribe(walletBalanceTopic);
          final walletStatusTopicStream =
              await wampClient.subscribe(walletStatusTopic);

          await cancelSubscriptions();

          _walletBalanceSubscription = walletBalanceTopicStream.listen((data) {
            _walletUpdatesController.add(
              WalletBalanceEvent(
                WalletResponseModel.fromJson(data.args.args[0]),
              ),
            );
          });

          _walletStatusSubscription = walletStatusTopicStream.listen((data) {
            _walletUpdatesController.add(
              WalletStatusEvent(
                WalletStatusResponseModel.fromJson(data.args.args[0]),
              ),
            );
          });

          await wampClient.call(walletInitMethod, [
            walletBalanceTopic,
            token,
          ]);

          await wampClient.call(walletInitMethod, [
            walletStatusTopic,
            token,
          ]);
        },
        onDisconnect: (wampClient) {
          cancelSubscriptions();
          _walletUpdatesController.addError(null);
        },
        onError: (e, wampClient) {
          cancelSubscriptions();
          if (e is SocketException) {
            _walletUpdatesController.addError(NetworkException());
          } else {
            _walletUpdatesController.addError(e);
          }
        },
      )
      ..connect();
  }

  Future<void> cancelSubscriptions() async {
    await _walletBalanceSubscription?.cancel();
    await _walletStatusSubscription?.cancel();
  }
}
