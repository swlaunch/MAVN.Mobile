class PushNotificationRegistrationRequestModel {
  PushNotificationRegistrationRequestModel({this.pushRegistrationToken});

  final String pushRegistrationToken;

  Map<String, dynamic> toJson() => {
        'PushRegistrationToken': pushRegistrationToken,
      };
}
