part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class RegisterUserEvent extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final String phone_number;
  final String phone_number_code;

  const RegisterUserEvent({
    required this.name,
    required this.phone_number,
    required this.phone_number_code,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password, name, phone_number, phone_number_code];
}
