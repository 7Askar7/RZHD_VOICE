import 'dart:html';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_checkdoc/common/errors/exceptions.dart';
import 'package:flutter_checkdoc/data/model/document_model.dart';
import 'package:flutter_checkdoc/data/model/login.dart';
import 'package:flutter_checkdoc/data/model/register_model.dart';
import 'package:flutter_checkdoc/data/model/validate_response_model.dart';
import 'package:flutter_checkdoc/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/upload_file_response_model.dart';

abstract class UserRemoteData {
  Future<List<UserDocumentModel>> fetchDocuments();
  Future<ValidateResponseModel> validateDocuments(String docId);
  Future<UploadFileResponseModel> uploadDocument(UserDocumentModel document);
  Future<RegisterResponseModel> register(RegisterRequestModel registerRequest);
  Future<LoginResponseModel> login(LoginRequestModel loginRequest);
}

class UserRemoteDataImpl implements UserRemoteData {
  String? url = dotenv.env['URL'];
  String? authUrl = dotenv.env['AUTH_SERVICE'];
  // String? accessToken = getIt<GlobalVariables>().accessToken;

  @override
  Future<List<UserDocumentModel>> fetchDocuments() {
    UserDocumentModel document = UserDocumentModel(
      name: "Договор оферты",
      targetClass: "contract offer",
      content: Uint8List(0),
    );
    return Future.value([document]);
  }

  @override
  Future<UploadFileResponseModel> uploadDocument(
      UserDocumentModel userDocument) async {
    var _dio = getIt<Dio>();

    String? accessToken = getIt<GlobalVariables>().accessToken;
    print("access token: $accessToken");
    List<int> documentBytes = userDocument.content as List<int>;
    FormData formData = FormData.fromMap({
      // "target_class": userDocument.targetClass,
      // "auth_token": accessToken,
      "document":
          MultipartFile.fromBytes(documentBytes, filename: userDocument.name),
    });
    var response = await _dio.post(
      "${url}v1/documents",
      data: formData,
      queryParameters: {
        "auth_token": accessToken,
      },
      options: Options(
        headers: {
          "Content-Type": "multipart/x-www-form-urlencoded",
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 204) {
      return UploadFileResponseModel.fromJson(response.data);
    } else {
      throw ServerException(
          'Failed to upload document ${response.statusMessage}');
    }
  }

  @override
  Future<ValidateResponseModel> validateDocuments(String docId) {
    String endpoint = "/v1/status/$docId";

    var _dio = getIt<Dio>();

    return _dio
        .get(
      endpoint,
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return ValidateResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
            'Failed to validate document ${response.statusMessage}');
      }
    });
  }

  @override
  Future<RegisterResponseModel> register(
      RegisterRequestModel registerRequest) async {
    String endpoint = "${authUrl}auth/register";

    var _dio = getIt<Dio>();

    try {
      var response = await _dio.post(
        endpoint,
        data: registerRequest.toFormUrlEncoded(),
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        print(response.data.toString());
        return RegisterResponseModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
      throw ServerException('Failed to register ${e}');
    }

    throw ServerException('Failed to register'); // Add this line
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) {
    String endpoint = "${authUrl}auth/login";

    var _dio = getIt<Dio>();
    print(loginRequest.toJson().toString());
    return _dio
        .post(
      endpoint,
      data: loginRequest.toJson(),
      options: Options(
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 200 || response.statusCode == 204) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to login ${response.statusMessage}');
      }
    });
  }
}
