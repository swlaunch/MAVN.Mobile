class WalletStatusResponseModel {
  WalletStatusResponseModel({this.isBlocked});

  WalletStatusResponseModel.fromJson(Map<String, dynamic> json)
      : isBlocked = json['IsBlocked'];

  final bool isBlocked;
}
