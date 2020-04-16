import 'package:lykke_mobile_mavn/app/resources/feature_keys.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';

class OnboardingCompletedAnalyticsEvent extends AnalyticsEvent {
  OnboardingCompletedAnalyticsEvent(this.onboardingPagesViewTimesMillis)
      : super(
          success: true,
          eventName: 'onboarding_completed',
          feature: Feature.onboarding,
        );

  final Map<String, int> onboardingPagesViewTimesMillis;

  @override
  Map<String, dynamic> get eventParametersMap =>
      super.eventParametersMap..addAll(onboardingPagesViewTimesMillis);
}
