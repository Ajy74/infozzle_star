import 'package:get/get.dart';

import '../../services/authentication_service.dart';

class LogoutUseCase {
  execute() async {
    Get.find<AuthenticationService>().logout();
  }
}
