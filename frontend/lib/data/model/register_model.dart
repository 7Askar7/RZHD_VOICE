import 'dart:convert';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/register_response.dart';

class RegisterRequestModel extends RegisterRequest {
  RegisterRequestModel({
    required super.email,
    required super.password,
    required super.name,
    required super.phone_number,
    required super.phone_number_code,
  });
  factory RegisterRequestModel.fromRawJson(String str) =>
      RegisterRequestModel.fromJson(json.decode(str));

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      password: json["password"],
      email: json["email"],
      name: json["name"],
      phone_number: json["phone_number"],
      phone_number_code: json["phone_number_code"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "password": password,
      "email": email,
      "name": name,
      "phone_number": phone_number,
      "phone_number_code": phone_number_code,
    };
  }

  String toFormUrlEncoded() {
    return "email=$email&password=$password&name=$name&phone_number=$phone_number&phone_number_code=$phone_number_code";
  }
}

class RegisterResponseModel extends RegisterResponse {
  const RegisterResponseModel({
    required super.access_token,
    required super.refresh_token,
  });

  factory RegisterResponseModel.fromRawJson(String str) =>
      RegisterResponseModel.fromJson(json.decode(str));

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
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
