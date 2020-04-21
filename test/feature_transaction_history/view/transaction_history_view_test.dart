import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/transaction_history_mapper.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_header.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_item.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_list.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_view.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/pagination_error_state.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

WidgetTester _widgetTester;

TransactionHistoryBloc _mockTransactionHistoryBloc;

GetMobileSettingsUseCase _mockGetMobileSettingsUseCase;

Widget _subjectWidget;

TransactionHistoryMapper _transactionHistoryMapper;

const Key _transactionHistoryViewContainerKey =
    Key('transactionHistoryViewContainer');

void main() {
  group('TransactionHistoryView tests', () {
    setUpAll(() {
      _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();
      _transactionHistoryMapper = TransactionHistoryMapper();
      when(_mockGetMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);
      initScreenshots();
    });

    setUp(() {
      _mockTransactionHistoryBloc = null;
    });

    testWidgets('building subject calls bloc loadTransactionHistory',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryUninitialized());

      verify(_mockTransactionHistoryBloc.loadTransactionHistory());
    });

    testWidgets('TransactionHistoryUninitialized', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryUninitialized());

      thenSpinnerNotPresent();
      thenTransactionHistoryViewErrorNotPresent();
      thenTransactionHistoryViewEmptyNotPresent();
      thenTransactionHistoryViewListNotPresent();
    });

    testWidgets('TransactionHistoryInitialPageLoading', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryInitialPageLoading());

      thenSpinnerPresent();
      thenTransactionHistoryViewErrorNotPresent();
      thenTransactionHistoryViewEmptyNotPresent();
      thenTransactionHistoryViewListNotPresent();
    });

    testWidgets('TransactionHistoryInitialPageError', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryInitialPageError(
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

      thenSpinnerNotPresent();
      thenTransactionHistoryViewErrorPresent();
      thenTransactionHistoryViewEmptyNotPresent();
      thenTransactionHistoryViewListNotPresent();
    });

    testWidgets('TransactionHistoryEmpty', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryEmpty());

      thenSpinnerNotPresent();
      thenTransactionHistoryViewErrorNotPresent();
      thenTransactionHistoryViewEmptyPresent();
      thenTransactionHistoryViewListNotPresent();
    });

    testWidgets('TransactionHistoryLoaded', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryLoaded(
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: 1));

      thenSpinnerNotPresent();
      thenTransactionHistoryViewErrorNotPresent();
      thenTransactionHistoryViewEmptyNotPresent();
      thenTransactionHistoryViewListPresent();
    });

    testWidgets('TransactionHistoryPaginationLoading', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryPaginationLoading(
            transactionHistoryResponseModel:
                TestConstants.stubTransactionHistoryResponseModel,
          ));

      thenSpinnerPresent();
      thenTransactionHistoryViewErrorNotPresent();
      thenTransactionHistoryViewEmptyNotPresent();
      thenTransactionHistoryViewListPresent();
    });

    testWidgets('TransactionHistoryPaginationError', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryPaginationError(
              error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: 1));

      thenSpinnerNotPresent();
      thenTransactionHistoryViewErrorPresent();
      thenTransactionHistoryViewEmptyNotPresent();
      thenTransactionHistoryViewListPresent();
    });

    testWidgets('TransactionHistoryPaginationError - retry',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryPaginationError(
              error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: 1));

      await widgetTester.ensureVisible(find.text('RETRY'));
      await widgetTester.tap(find.text('RETRY'));
      verify(_mockTransactionHistoryBloc.loadTransactionHistory()).called(2);
    });

    testWidgets('TransactionHistoryInitialPageError - retry',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryInitialPageError(
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

      await widgetTester.ensureVisible(find.text('RETRY'));
      await widgetTester.tap(find.text('RETRY'));
      verify(_mockTransactionHistoryBloc.loadTransactionHistory()).called(2);
    });

    testWidgets('Loaded transaction history matches screenshot',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryLoaded(
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: 1));

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_transactionHistoryViewContainerKey),
        'transaction_history_view_list',
        height: 1024,
      );
    });

    testWidgets('transaction history loading matches screenshot',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryInitialPageLoading());

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_transactionHistoryViewContainerKey),
        'transaction_history_initial_loading',
      );
    });

    testWidgets('No transaction history matches screenshot',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryEmpty());

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_transactionHistoryViewContainerKey),
        'transaction_history_empty',
      );
    });

    testWidgets('transaction history error matches screenshot',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryInitialPageError(
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_transactionHistoryViewContainerKey),
        'transaction_history_error',
      );
    });

    testWidgets('transaction history pagination loading matches screenshot',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryPaginationLoading(
            transactionHistoryResponseModel:
                TestConstants.stubTransactionHistoryResponseModel,
          ));

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_transactionHistoryViewContainerKey),
        'transaction_history_pagination_loading',
        height: 1024,
      );
    });

    testWidgets('transaction history pagination error matches screenshot',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          transactionHistoryState: TransactionHistoryPaginationError(
              transactionHistoryResponseModel:
                  TestConstants.stubTransactionHistoryResponseModel,
              currentPage: 1,
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)));

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_transactionHistoryViewContainerKey),
        'transaction_history_pagination_error',
        height: 1024,
      );
    });
  });
}

//////// GIVEN //////////
Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester, {
  @required TransactionHistoryState transactionHistoryState,
}) async {
  _mockTransactionHistoryBloc =
      MockTransactionHistoryBloc(transactionHistoryState);
  _subjectWidget = _getSubjectWidget(_mockTransactionHistoryBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}

////// THEN /////////
void thenSpinnerPresent() {
  expect(find.byType(Spinner), findsOneWidget);
}

void thenSpinnerNotPresent() {
  expect(find.byType(Spinner), findsNothing);
}

void thenTransactionHistoryViewErrorPresent() {
  expect(find.byType(PaginationErrorWidget), findsOneWidget);
  expect(find.text(TestConstants.stubErrorText), findsOneWidget);
}

void thenTransactionHistoryViewErrorNotPresent() {
  expect(find.byType(PaginationErrorWidget), findsNothing);
  expect(find.text(TestConstants.stubErrorText), findsNothing);
}

void thenTransactionHistoryViewEmptyPresent() {
  expect(find.byType(TransactionHistoryViewEmpty), findsOneWidget);
}

void thenTransactionHistoryViewEmptyNotPresent() {
  expect(find.byType(TransactionHistoryViewEmpty), findsNothing);
}

void thenTransactionHistoryViewListPresent() {
  expect(find.byType(TransactionHistoryViewList), findsOneWidget);
  expect(find.byType(TransactionHistoryViewListItem), findsNWidgets(7));
  expect(find.byType(TransactionHistoryHeader), findsNWidgets(2));
}

void thenTransactionHistoryViewListNotPresent() {
  expect(find.byType(TransactionHistoryViewList), findsNothing);
}

//////// HELPERS //////////

Widget _getSubjectWidget(TransactionHistoryBloc transactionHistoryBloc) {
  final mockWalletPageModule = MockWalletPageModule();
  when(mockWalletPageModule.transactionHistoryBloc)
      .thenReturn(transactionHistoryBloc);
  when(mockWalletPageModule.transactionMapper)
      .thenReturn(_transactionHistoryMapper);

  return TestAppFrame(
    mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
    child: ModuleProvider<WalletPageModule>(
      module: mockWalletPageModule,
      // Wrap in a scrollview so that the content doesn't overflow
      child: Scaffold(
        key: _transactionHistoryViewContainerKey,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: TransactionHistoryView(
            theme: LightTheme(),
          ),
        ),
      ),
    ),
  );
}
