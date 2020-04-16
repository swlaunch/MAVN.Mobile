class UnreadNotificationCountResponseModel {
  UnreadNotificationCountResponseModel({this.unreadMessagesCount});

  UnreadNotificationCountResponseModel.fromJson(Map<String, dynamic> json)
      : unreadMessagesCount = json['UnreadMessagesCount'];

  final int unreadMessagesCount;
}
