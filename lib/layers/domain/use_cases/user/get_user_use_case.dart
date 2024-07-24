import 'package:breathpacer/layers/domain/models/user_model.dart';
import 'package:get/get.dart';

import '../../repository/user_repository.dart';

class GetUserUseCase {
  Future<UserModel> execute(String token) async {
    return await Get.find<UserRepository>().getUser(token);
  }
}
