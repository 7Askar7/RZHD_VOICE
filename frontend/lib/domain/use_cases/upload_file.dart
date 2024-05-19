

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/entities/document.dart';
import 'package:flutter_checkdoc/domain/repository/user_repository.dart';

import '../../common/errors/failures.dart';
import '../entities/upload_file_response.dart';
import 'use_case.dart';

class UploadDocument extends UseCase<UploadFileResponse, UploadDocumentParams> {
  final UserRepository userRepository;

  UploadDocument(this.userRepository);

  @override
  Future<Either<Failure, UploadFileResponse>> call(UploadDocumentParams params) async {
    return await userRepository.uploadDocument(params.document);
  }
}

class UploadDocumentParams extends Equatable {
  final UserDocument document;
  // final String group;
  // final bool fromRemote;

  const UploadDocumentParams({required this.document});

  @override
  List<Object?> get props => [document];
}