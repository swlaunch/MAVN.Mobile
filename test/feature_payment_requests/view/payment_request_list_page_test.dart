import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/di/partner_payments_module.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/ui_components/payment_request_status_card.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/ui_components/tab_bar_layout.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/payment_request_list_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/pagination_error_state.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dark_page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/empty_list_widget.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockPartnerPaymentsPendingBloc _mockPendingBloc;
MockPartnerPaymentsCompletedBloc _mockCompletedBloc;
MockPartnerPaymentsFailedBloc _mockFailedBloc;

final _mockRouter = MockRouter();
WidgetTester _widgetTester;

Widget _subjectWidget;

const Key _ongoingTab = Key('paymentRequestListOngoingTab');
const Key _ongoingList = Key('paymentRequestListOngoingList');
const Key _completedTab = Key('paymentRequestListCompletedTab');
const Key _completedList = Key('paymentRequestListCompletedList');
const Key _failedTab = Key('paymentRequestListUnsuccessfulTab');
const Key _failedList = Key('paymentRequestListFailedList');

void main() {
  group('PaymentRequestListPage general tests', () {
    // Expect to find all back button, page title, tab bar and
    // see only pending list since it's the default open one
    testWidgets('UnitializedState has all needed widgets',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      expect(find.byType(CustomBackButton), findsOneWidget);
      expect(find.byType(DarkPageTitle), findsOneWidget);
      expect(find.byType(TabBarLayout), findsOneWidget);
      expect(find.byKey(_ongoingTab), findsOneWidget);
      expect(find.byKey(_completedTab), findsOneWidget);
      expect(find.byKey(_failedTab), findsOneWidget);
      expect(find.byKey(_ongoingList), findsOneWidget);
      expect(find.byKey(_completedList), findsNothing);
      expect(find.byKey(_failedList), findsNothing);
    });

    testWidgets('Clicking a tab redirects to the relevant content',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      //completed
      await _goToTab(widgetTester, _completedTab);
      expect(find.byKey(_ongoingList), findsNothing);
      expect(find.byKey(_completedList), findsOneWidget);
      expect(find.byKey(_failedList), findsNothing);

      //failed
      await _goToTab(widgetTester, _failedTab);
      expect(find.byKey(_ongoingList), findsNothing);
      expect(find.byKey(_completedList), findsNothing);
      expect(find.byKey(_failedList), findsOneWidget);

      //going back to pending
      await _goToTab(widgetTester, _ongoingTab);
      expect(find.byKey(_ongoingList), findsOneWidget);
      expect(find.byKey(_completedList), findsNothing);
      expect(find.byKey(_failedList), findsNothing);
    });

    testWidgets('Each tab shows its own error', (widgetTester) async {
      final paginationError = GenericListErrorState(
        error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
        currentPage: 1,
        list: [],
      );
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: paginationError,
        blocCompletedState: paginationError,
        blocFailedState: paginationError,
      );

      //pending
      expect(find.byType(PaginationErrorWidget), findsOneWidget);

      //completed
      await _goToTab(widgetTester, _completedTab);
      expect(find.byType(PaginationErrorWidget), findsOneWidget);

      //failed
      await _goToTab(widgetTester, _failedTab);
      expect(find.byType(PaginationErrorWidget), findsOneWidget);
    });
  });

  group('PaymentRequestPending tests', () {
    final _pendingLoadedState = GenericListLoadedState(
      list: [TestConstants.stubPaymentRequest],
      currentPage: TestConstants.stubCurrentPage,
      totalCount: TestConstants.stubTotalCount,
    );
    // Expect to find all back button, page title, tab bar and
    // see only pending list since it's the default open one
    testWidgets('showing empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListEmptyState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      expect(find.byType(EmptyListWidget), findsOneWidget);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('showing non-empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: _pendingLoadedState,
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      expect(find.byType(EmptyListWidget), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(PaymentRequestStatusCard), findsOneWidget);
    });

    testWidgets('clicking a PR redirects to PaymentRequestPage',
        (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: _pendingLoadedState,
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      expect(find.byType(PaymentRequestStatusCard), findsOneWidget);
      await widgetTester.tap(find.byType(PaymentRequestStatusCard));
      verify(_mockRouter.pushPaymentRequestPage(
              TestConstants.stubPaymentRequest.paymentRequestId))
          .called(1);
    });

    testWidgets('changing a PR status calls all blocs', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: _pendingLoadedState,
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      when(_mockRouter.pushPaymentRequestPage(
              TestConstants.stubPaymentRequest.paymentRequestId))
          .thenAnswer((_) => Future.value(true));

      expect(find.byType(PaymentRequestStatusCard), findsOneWidget);
      await widgetTester.tap(find.byType(PaymentRequestStatusCard));

      verify(_mockPendingBloc.updateGenericList()).called(2);
      verify(_mockFailedBloc.updateGenericList()).called(1);
      verify(_mockCompletedBloc.updateGenericList()).called(1);
    });

    testWidgets('pull to refresh on non-empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: _pendingLoadedState,
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      await widgetTester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await widgetTester.pumpAndSettle();

      verify(_mockPendingBloc.updateGenericList(refresh: true)).called(1);
    });

    testWidgets('pull to refresh on empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListEmptyState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListUninitializedState(),
      );

      await widgetTester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await widgetTester.pumpAndSettle();

      verify(_mockPendingBloc.updateGenericList(refresh: true)).called(1);
    });
  });

  group('PaymentRequestCompleted tests', () {
    final _completedLoadedState = GenericListLoadedState(
      list: [TestConstants.stubPaymentRequest],
      currentPage: TestConstants.stubCurrentPage,
      totalCount: TestConstants.stubTotalCount,
    );

    testWidgets('showing empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListEmptyState(),
        blocFailedState: GenericListUninitializedState(),
      );
      await _goToTab(widgetTester, _completedTab);
      expect(find.byType(EmptyListWidget), findsOneWidget);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('showing non-empty state - payment req dated this year',
        (widgetTester) async {
      final _completedLoadedState = GenericListLoadedState(
          currentPage: 1,
          totalCount: 0,
          list: [TestConstants.stubPaymentRequest]);

      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: _completedLoadedState,
        blocFailedState: GenericListUninitializedState(),
      );
      await _goToTab(widgetTester, _completedTab);

      expect(find.byType(EmptyListWidget), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(PaymentRequestStatusCard), findsOneWidget);
      expect(find.text('28 June, 14:22'), findsOneWidget);
    });

    testWidgets('showing non-empty state - payment req dated last year',
        (widgetTester) async {
      final _completedLoadedStateForLastYear = GenericListLoadedState(
          currentPage: 1,
          totalCount: 0,
          list: [TestConstants.stubPaymentRequestDatedLastYear]);

      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: _completedLoadedStateForLastYear,
        blocFailedState: GenericListUninitializedState(),
      );
      await _goToTab(widgetTester, _completedTab);

      expect(find.byType(EmptyListWidget), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(PaymentRequestStatusCard), findsOneWidget);
      expect(find.text('28 June 2018, 14:22'), findsOneWidget);
    });

    testWidgets('pull to refresh on non-empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: _completedLoadedState,
        blocFailedState: GenericListUninitializedState(),
      );
      await _goToTab(widgetTester, _completedTab);

      await widgetTester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await widgetTester.pumpAndSettle();

      verify(_mockCompletedBloc.updateGenericList(refresh: true)).called(1);
    });

    testWidgets('pull to refresh on empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListEmptyState(),
        blocFailedState: GenericListUninitializedState(),
      );
      await _goToTab(widgetTester, _completedTab);

      await widgetTester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await widgetTester.pumpAndSettle();

      verify(_mockCompletedBloc.updateGenericList(refresh: true)).called(1);
    });
  });

  group('PaymentRequestFailed tests', () {
    final _failedLoadedState = GenericListLoadedState(
      list: [TestConstants.stubPaymentRequest],
      currentPage: TestConstants.stubCurrentPage,
      totalCount: TestConstants.stubTotalCount,
    );

    testWidgets('showing empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(widgetTester,
          blocPendingState: GenericListUninitializedState(),
          blocCompletedState: GenericListUninitializedState(),
          blocFailedState: GenericListEmptyState());
      await _goToTab(widgetTester, _failedTab);
      expect(find.byType(EmptyListWidget), findsOneWidget);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('showing non-empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: _failedLoadedState,
      );
      await _goToTab(widgetTester, _failedTab);

      expect(find.byType(EmptyListWidget), findsNothing);
      expect(find.byType(GenericErrorWidget), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(PaymentRequestStatusCard), findsOneWidget);
    });

    testWidgets('pull to refresh on non-empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: _failedLoadedState,
      );
      await _goToTab(widgetTester, _failedTab);

      await widgetTester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await widgetTester.pumpAndSettle();

      verify(_mockFailedBloc.updateGenericList(refresh: true)).called(1);
    });

    testWidgets('pull to refresh on empty state', (widgetTester) async {
      await _givenSubjectWidgetWithInitialBlocState(
        widgetTester,
        blocPendingState: GenericListUninitializedState(),
        blocCompletedState: GenericListUninitializedState(),
        blocFailedState: GenericListEmptyState(),
      );
      await _goToTab(widgetTester, _failedTab);

      await widgetTester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await widgetTester.pumpAndSettle();

      verify(_mockFailedBloc.updateGenericList(refresh: true)).called(1);
    });
  });
}

