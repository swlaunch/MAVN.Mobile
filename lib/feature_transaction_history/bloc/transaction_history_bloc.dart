import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class TransactionHistoryBloc
    extends GenericListBloc<TransactionHistoryResponseModel, Transaction> {
  TransactionHistoryBloc(this._customerRepository)
      : super(
            genericErrorSubtitle: LazyLocalizedStrings
                .walletPageTransactionHistoryInitialPageError);

  final CustomerRepository _customerRepository;

  @override
  List<Transaction> getDataFromResponse(
          TransactionHistoryResponseModel response) =>
      response.transactionList;

  @override
  int getTotalCount(TransactionHistoryResponseModel response) =>
      response.totalCount;

  @override
  Future<TransactionHistoryResponseModel> loadData(int page) =>
      _customerRepository.getTransactionHistory(currentPage: page);
}

TransactionHistoryBloc useTransactionHistoryBloc() =>
    ModuleProvider.of<WalletPageModule>(useContext()).transactionHistoryBloc;
