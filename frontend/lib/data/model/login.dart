import 'dart:convert';

import 'package:flutter_checkdoc/domain/entities/login_request.dart';
import 'package:flutter_checkdoc/domain/entities/login_response.dart';

class LoginRequestModel extends LoginRequest {
  LoginRequestModel({
    required super.email,
    required super.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'],
      password: json['password'],
    );
  }

  String toFormUrlEncoded() {
    return "email=$email&password=$password";
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.access_token,
    required super.refresh_token,
  });

  factory LoginResponseModel.fromRawJson(String str) =>
      LoginResponseModel.fromJson(json.decode(str));

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      access_token: json["access_token"],
      refresh_token: json["refresh_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": access_token,
      "refresh_token": refresh_token,
    };
  }
}
