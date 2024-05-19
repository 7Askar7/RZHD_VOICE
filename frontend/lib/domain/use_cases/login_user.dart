

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/entities/login_response.dart';
import 'package:flutter_checkdoc/domain/repository/user_repository.dart';

import '../../common/errors/failures.dart';
import '../entities/login_request.dart';
import 'use_case.dart';

class LoginUser extends UseCase<LoginResponse, LoginUserParams> {
  final UserRepository userRepository;

  LoginUser(this.userRepository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginUserParams params) async {
    return await userRepository.login(params.loginRequest);
  }
}

class LoginUserParams extends Equatable {
  final LoginRequest loginRequest;

  const LoginUserParams({required this.loginRequest});

  @override
  List<Object?> get props => [loginRequest];
}

