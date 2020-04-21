import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/feature_notification/ui_components/badge_widget.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/wallet_disabled_widget.dart';
import 'package:lykke_mobile_mavn/feature_wallet/view/wallet_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

Router _mockRouter;
GetMobileSettingsUseCase _mockGetMobileSettingsUseCase;

void main() {
  setUpAll(() {
    _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();
    when(_mockGetMobileSettingsUseCase.execute())
        .thenReturn(TestConstants.stubMobileSettings);
    initScreenshots();
  });

  group('WalletPage tests', () {
    testWidgets('Payment Requests button should show pending requests badge',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester,
          partnerPaymentsPendingState: GenericListLoadedState(
            list: [TestConstants.stubPaymentRequest],
            currentPage: TestConstants.stubCurrentPage,
            totalCount: TestConstants.stubTotalCount,
          ));

      expect(find.byType(BadgeWidget), findsNWidgets(1));
    });

    testWidgets(
        'Payment Requests button should not show pending requests message',
        (widgetTester) async {
      await _getSubjectWidget(widgetTester,
          partnerPaymentsPendingState: GenericListErrorState(
            list: [TestConstants.stubPaymentRequest],
            currentPage: TestConstants.stubCurrentPage,
            error: LocalizedStringBuilder.custom(TestConstants.stubErrorText),
          ));
      expect(find.byType(BadgeWidget), findsNWidgets(0));
    });

    testWidgets('Wallet disabled', (widgetTester) async {
      await _getSubjectWidget(widgetTester,
          balanceState: BalanceLoadedState(
            wallet: TestConstants.stubWalletResponseModel,
            conversionRateAmount:
                TestConstants.stubCurrencyConverterResponseModel,
            currencyCode:
                TestConstants.stubWalletResponseModel.balance.assetSymbol,
            isWalletDisabled: true,
          ));
      expect(find.byType(WalletDisabledWidget), findsOneWidget);
      expect(find.byKey(const Key('walletDisabledOverlay')), findsOneWidget);
      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(WalletPage), 'wallet_page_wallet_disabled');
    });

    testWidgets('Wallet enabled', (widgetTester) async {
      await _getSubjectWidget(widgetTester,
          balanceState: BalanceLoadedState(
            wallet: TestConstants.stubWalletResponseModel,
            isWalletDisabled: false,
            conversionRateAmount:
                TestConstants.stubCurrencyConverterResponseModel,
            currencyCode:
                TestConstants.stubWalletResponseModel.balance.assetSymbol,
          ));
      expect(find.byType(WalletDisabledWidget), findsNothing);
      expect(find.byKey(const Key('walletDisabledOverlay')), findsNothing);
      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(WalletPage), 'wallet_page_wallet_enabled');
    });
  });
}

Future<void> _getSubjectWidget(WidgetTester tester,
    {GenericListState partnerPaymentsPendingState,
    BalanceState balanceState}) async {
  _mockRouter = MockRouter();

  final mockWalletPageModule = MockWalletPageModule();
  final mockTransactionHistoryBloc =
      MockTransactionHistoryBloc(TransactionHistoryUninitialized());
  final mockBottomBarModule = MockBottomBarModule();
  final mockBottomBarPageBloc = MockBottomBarPageBloc(null);

  when(mockBottomBarModule.bottomBarPageBloc).thenReturn(mockBottomBarPageBloc);
  when(mockWalletPageModule.transactionHistoryBloc)
      .thenReturn(mockTransactionHistoryBloc);

  final subjectWidget = TestAppFrame(
    mockRouter: _mockRouter,
    mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
    mockBalanceBloc:
        MockBalanceBloc(balanceState ?? BalanceUninitializedState()),
    mockPartnerPaymentsPendingBloc: MockPartnerPaymentsPendingBloc(
        partnerPaymentsPendingState ?? GenericListUninitializedState()),
    child: ModuleProvider<BottomBarModule>(
      module: mockBottomBarModule,
      child: ModuleProvider<WalletPageModule>(
        module: mockWalletPageModule,
        child: WalletPage(),
      ),
    ),
  );
  await tester.pumpWidget(subjectWidget);
}
