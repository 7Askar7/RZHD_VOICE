

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/repository/user_repository.dart';

import '../../common/errors/failures.dart';
import '../entities/document.dart';
import 'use_case.dart';

class FetchDocuments extends UseCase<List<UserDocument>, FetchDocumentsParams> {
  final UserRepository userRepository;

  FetchDocuments(this.userRepository);

  @override
  Future<Either<Failure, List<UserDocument>>> call(FetchDocumentsParams params) async {
    return await userRepository.fetchDocuments();
  }
}

class FetchDocumentsParams extends Equatable {
  // final String group;
  // final bool fromRemote;

  const FetchDocumentsParams();

  @override
  List<Object?> get props => [];
}