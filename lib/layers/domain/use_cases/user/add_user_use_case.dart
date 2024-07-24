import 'package:get/get.dart';

import '../../repository/user_repository.dart';

class AddUserUseCase {
  Future<void> execute(String id, String name, String email) async {
    await Get.find<UserRepository>().addUser(id, name, email);
  }
}
