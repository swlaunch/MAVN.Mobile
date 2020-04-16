import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class FirebaseMessagingState extends BlocState {}

abstract class FirebaseMessagingEvent extends BlocEvent {}

class FirebaseMessagingUninitializedState extends FirebaseMessagingState {}

class FirebaseMessagingConfiguredState extends FirebaseMessagingState {}

class FirebaseMessagingNotificationPendingEvent extends FirebaseMessagingEvent {
}

class FirebaseMessagingMarkAsReadEvent extends FirebaseMessagingEvent {
  FirebaseMessagingMarkAsReadEvent({@required this.messageGroupId});

  final String messageGroupId;
}
