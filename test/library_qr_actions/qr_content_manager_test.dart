import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_open_url_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_p2p_transaction_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/actions/qr_unsuported_action.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/qr_content_manager.dart';
import 'package:mockito/mockito.dart';

import '../mock_classes.dart';
import '../test_constants.dart';

Router _mockRouter;
ExternalRouter _mockExternalRouter;
GetMobileSettingsUseCase _mockGetMobileSettingsUseCase;
CustomerBloc _mockCustomerBloc;
QrContentManager _subject;

void main() {
  group('QrContentManager tests', () {
    setUp(() {
      _mockRouter = MockRouter();
      _mockExternalRouter = MockExternalRouter();
      _mockGetMobileSettingsUseCase = MockGetMobileSettingsUseCase();
      _mockCustomerBloc = MockCustomerBloc(CustomerUninitializedState());
      when(_mockGetMobileSettingsUseCase.execute())
          .thenReturn(TestConstants.stubMobileSettings);
      _subject = QrContentManager(
        _mockRouter,
        _mockExternalRouter,
        _mockGetMobileSettingsUseCase,
        _mockCustomerBloc,
      );
    });

    testWidgets('test url content', (widgetTester) async {
      when(_mockExternalRouter.canLaunchUrl(any))
          .thenAnswer((_) => Future.value(true));

      final result = await _subject.getQrAction(TestConstants.stubValidWebSite);

      expect(result is QrOpenUrlAction, true);
      expect(result.dialogMessage, TestConstants.stubValidWebSite);
    });

    testWidgets('test email content', (widgetTester) async {
      final result = await _subject.getQrAction(TestConstants.stubValidEmail);

      expect(result is QrGoToP2PTransactionAction, true);
      expect(result.dialogMessage, TestConstants.stubValidEmail);
    });

    testWidgets('test unsuported content', (widgetTester) async {
      final result = await _subject.getQrAction(TestConstants.stubInvalidEmail);

      expect(result is QrUnsupportedAction, true);
      expect(result.dialogPositiveButtonTitle, null);
    });
  });
}
