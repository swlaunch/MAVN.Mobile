import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class AnalyticsEvent implements EquatableMixin {
  AnalyticsEvent({
    @required this.eventName,
    this.feature,
    this.success,
  }) : assert(
          eventName.length <= 40,
          'Event name should not exceed 40 characters',
        );

  final String eventName;
  final String feature;
  final bool success;

  Map<String, dynamic> get eventParametersMap => {
        if (feature != null) 'feature': feature,
        if (success != null) 'success': success ? 1 : 0,
      };

  @override
  List get props => [eventName, feature, success, eventParametersMap];

  @override
  bool get stringify => false;
}
