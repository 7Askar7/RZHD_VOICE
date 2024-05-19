import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_checkdoc/presentation/bloc/document_list_bloc/document_list_bloc.dart';
import 'package:flutter_checkdoc/presentation/bloc/login_user_bloc/login_user_bloc.dart';
import 'package:flutter_checkdoc/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:flutter_checkdoc/presentation/pages/auth_page.dart';
import 'package:flutter_checkdoc/presentation/pages/records_page.dart';
import 'package:flutter_checkdoc/presentation/pages/registration_page.dart';
// import 'package:flutter_website/presentation/pages/home_page.dart';
// import 'presentation/bloc/login_bloc/login_bloc.dart';
// import 'presentation/pages/login_page.dart';
import 'presentation/pages/result_page.dart';
import 'presentation/pages/upload_page.dart';
import 'service_locator.dart' as dependancy_injection;
import 'service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/dotenv");
  await dependancy_injection.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DocumentListBloc>(
          create: (context) => getIt<DocumentListBloc>(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => getIt<RegisterBloc>(),
        ),
        BlocProvider<LoginUserBloc>(
          create: (context) => getIt<LoginUserBloc>(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/upload': (context) => UploadPage(),
          '/register': (context) => const RegistrationPage(),
          '/login': (context) => const AuthPage(),
          '/records': (context) => RecordListPage(),
          '/results': (context) => ResultsPage(),
          // Add more routes here
        },
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        title: 'Check Doc',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 255, 255, 255),
            surface: const Color.fromARGB(255, 255, 255, 255),
            primary: const Color.fromARGB(255, 0, 0, 0),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
