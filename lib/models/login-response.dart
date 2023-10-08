// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return LoginResponse.fromJson(jsonData);
}

String loginResponseToJson(LoginResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LoginResponse {
  String token;
  String expire;
  String userType;
  String fullName;
  String userName;
  String operatorId;

  LoginResponse({
    this.token,
    this.expire,
    this.userType,
    this.fullName,
    this.userName,
    this.operatorId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      new LoginResponse(
        token: json["Token"],
        expire: json["Expire"],
        userType: json["UserType"],
        fullName: json["FullName"],
        userName: json["UserName"],
        operatorId: json["OperatorId"],
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "Expire": expire,
        "UserType": userType,
        "FullName": fullName,
        "UserName": userName,
        "OperatorId": operatorId,
      };
}
