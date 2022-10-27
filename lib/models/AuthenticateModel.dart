class AuthenticateModel {
  String? access_token;
  String? refresh_token;
  String? farm_name;

  AuthenticateModel.fromJson(json)
      : access_token = json['data']['token']['access_token'],
        refresh_token = json['data']['token']['refresh_token'],
        farm_name = json['data']['farm_name'];
}
