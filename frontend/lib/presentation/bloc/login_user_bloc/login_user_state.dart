part of 'login_user_bloc.dart';

sealed class LoginUserState extends Equatable {
  const LoginUserState();
  
  @override
  List<Object> get props => [];
}

final class LoginUserInitial extends LoginUserState {}

final class LoginUserLoading extends LoginUserState {}

final class LoginUserSuccess extends LoginUserState {
  final LoginResponse loginResponse;

  LoginUserSuccess({required this.loginResponse});

  @override
  List<Object> get props => [loginResponse];
}

final class LoginUserFailure extends LoginUserState {
  final String error;
  const LoginUserFailure(this.error,);
}