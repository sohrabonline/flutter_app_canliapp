


import 'package:flutterappcanliapp/repository/user_repository.dart';
import 'package:flutterappcanliapp/services/fake_auth_service.dart';
import 'package:flutterappcanliapp/services/firebase_auth_service.dart';
import 'package:flutterappcanliapp/services/firebase_storage_service.dart';
import 'package:flutterappcanliapp/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
