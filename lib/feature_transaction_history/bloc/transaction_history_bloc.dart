import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

import 'transaction_history_bloc_output.dart';

export 'transaction_history_bloc_output.dart';

class TransactionHistoryBloc extends Bloc<TransactionHistoryState> {
  TransactionHistoryBloc(this._customerRepository);

  final CustomerRepository _customerRepository;

  static const int pageSize = 30;
  static const int initialPage = 1;

  @override
  TransactionHistoryState initialState() => TransactionHistoryUninitialized();

  /// Load transaction history.
  /// Each function invocation will load the next page.
  /// In case [reset] parameter is true the function will load the first page
  Future<void> loadTransactionHistory({bool reset = false}) async {
    if (reset == true) {
      setState(TransactionHistoryUninitialized());
    }

    if (currentState is TransactionHistoryUninitialized ||
        currentState is TransactionHistoryInitialPageError) {
      await _loadInitialPage();
      return;
    }

    if (currentState is TransactionHistoryLoaded) {
      final currentLoadedState = currentState as TransactionHistoryLoaded;
      await _loadMore(
          currentTransactionHistory:
              currentLoadedState.transactionHistoryResponseModel,
          nextPage: currentLoadedState.currentPage + 1); // load next page
      return;
    }

    if (currentState is TransactionHistoryPaginationError) {
      final currentErrorState =
          currentState as TransactionHistoryPaginationError;
      await _loadMore(
          currentTransactionHistory:
              currentErrorState.transactionHistoryResponseModel,
          nextPage: currentErrorState.currentPage); // retry the previous page
      return;
    }
  }

  Future<void> _loadInitialPage() async {
    setState(TransactionHistoryInitialPageLoading());

    try {
      final transactionHistoryResponseModel = await _customerRepository
          .getTransactionHistory(currentPage: initialPage, pageSize: pageSize);

      if (transactionHistoryResponseModel?.totalCount == 0 ||
          (transactionHistoryResponseModel?.transactionList?.isEmpty ?? true)) {
        setState(TransactionHistoryEmpty());
        return;
      }

      setState(TransactionHistoryLoaded(
        transactionHistoryResponseModel: transactionHistoryResponseModel,
        currentPage: initialPage,
      ));
    } on Exception catch (exception) {
      setState(
        _mapInitialExceptionToErrorState(exception),
      );
    }
  }

  TransactionHistoryInitialPageError _mapInitialExceptionToErrorState(
      Exception exception) {
    if (exception is NetworkException) {
      return TransactionHistoryInitialPageNetworkError();
    }

    return TransactionHistoryInitialPageError(
        error:
            LazyLocalizedStrings.walletPageTransactionHistoryInitialPageError);
  }

  Future<void> _loadMore({
    @required TransactionHistoryResponseModel currentTransactionHistory,
    @required int nextPage,
  }) async {
    if (currentTransactionHistory.totalCount <= (nextPage - 1) * pageSize) {
      return; // Loaded all items
    }

    setState(TransactionHistoryPaginationLoading(
        transactionHistoryResponseModel: currentTransactionHistory));

    try {
      final newPageOfTransactionHistory = await _customerRepository
          .getTransactionHistory(currentPage: nextPage, pageSize: pageSize);

      setState(
        TransactionHistoryLoaded(
          transactionHistoryResponseModel: TransactionHistoryResponseModel(
            transactionList: currentTransactionHistory.transactionList
              ..addAll(newPageOfTransactionHistory.transactionList),
            totalCount: newPageOfTransactionHistory.totalCount,
          ),
          currentPage: nextPage,
        ),
      );
    } on Exception catch (exception) {
      setState(_mapExceptionToErrorState(
          exception, currentTransactionHistory, nextPage));
    }
  }

  TransactionHistoryPaginationError _mapExceptionToErrorState(
      Exception exception,
      TransactionHistoryResponseModel currentTransactionHistory,
      int nextPage) {
    if (exception is NetworkException) {
      return TransactionHistoryPaginationNetworkError(
          error:
              LazyLocalizedStrings.walletPageTransactionHistoryPaginationError,
          transactionHistoryResponseModel: currentTransactionHistory,
          currentPage: nextPage);
    }

    return TransactionHistoryPaginationError(
      error: LazyLocalizedStrings.walletPageTransactionHistoryPaginationError,
      transactionHistoryResponseModel: currentTransactionHistory,
      currentPage: nextPage,
    );
  }
}

TransactionHistoryBloc useTransactionHistoryBloc() =>
    ModuleProvider.of<WalletPageModule>(useContext()).transactionHistoryBloc;
