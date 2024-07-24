import '../models/user_model.dart';

abstract class UserRepository {
  Future<void> addUser(String token, String name, String email);

  Future<UserModel> getUser(String id);
}