Future _goToTab(WidgetTester widgetTester, Key tab) async {
  await widgetTester.tap(find.byKey(tab));
  await widgetTester.pumpAndSettle();
}

//region when

//endregion when
// region given

Future<void> _givenSubjectWidgetWithInitialBlocState(
  WidgetTester tester, {
  GenericListState blocPendingState,
  GenericListState blocCompletedState,
  GenericListState blocFailedState,
}) async {
  _mockPendingBloc = MockPartnerPaymentsPendingBloc(blocPendingState);
  _mockCompletedBloc = MockPartnerPaymentsCompletedBloc(blocCompletedState);
  _mockFailedBloc = MockPartnerPaymentsFailedBloc(blocFailedState);

  _subjectWidget =
      _getSubjectWidget(_mockPendingBloc, _mockCompletedBloc, _mockFailedBloc);

  _widgetTester = tester;

  await _widgetTester.pumpWidget(_subjectWidget);
}

// endregion given

Widget _getSubjectWidget(
  MockPartnerPaymentsPendingBloc mockPartnerPaymentsPendingBloc,
  MockPartnerPaymentsCompletedBloc mockPartnerPaymentsCompletedBloc,
  MockPartnerPaymentsFailedBloc mockPartnerPaymentsFailedBloc,
) {
  final mockPartnerPaymentsModule = MockPartnerPaymentsModule();

  when(mockPartnerPaymentsModule.completedPartnerPaymentsBloc)
      .thenReturn(mockPartnerPaymentsCompletedBloc);

  when(mockPartnerPaymentsModule.failedPartnerPaymentsBloc)
      .thenReturn(mockPartnerPaymentsFailedBloc);

  return TestAppFrame(
      mockRouter: _mockRouter,
      mockPartnerPaymentsPendingBloc: mockPartnerPaymentsPendingBloc,
      child: ModuleProvider<PartnerPaymentsModule>(
        module: mockPartnerPaymentsModule,
        child: const PaymentRequestListPage(),
      ));
}
