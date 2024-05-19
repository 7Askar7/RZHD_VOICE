import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/entities/login_request.dart';

import '../../../domain/entities/login_response.dart';
import '../../../domain/use_cases/login_user.dart';

part 'login_user_event.dart';
part 'login_user_state.dart';

class LoginUserBloc extends Bloc<LoginUserEvent, LoginUserState> {
  final LoginUser loginUser;
  LoginUserBloc({required this.loginUser}) : super(LoginUserInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginUserLoading());
      // Perform the login logic here
      // Replace the code below with your actual login logic
      LoginRequest loginRequest = LoginRequest(
        email: event.email,
        password: event.password,
      );

      await loginUser(LoginUserParams(loginRequest: loginRequest))
          .then((response) {
        response.fold(
          (failure) => emit(LoginUserFailure(failure.toString())),
          (response) => emit(LoginUserSuccess(loginResponse: response)),
        );
      });
    });
  }
}
