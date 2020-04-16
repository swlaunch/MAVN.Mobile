import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/bloc/unlink_wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/di/wallet_unlinking_module.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/view/unlink_wallet_in_progress/unlink_wallet_in_progress_page.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../mock_classes.dart';

void main() {
  setUpAll(() {
    initScreenshots();
  });

  group('Unlink wallet in progress page tests', () {
    testWidgets('Unlink wallet in progress page displays the correct content',
        (widgetTester) async {
      await _givenIAmOnTheUnlinkWalletInProgressPage(widgetTester);
      await thenWidgetShouldMatchScreenshot(
          widgetTester,
          find.byType(UnlinkWalletInProgressPage),
          'unlink_wallet_in_progress_page');
    });
  });
}

Future<void> _givenIAmOnTheUnlinkWalletInProgressPage(widgetTester) async =>
    await widgetTester.pumpWidget(_getSubjectWidget());

Widget _getSubjectWidget() {
  final mockWalletUnlinkingModule = MockWalletUnlinkingModule();

  final mockUnlinkWalletBloc =
      MockUnlinkWalletBloc(UnlinkWalletSubmissionUninitializedState());

  when(mockWalletUnlinkingModule.unlinkWalletBloc)
      .thenReturn(mockUnlinkWalletBloc);

  return TestAppFrame(
    child: ModuleProvider<WalletUnlinkingModule>(
      module: mockWalletUnlinkingModule,
      child: UnlinkWalletInProgressPage(),
    ),
  );
}
