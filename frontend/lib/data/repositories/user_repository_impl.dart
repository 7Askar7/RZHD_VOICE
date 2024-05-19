import 'package:dartz/dartz.dart';

import 'package:flutter_checkdoc/common/errors/failures.dart';
import 'package:flutter_checkdoc/data/model/document_model.dart';
import 'package:flutter_checkdoc/data/model/login.dart';
import 'package:flutter_checkdoc/data/model/register_model.dart';

import 'package:flutter_checkdoc/domain/entities/document.dart';
import 'package:flutter_checkdoc/domain/entities/login_request.dart';
import 'package:flutter_checkdoc/domain/entities/login_response.dart';
import 'package:flutter_checkdoc/domain/entities/register_request.dart';
import 'package:flutter_checkdoc/domain/entities/register_response.dart';
import 'package:flutter_checkdoc/domain/entities/validate_response.dart';

import '../../domain/entities/upload_file_response.dart';
import '../../domain/repository/user_repository.dart';
import '../datasources/user_remote.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteData remoteDataSource;
  UserRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<UserDocument>>> fetchDocuments() {
    try {
      return remoteDataSource.fetchDocuments().then((value) => Right(value));
    } on Exception {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, UploadFileResponse>> uploadDocument(
      UserDocument document) {
    UserDocumentModel userDocumentModel = UserDocumentModel(
      name: document.name,
      targetClass: document.targetClass,
      content: document.content,
    );
    try {
      return remoteDataSource
          .uploadDocument(userDocumentModel)
          .then((value) => Right(value));
    } on Exception {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, ValidateResponse>> validateDocument(String docId) {
    try {
      return remoteDataSource
          .validateDocuments(docId)
          .then((value) => Right(value));
    } on Exception {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, RegisterResponse>> register(
      RegisterRequest registerRequest) {
    try {
      final registerRequestModel = RegisterRequestModel(
        email: registerRequest.email,
        password: registerRequest.password,
        name: registerRequest.name,
        phone_number: registerRequest.phone_number,
        phone_number_code: registerRequest.phone_number_code,
      );
      return remoteDataSource
          .register(registerRequestModel)
          .then((value) => Right(value));
    } on Exception {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest loginRequest) {
    LoginRequestModel loginRequestModel = LoginRequestModel(
      email: loginRequest.email,
      password: loginRequest.password,
    );

    try {
      return remoteDataSource
          .login(loginRequestModel)
          .then((value) => Right(value));
    } on Exception {
      return Future.value(const Left(ServerFailure()));
    }
  }
  // final UserLocalData localDataSource;
  // final InternetConnectionChecker connectionChecker;
}
