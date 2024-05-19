import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/entities/validate_response.dart';
import 'package:flutter_checkdoc/domain/repository/user_repository.dart';

import '../../common/errors/failures.dart';
import 'use_case.dart';

class ValidateDocument extends UseCase<ValidateResponse, ValidateDocumentParams> {
  final UserRepository userRepository;

  ValidateDocument( {required this.userRepository});

  @override
  Future<Either<Failure, ValidateResponse>> call(ValidateDocumentParams params) async {
    return await userRepository.validateDocument(params.docId);
  }
}

class ValidateDocumentParams extends Equatable {
  final String docId;

  const ValidateDocumentParams({required this.docId});

  @override
  List<Object?> get props => [docId];
}

