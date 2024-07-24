import 'package:breathpacer/layers/data/repository/user/user_repository_laravel.dart';
import 'package:breathpacer/layers/data/services/authentication/laravel_authentication_service.dart';
import 'package:breathpacer/layers/data/services/database/laravel_database_fetch_service.dart';
import 'package:breathpacer/layers/domain/repository/user_repository.dart';
import 'package:get/get.dart';

import '../domain/services/authentication_service.dart';
import '../domain/services/database_fetch_service.dart';

void initializeDI() {
  Get.put<AuthenticationService>(LaravelAuthenticationService(), permanent: true);
  Get.put<UserRepository>(UserRepositoryLaravel(), permanent: true);
  Get.put<DatabaseFetchService>(LaravelDatabaseFetchService(), permanent: true);
}
