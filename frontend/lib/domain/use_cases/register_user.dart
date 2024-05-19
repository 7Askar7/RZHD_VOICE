

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/entities/register_response.dart';
import 'package:flutter_checkdoc/domain/repository/user_repository.dart';

import '../../common/errors/failures.dart';
import '../entities/register_request.dart';
import 'use_case.dart';

class RegisterUser extends UseCase<RegisterResponse, RegisterUserParams> {
  final UserRepository userRepository;

  RegisterUser(this.userRepository);

  @override
  Future<Either<Failure, RegisterResponse>> call(RegisterUserParams params) async {
    return await userRepository.register(params.registerRequest);
  }
}

class RegisterUserParams extends Equatable {
  final RegisterRequest registerRequest;

  const RegisterUserParams({required this.registerRequest});

  @override
  List<Object?> get props => [registerRequest];
}