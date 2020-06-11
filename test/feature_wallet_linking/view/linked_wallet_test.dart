import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/di/wallet_page_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet_linking/view/linked_wallet.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

MockRouter _mockRouter;
MockUserVerificationBloc _mockUserVerificationBloc;
MockLocalSettingsRepository _mockLocalSettingsRepository;
MockGetMobileSettingsUseCase _mockGetMobileSettingsUseCase;
void main() {
  setUpAll(() {
    initScreenshots();
  });

  group('LinkedWalletPage tests', () {
    testWidgets('Linked wallet page displays the correct content',
        (widgetTester) async {
      await _givenIAmOnTheLinkedWalletPage(widgetTester);
      await thenWidgetShouldMatchScreenshot(
          widgetTester, find.byType(LinkedWalletPage), 'linked_wallet_page');
    });

    testWidgets(
        'Tapping on the unlink wallet button should start user verification',
        (widgetTester) async {
      await _givenIAmOnTheLinkedWalletPage(widgetTester);
      await widgetTester
          .tap(find.byKey(const Key('unlinkExternalWalletButton')));
      verify(_mockUserVerificationBloc.verify(
              onSuccess: anyNamed('onSuccess'),
              onCouldNotVerify: anyNamed('onCouldNotVerify')))
          .called(1);
    });
  });
}

Future<void> _givenIAmOnTheLinkedWalletPage(widgetTester) async {
  await widgetTester.pumpWidget(_getSubjectWidget(widgetTester));
}

Widget _getSubjectWidget(
  WidgetTester tester, {
  BalanceState balanceState,
}) {
  _mockRouter = MockRouter();
  _mockLocalSettingsRepository = MockLocalSettingsRepository();
  _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();
  final mockWalletPageModule = MockWalletPageModule();
  final mockTransactionHistoryBloc =
      MockTransactionHistoryBloc(GenericListUninitializedState());
  final mockBottomBarModule = MockBottomBarModule();
  final mockBottomBarPageBloc = MockBottomBarPageBloc(null);

  _mockUserVerificationBloc = MockUserVerificationBloc();

  when(mockBottomBarModule.bottomBarPageBloc).thenReturn(mockBottomBarPageBloc);
  when(_mockGetMobileSettingsUseCase.execute())
      .thenReturn(TestConstants.stubMobileSettings);
  when(mockWalletPageModule.transactionHistoryBloc)
      .thenReturn(mockTransactionHistoryBloc);

  return TestAppFrame(
    mockLocalSettingsRepository: _mockLocalSettingsRepository,
    mockGetMobileSettingsUseCase: _mockGetMobileSettingsUseCase,
    mockRouter: _mockRouter,
    mockBalanceBloc:
        MockBalanceBloc(balanceState ?? BalanceUninitializedState()),
    mockUserVerificationBloc: _mockUserVerificationBloc,
    child: ModuleProvider<WalletPageModule>(
      module: mockWalletPageModule,
      child: LinkedWalletPage(),
    ),
  );
}
