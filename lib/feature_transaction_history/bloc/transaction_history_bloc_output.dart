import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';

abstract class TransactionHistoryState extends BaseState {}

class TransactionHistoryUninitialized extends TransactionHistoryState {}

class TransactionHistoryInitialPageLoading extends TransactionHistoryState {}

class TransactionHistoryLoaded extends TransactionHistoryState {
  TransactionHistoryLoaded({
    @required this.transactionHistoryResponseModel,
    @required this.currentPage,
  });

  final TransactionHistoryResponseModel transactionHistoryResponseModel;
  final int currentPage;

  @override
  List get props =>
      super.props..addAll([transactionHistoryResponseModel, currentPage]);
}

class TransactionHistoryEmpty extends TransactionHistoryState {}

class TransactionHistoryInitialPageError extends TransactionHistoryState {
  TransactionHistoryInitialPageError({@required this.error});

  final LocalizedStringBuilder error;

  @override
  List get props => super.props..add(error);
}

class TransactionHistoryInitialPageNetworkError
    extends TransactionHistoryInitialPageError with BaseNetworkErrorState {
  TransactionHistoryInitialPageNetworkError();
}

class TransactionHistoryPaginationLoading extends TransactionHistoryState {
  TransactionHistoryPaginationLoading({
    @required this.transactionHistoryResponseModel,
  });

  final TransactionHistoryResponseModel transactionHistoryResponseModel;

  @override
  List get props => super.props..add(transactionHistoryResponseModel);
}

class TransactionHistoryPaginationError extends TransactionHistoryState {
  TransactionHistoryPaginationError({
    @required this.error,
    @required this.transactionHistoryResponseModel,
    @required this.currentPage,
  });

  final LocalizedStringBuilder error;
  final TransactionHistoryResponseModel transactionHistoryResponseModel;
  final int currentPage;

  @override
  List get props => super.props
    ..addAll([error, transactionHistoryResponseModel, currentPage]);
}

class TransactionHistoryPaginationNetworkError
    extends TransactionHistoryPaginationError with BaseNetworkErrorState {
  TransactionHistoryPaginationNetworkError({
    LocalizedStringBuilder error,
    TransactionHistoryResponseModel transactionHistoryResponseModel,
    int currentPage,
  }) : super(
          error: error,
          transactionHistoryResponseModel: transactionHistoryResponseModel,
          currentPage: currentPage,
        );
}
