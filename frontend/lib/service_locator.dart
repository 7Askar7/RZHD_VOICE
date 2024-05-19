import 'package:flutter_checkdoc/domain/use_cases/fetch_documents.dart';
import 'package:flutter_checkdoc/domain/use_cases/upload_file.dart';
import 'package:flutter_checkdoc/domain/use_cases/validate_document.dart';
import 'package:flutter_checkdoc/presentation/bloc/login_user_bloc/login_user_bloc.dart';

import 'package:flutter_checkdoc/data/datasources/user_remote.dart';
import 'package:flutter_checkdoc/data/repositories/user_repository_impl.dart';
import 'package:flutter_checkdoc/domain/repository/user_repository.dart';
import 'package:flutter_checkdoc/domain/use_cases/login_user.dart';
import 'package:flutter_checkdoc/presentation/bloc/document_list_bloc/document_list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'domain/use_cases/register_user.dart';
import 'presentation/bloc/register_bloc/register_bloc.dart';

final getIt = GetIt.instance;

class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() {
    return _instance;
  }

  GlobalVariables._internal();

  String accessToken = '';
}

Future<void> setup() async {
  final globalVariables = GlobalVariables();
  getIt.registerSingleton<GlobalVariables>(globalVariables);

  getIt.registerFactory(() => LoginUserBloc(loginUser: getIt()));
  getIt.registerFactory(() => RegisterBloc(registerUser: getIt()));
  getIt.registerFactory(() => DocumentListBloc(fetchDocuments: getIt()));
  // Usecases

  getIt.registerLazySingleton(() => LoginUser(getIt()));
  getIt.registerLazySingleton(() => RegisterUser(getIt()));
  getIt.registerLazySingleton(() => FetchDocuments(getIt()));
  getIt.registerLazySingleton(() => UploadDocument(getIt()));
  getIt.registerLazySingleton(() => ValidateDocument(userRepository: getIt()));

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<UserRemoteData>(() => UserRemoteDataImpl());

  // Common / Core

  // External Dependency
  final dio = Dio(BaseOptions(
    receiveTimeout: const Duration(seconds: 30),
  ));
  getIt.registerLazySingleton(() => dio);
}
