import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:meta/meta.dart';

class AnalyticsService {
  AnalyticsService(this.analytics);

  final FirebaseAnalytics analytics;

  Future<void> logEvent({@required AnalyticsEvent analyticsEvent}) =>
      analytics.logEvent(
        name: analyticsEvent.eventName,
        parameters: analyticsEvent.eventParametersMap,
      );

  Future<void> setCurrentScreen({@required String screenName}) =>
      analytics.setCurrentScreen(screenName: screenName);
}
