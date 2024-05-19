import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String name;
  final String password;
  final String phone_number;
  final String phone_number_code;

  RegisterRequest(
    {
    required this.name,
    required this.phone_number,
    required this.phone_number_code, 
    required this.email,
    required this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props =>
      [email, password, name, phone_number, phone_number_code];
}
