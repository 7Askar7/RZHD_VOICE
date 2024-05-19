import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String access_token;
  final String refresh_token;

  const LoginResponse({
    required this.access_token,
    required this.refresh_token,
  });

  @override
  List<Object?> get props => [
        access_token,
        refresh_token,
      ];
}
