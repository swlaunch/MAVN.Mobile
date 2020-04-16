class LoginRequestModel {
  LoginRequestModel(this.email, this.password);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'Email': email, 'Password': password};
}
