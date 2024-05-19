

import 'package:dartz/dartz.dart';
import 'package:flutter_checkdoc/domain/entities/login_request.dart';
import 'package:flutter_checkdoc/domain/entities/login_response.dart';
import 'package:flutter_checkdoc/domain/entities/register_request.dart';
import 'package:flutter_checkdoc/domain/entities/register_response.dart';
import 'package:flutter_checkdoc/domain/entities/validate_response.dart';

import '../../common/errors/failures.dart';
import '../entities/document.dart';
import '../entities/upload_file_response.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserDocument>>> fetchDocuments();
  Future<Either<Failure, ValidateResponse>> validateDocument(String docId);
  Future<Either<Failure, UploadFileResponse>> uploadDocument(UserDocument document);
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest registerRequest);
  Future<Either<Failure, LoginResponse>> login(LoginRequest loginRequest);
}