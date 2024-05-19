import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_checkdoc/domain/entities/register_request.dart';
import 'package:flutter_checkdoc/domain/entities/register_response.dart';
import 'package:flutter_checkdoc/domain/use_cases/register_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUser registerUser;
  RegisterBloc({required this.registerUser}) : super(RegisterInitial()) {
    on<RegisterUserEvent>((event, emit) async{
      emit(RegisterLoading()); 
      RegisterRequest registerRequest = RegisterRequest(
        email: event.email,
        password: event.password,
        name: event.name,
        phone_number: event.phone_number,
        phone_number_code: event.phone_number_code,
      );
      await registerUser(RegisterUserParams(registerRequest: registerRequest))
          .then((response) {
        response.fold(
          (failure) => emit(RegisterFailure(failure.toString())),
          (response) => emit(RegisterSuccess(response)),
        );
      });
    });
  }
}
