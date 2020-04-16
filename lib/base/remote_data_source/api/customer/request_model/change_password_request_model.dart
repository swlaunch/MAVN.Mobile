class ChangePasswordRequestModel {
  ChangePasswordRequestModel({this.password});

  final String password;

  Map<String, dynamic> toJson() => {
        'Password': password,
      };
}
