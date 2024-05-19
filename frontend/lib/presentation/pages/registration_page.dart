import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_checkdoc/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter_checkdoc/service_locator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isObscure = true;
  bool isObscureSec = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerConfirm =
      TextEditingController();
  bool passErr = false;
  TextStyle style =
      const TextStyle(fontSize: 18, color: Colors.white, height: 2);

  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            // Navigate to the home page or any other page after successful loginLoginFailure
            String accessToken = state.registerResponse.access_token;
            getIt<GlobalVariables>().accessToken = accessToken;
            Navigator.of(context).pushReplacementNamed('/records');
          } else if (state is RegisterFailure) {
            // Show an error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return  Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                       icon: const Icon(Icons.arrow_back),
                       onPressed: () {
                         Navigator.of(context).pushReplacementNamed('/login');
                       },   
      
                       ),
                       
                      const Text(
                    "РЕГИСТРАЦИЯ",
                    style: TextStyle(
                      color:  Colors.red,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                    ],
                  ), 
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 398,
                    height: 52,
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                      decoration: const InputDecoration(
                        prefix: Text("   "),
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        hintText: "Имя",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 398,
                    height: 52,
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                      decoration: const InputDecoration(
                        prefix: Text("   "),
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        hintText: "E-mail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 398,
                    height: 52,
                    child: TextField(
                      controller: _phoneNumberController,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                      decoration: const InputDecoration(
                        prefix: Text("   "),
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        hintText: "Номер телефона",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 398,
                    height: 52,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: isObscure,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                      decoration: InputDecoration(
                        prefix: const Text("   "),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            splashColor: const Color.fromARGB(0, 0, 0, 0),
                            hoverColor: const Color.fromARGB(0, 0, 0, 0),
                            focusColor: const Color.fromARGB(0, 0, 0, 0),
                            highlightColor: const Color.fromARGB(0, 0, 0, 0),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(
                              isObscure
                                  ? Icons.remove_red_eye
                                  : Icons.remove_red_eye_outlined,
                              color: Colors.grey,
                              size: 23,
                            ),
                          ),
                        ),
                        hintStyle: const TextStyle(fontSize: 18, height: 1.5),
                        hintText: "Пароль",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 398,
                    height: 52,
                    child: TextField(
                      controller: _passwordControllerConfirm,
                      obscureText: isObscureSec,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                      decoration: InputDecoration(
                        prefix: const Text("   "),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            splashColor: const Color.fromARGB(0, 0, 0, 0),
                            hoverColor: const Color.fromARGB(0, 0, 0, 0),
                            focusColor: const Color.fromARGB(0, 0, 0, 0),
                            highlightColor: const Color.fromARGB(0, 0, 0, 0),
                            onPressed: () {
                              setState(() {
                                isObscureSec = !isObscureSec;
                              });
                            },
                            icon: Icon(
                              isObscureSec
                                  ? Icons.remove_red_eye
                                  : Icons.remove_red_eye_outlined,
                              color: Colors.grey,
                              size: 23,
                            ),
                          ),
                        ),
                        hintStyle: const TextStyle(fontSize: 18, height: 1.5),
                        hintText: "Подтвердите Пароль",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ),
                  if (passErr)
                    const Text(
                      "Пароли не совпадают, проверьте пароли еще раз",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 398,
                    height: 52,
                    child: ElevatedButton(
                      
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side:
                                        BorderSide(color: Colors.red))),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.red),
                        overlayColor: MaterialStatePropertyAll(
                            Colors.red),
                      ),
                      onPressed: () {
                        // ignore: avoid_print
                        if (_passwordController.text ==
                            _passwordControllerConfirm.text) {
                          registerBloc.add(RegisterUserEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                            phone_number:
                                _phoneNumberController.text.substring(1),
                            phone_number_code:
                                _phoneNumberController.text[0] == '8'
                                    ? '7'
                                    : _phoneNumberController.text[0],
                          ));
                        } else {
                          setState(() {
                            passErr = true;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 25),
                        child:Text(
                              "ПРОДОЛЖИТЬ",
                              style: style,
                            ),
                      ),
                    ),
                  ),
                  if (state is RegisterLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}