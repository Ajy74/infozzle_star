import 'package:get/get.dart';

import '../../services/authentication_service.dart';

class ResetPasswordUseCase {
  Future<void> execute(String email) async {
    return await Get.find<AuthenticationService>().resetPassword(email);
  }
}
