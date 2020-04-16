import 'package:lykke_mobile_mavn/library_analytics/analytics_event.dart';
import 'package:recase/recase.dart';

class NetworkAnalyticsEvent extends AnalyticsEvent {
  NetworkAnalyticsEvent({
    feature,
    success,
    this.path,
    this.method,
    this.outcome,
    this.responseCode,
    this.responseBodyError,
  }) : super(eventName: 'networking_event', feature: feature, success: success);

  // TODO: Move the event key name to some other class

  final String path;
  final String method;
  final Outcome outcome;
  final int responseCode;
  final String responseBodyError;

  @override
  Map<String, dynamic> get eventParametersMap => super.eventParametersMap
    ..addAll({
      // TODO: Move the event params key names to some other class
      if (path != null)
        'path': path,
      if (method != null)
        'method': method,
      if (outcome != null)
        'outcome': ReCase(outcome.toString().split('.')[1]).snakeCase,
      if (responseCode != null)
        'response_code': responseCode,
      if (responseBodyError != null)
        'response_body_error': responseBodyError
    });

  @override
  List get props =>
      super.props..addAll([path, method, outcome, responseCode, success]);
}

enum Outcome {
  success,
  responseError,
  timeoutError,
  unknownError,
}
