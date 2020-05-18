import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/transaction_history_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

BlocTester<TransactionHistoryBloc> _blocTester;
CustomerRepository _mockCustomerRepository = MockCustomerRepository();

TransactionHistoryBloc subject;

void main() {
  group('ChangePasswordBloc tests', () {
    setUp(() {
      reset(_mockCustomerRepository);
      _expectedFullBlocOutput.clear();

      subject = TransactionHistoryBloc(_mockCustomerRepository);
      _blocTester = BlocTester(subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(TransactionHistoryUninitialized());
    });

    group('loadTransactionHistory()', () {
      group('success scenarios', () {
        test('from TransactionHistoryUninitialized', () async {
          whenRepositoryGetTransactionHistoryInitialPageSuccess();

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryLoaded(
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: TransactionHistoryBloc.initialPage,
            )
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('from TransactionHistoryInitialPageError', () async {
          whenRepositoryGetTransactionHistoryInitialPageSuccess();

          subject.setState(TransactionHistoryInitialPageError(
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageError(
                error:
                    LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryLoaded(
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: TransactionHistoryBloc.initialPage,
            )
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('from TransactionHistoryInitialPageLoading', () async {
          whenRepositoryGetTransactionHistoryInitialPageSuccess();

          subject.setState(TransactionHistoryInitialPageLoading());

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
          ]);

          verifyZeroInteractions(_mockCustomerRepository);
        });

        test('from TransactionHistoryEmpty', () async {
          whenRepositoryGetTransactionHistoryInitialPageSuccess();

          subject.setState(TransactionHistoryEmpty());

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryEmpty(),
          ]);

          verifyZeroInteractions(_mockCustomerRepository);
        });

        test('from TransactionHistoryPaginationLoading', () async {
          whenRepositoryGetTransactionHistoryInitialPageSuccess();

          subject.setState(TransactionHistoryPaginationLoading(
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryPaginationLoading(
                transactionHistoryResponseModel:
                    TestConstants.stubTransactionHistoryResponseModel),
          ]);

          verifyZeroInteractions(_mockCustomerRepository);
        });

        test('from TransactionHistoryPaginationError', () async {
          whenRepositoryGetTransactionHistorySecondPageSuccess();

          final initialTransactionList = [
            Transaction(
                type: TransactionType.bonusReward,
                amount: '50000',
                date: TestConstants.stubDateString)
          ];

          final initialTransactionResponseModel =
              TransactionHistoryResponseModel(
                  transactionList: initialTransactionList,
                  totalCount: TransactionHistoryBloc.pageSize + 1);

          final loadedState = TransactionHistoryPaginationError(
              error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
              transactionHistoryResponseModel: initialTransactionResponseModel,
              currentPage: TransactionHistoryBloc.initialPage + 1);

          subject.setState(loadedState);

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            loadedState,
            TransactionHistoryPaginationLoading(
                transactionHistoryResponseModel:
                    initialTransactionResponseModel),
            TransactionHistoryLoaded(
                transactionHistoryResponseModel:
                    TransactionHistoryResponseModel(
                        transactionList: initialTransactionList
                          ..addAll(TestConstants.stubTransactionHistoryList),
                        totalCount: TestConstants.stubTotalCount),
                currentPage: TransactionHistoryBloc.initialPage + 1)
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('from TransactionHistoryLoaded', () async {
          whenRepositoryGetTransactionHistoryInitialPageSuccess();

          final loadedState = TransactionHistoryLoaded(
              transactionHistoryResponseModel:
                  TransactionHistoryResponseModel(transactionList: [
                Transaction(
                    type: TransactionType.bonusReward,
                    amount: '50000',
                    date: TestConstants.stubDateString)
              ], totalCount: TransactionHistoryBloc.pageSize - 1),
              currentPage: TransactionHistoryBloc.initialPage);

          subject.setState(loadedState);

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder(
              [TransactionHistoryUninitialized(), loadedState]);

          verifyZeroInteractions(_mockCustomerRepository);
        });

        test('from TransactionHistoryLoaded', () async {
          whenRepositoryGetTransactionHistorySecondPageSuccess();

          final initialTransactionList = [
            Transaction(
                type: TransactionType.bonusReward,
                amount: '50000',
                date: TestConstants.stubDateString)
          ];

          final initialTransactionResponseModel =
              TransactionHistoryResponseModel(
                  transactionList: initialTransactionList,
                  totalCount: TransactionHistoryBloc.pageSize + 1);

          final loadedState = TransactionHistoryLoaded(
              transactionHistoryResponseModel: initialTransactionResponseModel,
              currentPage: TransactionHistoryBloc.initialPage);

          subject.setState(loadedState);

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            loadedState,
            TransactionHistoryPaginationLoading(
                transactionHistoryResponseModel:
                    initialTransactionResponseModel),
            TransactionHistoryLoaded(
                transactionHistoryResponseModel:
                    TransactionHistoryResponseModel(
                        transactionList: initialTransactionList
                          ..addAll(TestConstants.stubTransactionHistoryList),
                        totalCount: TestConstants.stubTotalCount),
                currentPage: TransactionHistoryBloc.initialPage + 1)
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('total count 0', () async {
          when(
            _mockCustomerRepository.getTransactionHistory(
                currentPage: TransactionHistoryBloc.initialPage,
                pageSize: TransactionHistoryBloc.pageSize),
          ).thenAnswer((_) => Future.value(TransactionHistoryResponseModel(
              transactionList: TestConstants.stubTransactionHistoryList,
              totalCount: 0)));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryEmpty(),
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('transactionHistoryResponseModel null', () async {
          when(
            _mockCustomerRepository.getTransactionHistory(
                currentPage: TransactionHistoryBloc.initialPage,
                pageSize: TransactionHistoryBloc.pageSize),
          ).thenAnswer((_) => Future.value(null));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryEmpty(),
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('transactionHistoryResponseModel.transactionList null', () async {
          when(
            _mockCustomerRepository.getTransactionHistory(
                currentPage: TransactionHistoryBloc.initialPage,
                pageSize: TransactionHistoryBloc.pageSize),
          ).thenAnswer((_) => Future.value(
              const TransactionHistoryResponseModel(
                  transactionList: null, totalCount: 100)));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryEmpty(),
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('transactionHistoryResponseModel.transactionList empty', () async {
          when(
            _mockCustomerRepository.getTransactionHistory(
                currentPage: TransactionHistoryBloc.initialPage,
                pageSize: TransactionHistoryBloc.pageSize),
          ).thenAnswer((_) => Future.value(
              const TransactionHistoryResponseModel(
                  transactionList: [], totalCount: 100)));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryEmpty(),
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });
      });

      group('error scenarios', () {
        test('from TransactionHistoryUninitialized', () async {
          whenRepositoryGetTransactionHistoryInitialPageError();

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryInitialPageError(
                error: LazyLocalizedStrings
                    .walletPageTransactionHistoryInitialPageError),
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('from TransactionHistoryInitialPageError', () async {
          whenRepositoryGetTransactionHistoryInitialPageError();

          subject.setState(TransactionHistoryInitialPageError(
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            TransactionHistoryInitialPageError(
                error:
                    LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
            TransactionHistoryInitialPageLoading(),
            TransactionHistoryInitialPageError(
                error: LazyLocalizedStrings
                    .walletPageTransactionHistoryInitialPageError),
          ]);
        });

        test('from TransactionHistoryPaginationError', () async {
          whenRepositoryGetTransactionHistorySecondPageError();

          final initialTransactionList = [
            Transaction(
                type: TransactionType.bonusReward,
                amount: '50000',
                date: TestConstants.stubDateString)
          ];

          final initialTransactionResponseModel =
              TransactionHistoryResponseModel(
                  transactionList: initialTransactionList,
                  totalCount: TransactionHistoryBloc.pageSize + 1);

          final loadedState = TransactionHistoryPaginationError(
              error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
              transactionHistoryResponseModel: initialTransactionResponseModel,
              currentPage: TransactionHistoryBloc.initialPage + 1);

          subject.setState(loadedState);

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            loadedState,
            TransactionHistoryPaginationLoading(
                transactionHistoryResponseModel:
                    initialTransactionResponseModel),
            TransactionHistoryPaginationError(
                error: LazyLocalizedStrings
                    .walletPageTransactionHistoryPaginationError,
                transactionHistoryResponseModel:
                    initialTransactionResponseModel,
                currentPage: TransactionHistoryBloc.initialPage + 1)
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });

        test('from TransactionHistoryLoaded', () async {
          whenRepositoryGetTransactionHistorySecondPageError();

          final initialTransactionList = [
            Transaction(
                type: TransactionType.bonusReward,
                amount: '50000',
                date: TestConstants.stubDateString)
          ];

          final initialTransactionResponseModel =
              TransactionHistoryResponseModel(
                  transactionList: initialTransactionList,
                  totalCount: TransactionHistoryBloc.pageSize + 1);

          final loadedState = TransactionHistoryLoaded(
              transactionHistoryResponseModel: initialTransactionResponseModel,
              currentPage: TransactionHistoryBloc.initialPage);

          subject.setState(loadedState);

          await subject.loadTransactionHistory();

          await _blocTester.assertFullBlocOutputInOrder([
            TransactionHistoryUninitialized(),
            loadedState,
            TransactionHistoryPaginationLoading(
                transactionHistoryResponseModel:
                    initialTransactionResponseModel),
            TransactionHistoryPaginationError(
                error: LazyLocalizedStrings
                    .walletPageTransactionHistoryPaginationError,
                transactionHistoryResponseModel:
                    initialTransactionResponseModel,
                currentPage: TransactionHistoryBloc.initialPage + 1)
          ]);

          thenRepositoryGetTransactionHistoryCalledOnce();
        });
      });
    });
  });
}

void whenRepositoryGetTransactionHistorySecondPageSuccess() {
  when(
    _mockCustomerRepository.getTransactionHistory(
        currentPage: TransactionHistoryBloc.initialPage + 1,
        pageSize: TransactionHistoryBloc.pageSize),
  ).thenAnswer(
      (_) => Future.value(TestConstants.stubTransactionHistoryResponseModel));
}

void whenRepositoryGetTransactionHistoryInitialPageSuccess() {
  when(
    _mockCustomerRepository.getTransactionHistory(
        currentPage: TransactionHistoryBloc.initialPage,
        pageSize: TransactionHistoryBloc.pageSize),
  ).thenAnswer(
      (_) => Future.value(TestConstants.stubTransactionHistoryResponseModel));
}

void whenRepositoryGetTransactionHistoryInitialPageError() {
  when(
    _mockCustomerRepository.getTransactionHistory(
        currentPage: TransactionHistoryBloc.initialPage,
        pageSize: TransactionHistoryBloc.pageSize),
  ).thenThrow(TestConstants.stubException);
}

void whenRepositoryGetTransactionHistorySecondPageError() {
  when(
    _mockCustomerRepository.getTransactionHistory(
        currentPage: TransactionHistoryBloc.initialPage + 1,
        pageSize: TransactionHistoryBloc.pageSize),
  ).thenThrow(TestConstants.stubException);
}

void thenRepositoryGetTransactionHistoryCalledOnce() {
  verify(_mockCustomerRepository.getTransactionHistory(
          currentPage: anyNamed('currentPage'), pageSize: anyNamed('pageSize')))
      .called(1);
}
