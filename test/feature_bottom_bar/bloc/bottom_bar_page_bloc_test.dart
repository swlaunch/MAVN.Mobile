import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_page_bloc.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/view/non_mandatory_app_upgrade_dialog.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';
import '../../test_constants.dart';

LocalSettingsRepository _mockLocalSettingsRepository =
    MockLocalSettingsRepository();
Router _mockRouter = MockRouter();

BottomBarPageBloc _subject;

void main() {
  group('BottomBarPageBloc tests', () {
    setUp(() {
      reset(_mockLocalSettingsRepository);
      reset(_mockRouter);
      _subject = BottomBarPageBloc(
        _mockLocalSettingsRepository,
        _mockRouter,
      );
    });

    test(
        'checkAppVersionUpgradePrompt - should not show dialog because '
        'current version is the latest ', () async {
      when(_mockLocalSettingsRepository.getCurrentAppVersion())
          .thenAnswer((_) => Future.value(TestConstants.stubLatestAppVersion));

      when(_mockLocalSettingsRepository.getLastAppVersionUpgradeDialogPrompt())
          .thenReturn(TestConstants.stubOutdatedAppVersion);

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(TestConstants.stubMobileSettings);

      await _subject.init();

      verifyNever(_mockLocalSettingsRepository
          .setLastAppVersionUpgradeDialogPrompt(value: anyNamed('value')));
      verifyNever(_mockRouter.showDialog(child: anyNamed('child')));
      verifyNever(_mockRouter.redirectToAppStores());
    });

    test(
        'checkAppVersionUpgradePrompt - should not show dialog because '
        'prompt was shown before ', () async {
      when(_mockLocalSettingsRepository.getCurrentAppVersion()).thenAnswer(
          (_) => Future.value(TestConstants.stubOutdatedAppVersion));

      when(_mockLocalSettingsRepository.getLastAppVersionUpgradeDialogPrompt())
          .thenReturn(TestConstants.stubLatestAppVersion);

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(TestConstants.stubMobileSettings);

      await _subject.init();

      verifyNever(_mockLocalSettingsRepository
          .setLastAppVersionUpgradeDialogPrompt(value: anyNamed('value')));
      verifyNever(_mockRouter.showDialog(child: anyNamed('child')));
      verifyNever(_mockRouter.redirectToAppStores());
    });

    test('checkAppVersionUpgradePrompt - should show dialog', () async {
      when(_mockLocalSettingsRepository.getCurrentAppVersion()).thenAnswer(
          (_) => Future.value(TestConstants.stubOutdatedAppVersion));

      when(_mockLocalSettingsRepository.getLastAppVersionUpgradeDialogPrompt())
          .thenReturn(TestConstants.stubOutdatedAppVersion);

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(TestConstants.stubMobileSettings);

      await _subject.init();

      verify(_mockLocalSettingsRepository.setLastAppVersionUpgradeDialogPrompt(
              value: TestConstants.stubLatestAppVersion))
          .called(1);

      final verification =
          verify(_mockRouter.showDialog(child: captureAnyNamed('child')));
      expect(verification.callCount, 1);
      expect(verification.captured[0],
          isInstanceOf<NonMandatoryAppUpgradeDialog>());
    });

    test('checkAppVersionUpgradePrompt - dialog positive button tapped',
        () async {
      when(_mockLocalSettingsRepository.getCurrentAppVersion()).thenAnswer(
          (_) => Future.value(TestConstants.stubOutdatedAppVersion));

      when(_mockLocalSettingsRepository.getLastAppVersionUpgradeDialogPrompt())
          .thenReturn(TestConstants.stubOutdatedAppVersion);

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(TestConstants.stubMobileSettings);

      when(_mockRouter.showDialog(child: anyNamed('child')))
          .thenAnswer((_) => Future<bool>.value(true));

      await _subject.init();

      verify(_mockRouter.redirectToAppStores()).called(1);
    });

    test('checkAppVersionUpgradePrompt - dialog negative button tapped',
        () async {
      when(_mockLocalSettingsRepository.getCurrentAppVersion()).thenAnswer(
          (_) => Future.value(TestConstants.stubOutdatedAppVersion));

      when(_mockLocalSettingsRepository.getLastAppVersionUpgradeDialogPrompt())
          .thenReturn(TestConstants.stubOutdatedAppVersion);

      when(_mockLocalSettingsRepository.getMobileSettings())
          .thenReturn(TestConstants.stubMobileSettings);

      when(_mockRouter.showDialog(child: anyNamed('child')))
          .thenAnswer((_) => Future<bool>.value(false));

      await _subject.init();

      verifyNever(_mockRouter.redirectToAppStores());
    });
  });
}
