import 'package:get/get.dart';

import '../../models/user_model.dart';
import '../../services/authentication_service.dart';

class RegisterUseCase {
  Future<UserModel> execute(String email, String password) async {
    return await Get.find<AuthenticationService>().register(email, password);
  }
}
