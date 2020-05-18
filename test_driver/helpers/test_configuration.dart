import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import '../feature_home/home_steps.dart';
import '../feature_lead_referral/lead_referral_steps.dart';
import '../feature_login/login_steps.dart';
import '../feature_onboarding/onboarding_steps.dart';
import '../feature_p2p_transactions/p2p_transactions_steps.dart';
import '../feature_referral_list/referral_list_steps.dart';
import '../feature_register/register_steps.dart';
import '../feature_welcome/welcome_steps.dart';
import '../hooks/mock_server_hook.dart';
import '../hooks/reset_app_hook.dart';
import '../steps/steps.dart';
import '../worlds/flutter_with_mock_server_world.dart';

enum FlutterDriverTestPlatform { android, ios }

FlutterTestConfiguration getTestConfiguration({
  FlutterDriverTestPlatform platform,
}) =>
    FlutterTestConfiguration()
      ..features = [Glob(r'test_driver/**/**.feature', recursive: true)]
      ..reporters = [
        ProgressReporter(),
        TestRunSummaryReporter(),
        StdoutReporter(),
      ]
      ..hooks = [MockServerHook(), ResetAppStateHook()]
      ..stepDefinitions = [
        ...commonSteps,
        ...featureOnboardingSteps,
        ...featureWelcomeSteps,
        ...featureLoginSteps,
        ...featureRegisterSteps,
        ...featureHomeSteps,
        ...featureLeadReferralSteps,
        ...featureReferralListSteps,
        ...featureP2pTransactionSteps,
      ]
      ..targetAppPath = getTargetAppPath(platform)
      ..restartAppBetweenScenarios = false
      ..exitAfterTestRun = true
      ..buildFlavor = 'automation'
      ..createWorld = (_) async => FlutterWithMockServerWorld();

String getTargetAppPath(FlutterDriverTestPlatform platform) {
  switch (platform) {
    case FlutterDriverTestPlatform.android:
      return 'test_driver/app_android.dart';
    case FlutterDriverTestPlatform.ios:
      return 'test_driver/app_ios.dart';
    default:
      return null;
  }
}
