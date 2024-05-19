import 'package:equatable/equatable.dart';


class RegisterResponse extends Equatable {
  final String access_token;
  final String refresh_token;

  const RegisterResponse({
    required this.access_token,
    required this.refresh_token,
  });

  @override
  List<Object?> get props => [
        access_token,
        refresh_token,
      ];
}