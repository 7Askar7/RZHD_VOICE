part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterResponse registerResponse;
  const RegisterSuccess(this.registerResponse);

  @override
  List<Object> get props => [registerResponse];

}

final class RegisterFailure extends RegisterState {
  final String error;
  const RegisterFailure(this.error,);
}