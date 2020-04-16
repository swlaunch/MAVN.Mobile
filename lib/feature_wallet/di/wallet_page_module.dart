import 'package:lykke_mobile_mavn/base/repository/mapper/transaction_history_mapper.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class WalletPageModule extends Module {
  TransactionHistoryBloc get transactionHistoryBloc => get();

  TransactionHistoryMapper get transactionMapper => get();

  @override
  void provideInstances() {
    provideSingleton(() => TransactionHistoryBloc(get()));
    provideSingleton(() => TransactionHistoryMapper());
  }
}
